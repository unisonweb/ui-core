module Code.Workspace exposing
    ( Model
    , Msg
    , OutMsg(..)
    , init
    , open
    , replaceWorkspaceItemReferencesWithHashOnly
    , subscriptions
    , update
    , view
    )

import Browser.Dom as Dom
import Code.CodebaseApi as CodebaseApi
import Code.Config exposing (Config)
import Code.Definition.Doc as Doc
import Code.Definition.Reference as Reference exposing (Reference)
import Code.DefinitionSummaryTooltip as DefinitionSummaryTooltip
import Code.FullyQualifiedName exposing (FQN)
import Code.Hash as Hash
import Code.HashQualified as HQ
import Code.Workspace.WorkspaceItem as WorkspaceItem exposing (ItemWithReference, WorkspaceItem, WorkspaceItemViewState)
import Code.Workspace.WorkspaceItems as WorkspaceItems exposing (WorkspaceItems)
import Code.Workspace.WorkspaceMinimap as WorkspaceMinimap
import Html exposing (Html, article, div, section)
import Html.Attributes exposing (class, id)
import Http
import Lib.HttpApi as HttpApi exposing (ApiRequest)
import Lib.ScrollTo as ScrollTo
import Task
import UI
import UI.KeyboardShortcut as KeyboardShortcut exposing (KeyboardShortcut(..))
import UI.KeyboardShortcut.Key exposing (Key(..))
import UI.KeyboardShortcut.KeyboardEvent as KeyboardEvent exposing (KeyboardEvent)
import UI.ViewMode as ViewMode exposing (ViewMode)



-- MODEL


type alias Model =
    { workspaceItems : WorkspaceItems
    , keyboardShortcut : KeyboardShortcut.Model
    , workspaceItemViewState : WorkspaceItemViewState
    , isMinimapToggled : Bool
    }


init : Config -> Maybe Reference -> ( Model, Cmd Msg )
init config mRef =
    let
        model =
            { workspaceItems = WorkspaceItems.init Nothing
            , keyboardShortcut = KeyboardShortcut.init config.operatingSystem
            , workspaceItemViewState = WorkspaceItem.viewState
            , isMinimapToggled = False
            }
    in
    case mRef of
        Nothing ->
            ( model, Cmd.none )

        Just ref ->
            open config model ref



-- UPDATE


type Msg
    = NoOp
    | FetchItemFinished Reference (Result Http.Error (List ItemWithReference))
    | IsDocCropped Reference (Result Dom.Error Bool)
    | Keydown KeyboardEvent
    | KeyboardShortcutMsg KeyboardShortcut.Msg
    | WorkspaceItemMsg WorkspaceItem.Msg
    | DefinitionSummaryTooltipMsg DefinitionSummaryTooltip.Msg
    | SelectItem WorkspaceItem
    | CloseItem WorkspaceItem
    | CloseAll
    | ToggleMinimap


type OutMsg
    = None
    | Focused Reference
    | Emptied
    | ShowFinderRequest FQN
    | ChangePerspectiveToSubNamespace (Maybe Reference) FQN


updateOneItem : Reference -> ItemWithReference -> ( WorkspaceItems, Cmd Msg ) -> ( WorkspaceItems, Cmd Msg )
updateOneItem refRequest itemWithReference agg =
    let
        i =
            itemWithReference.item

        refResponse =
            itemWithReference.ref

        workspaceItems =
            Tuple.first agg

        aggCmd =
            Tuple.second agg

        cmd =
            -- Docs items are always shown in full and never cropped
            if WorkspaceItem.isDocItem i then
                Cmd.none

            else
                isDocCropped refResponse

        isDupe wi =
            let
                ref_ =
                    WorkspaceItem.reference wi

                refEqs =
                    Reference.equals refResponse ref_

                hashEqs =
                    wi
                        |> WorkspaceItem.hash
                        |> Maybe.map (Hash.equals (WorkspaceItem.itemHash i))
                        |> Maybe.withDefault False
            in
            (Reference.same refResponse ref_ && not refEqs) || (hashEqs && not refEqs)

        -- In some cases (like using the back button between
        -- perspectives) we try and fetch the same item twice, not
        -- knowing we've fetched it before since one was by hash
        -- and the other by name. If found to already be fetched,
        -- we favor the newly fetched item and discard the old
        deduped =
            workspaceItems
                |> WorkspaceItems.find isDupe
                |> Maybe.map WorkspaceItem.reference
                |> Maybe.map (WorkspaceItems.remove workspaceItems)
                |> Maybe.withDefault workspaceItems
    in
    ( WorkspaceItems.replaceOrPrependWithFocus deduped refResponse (WorkspaceItem.fromItem refRequest refResponse i)
    , Cmd.batch [ aggCmd, cmd ]
    )


update : Config -> ViewMode -> Msg -> Model -> ( Model, Cmd Msg, OutMsg )
update config viewMode msg ({ workspaceItems } as model) =
    case msg of
        NoOp ->
            ( model, Cmd.none, None )

        FetchItemFinished refRequest itemResult ->
            case itemResult of
                Err e ->
                    ( { model | workspaceItems = WorkspaceItems.replace workspaceItems refRequest (WorkspaceItem.Failure refRequest e) }
                    , Cmd.none
                    , None
                    )

                Ok items ->
                    let
                        -- remove loading element (with `ref` used for request)
                        loadingRemoved =
                            WorkspaceItems.remove workspaceItems refRequest

                        -- update items with fetched result
                        ( nextWorkspaceItems, cmd ) =
                            List.foldl (updateOneItem refRequest) ( loadingRemoved, Cmd.none ) items
                    in
                    ( { model | workspaceItems = nextWorkspaceItems }, cmd, None )

        IsDocCropped ref res ->
            let
                visibility =
                    case res of
                        Ok True ->
                            WorkspaceItem.Cropped

                        Ok False ->
                            WorkspaceItem.NotCropped

                        -- If we can't tell, better make it fully visible, than Unknown
                        Err _ ->
                            WorkspaceItem.MadeFullyVisible

                updateVisibility d =
                    { d | docVisibility = visibility }
            in
            ( { model | workspaceItems = WorkspaceItems.updateData updateVisibility ref workspaceItems }
            , Cmd.none
            , None
            )

        Keydown event ->
            let
                ( keyboardShortcut, kCmd ) =
                    KeyboardShortcut.collect model.keyboardShortcut event.key

                shortcut =
                    KeyboardShortcut.fromKeyboardEvent model.keyboardShortcut event

                ( nextModel, cmd, out ) =
                    handleKeyboardShortcut
                        viewMode
                        { model | keyboardShortcut = keyboardShortcut }
                        shortcut
            in
            ( nextModel, Cmd.batch [ cmd, Cmd.map KeyboardShortcutMsg kCmd ], out )

        WorkspaceItemMsg wiMsg ->
            case wiMsg of
                WorkspaceItem.NoOp ->
                    ( model, Cmd.none, None )

                WorkspaceItem.OpenReference relativeToRef ref ->
                    let
                        toHashOnly hq =
                            case hq of
                                HQ.HashQualified _ h ->
                                    HQ.HashOnly h

                                _ ->
                                    hq

                        hashOnlyRef =
                            Reference.map toHashOnly ref
                    in
                    openReference config model relativeToRef hashOnlyRef

                WorkspaceItem.Close ref ->
                    let
                        nextModel =
                            { model | workspaceItems = WorkspaceItems.remove workspaceItems ref }
                    in
                    ( nextModel, Cmd.none, openDefinitionsFocusToOutMsg nextModel.workspaceItems )

                WorkspaceItem.UpdateZoom ref zoom ->
                    let
                        updateZoom d =
                            { d | zoom = zoom }
                    in
                    ( { model | workspaceItems = WorkspaceItems.updateData updateZoom ref workspaceItems }
                    , Cmd.none
                    , None
                    )

                WorkspaceItem.ShowFullDoc ref ->
                    let
                        updateDocVisibility d =
                            { d | docVisibility = WorkspaceItem.MadeFullyVisible }
                    in
                    ( { model | workspaceItems = WorkspaceItems.updateData updateDocVisibility ref workspaceItems }
                    , Cmd.none
                    , None
                    )

                WorkspaceItem.ToggleDocFold ref docId ->
                    let
                        updateDocFoldToggles d =
                            { d | docFoldToggles = Doc.toggleFold d.docFoldToggles docId }
                    in
                    ( { model | workspaceItems = WorkspaceItems.updateData updateDocFoldToggles ref workspaceItems }
                    , Cmd.none
                    , None
                    )

                WorkspaceItem.ChangePerspectiveToSubNamespace fqn ->
                    let
                        ref =
                            WorkspaceItems.focusedReference model.workspaceItems
                    in
                    ( model, Cmd.none, ChangePerspectiveToSubNamespace ref fqn )

                WorkspaceItem.FindWithinNamespace fqn ->
                    ( model, Cmd.none, ShowFinderRequest fqn )

                WorkspaceItem.DefinitionSummaryTooltipMsg tMsg ->
                    let
                        workspaceItemViewState =
                            model.workspaceItemViewState

                        ( definitionSummaryTooltip, tCmd ) =
                            DefinitionSummaryTooltip.update config tMsg model.workspaceItemViewState.definitionSummaryTooltip

                        workspaceItemViewState_ =
                            { workspaceItemViewState | definitionSummaryTooltip = definitionSummaryTooltip }
                    in
                    ( { model | workspaceItemViewState = workspaceItemViewState_ }, Cmd.map DefinitionSummaryTooltipMsg tCmd, None )

                WorkspaceItem.ToggleNamespaceActionMenu ref ->
                    let
                        workspaceItemViewState =
                            model.workspaceItemViewState
                    in
                    ( { model
                        | workspaceItemViewState = WorkspaceItem.toggleNamespaceActionMenu workspaceItemViewState ref
                      }
                    , Cmd.none
                    , None
                    )

        DefinitionSummaryTooltipMsg tMsg ->
            let
                workspaceItemViewState =
                    model.workspaceItemViewState

                ( definitionSummaryTooltip, tCmd ) =
                    DefinitionSummaryTooltip.update config tMsg model.workspaceItemViewState.definitionSummaryTooltip

                workspaceItemViewState_ =
                    { workspaceItemViewState | definitionSummaryTooltip = definitionSummaryTooltip }
            in
            ( { model | workspaceItemViewState = workspaceItemViewState_ }, Cmd.map DefinitionSummaryTooltipMsg tCmd, None )

        KeyboardShortcutMsg kMsg ->
            let
                ( keyboardShortcut, cmd ) =
                    KeyboardShortcut.update kMsg model.keyboardShortcut
            in
            ( { model | keyboardShortcut = keyboardShortcut }, Cmd.map KeyboardShortcutMsg cmd, None )

        SelectItem item ->
            let
                nextWorkspaceItems =
                    item
                        |> WorkspaceItem.reference
                        |> WorkspaceItems.focusOn model.workspaceItems
            in
            ( { model | workspaceItems = nextWorkspaceItems }
            , item
                |> WorkspaceItem.reference
                |> scrollToDefinition
            , openDefinitionsFocusToOutMsg nextWorkspaceItems
            )

        CloseItem item ->
            let
                nextWorkspaceItems =
                    item
                        |> WorkspaceItem.reference
                        |> WorkspaceItems.remove model.workspaceItems
            in
            ( { model | workspaceItems = nextWorkspaceItems }
            , Cmd.none
            , openDefinitionsFocusToOutMsg nextWorkspaceItems
            )

        CloseAll ->
            let
                nextWorkspaceItems =
                    WorkspaceItems.empty
            in
            ( { model | workspaceItems = nextWorkspaceItems }
            , Cmd.none
            , openDefinitionsFocusToOutMsg nextWorkspaceItems
            )

        ToggleMinimap ->
            ( { model | isMinimapToggled = not model.isMinimapToggled }
            , Cmd.none
            , None
            )



-- UPDATE HELPERS


type alias WithWorkspaceItems m =
    { m | workspaceItems : WorkspaceItems }


replaceWorkspaceItemReferencesWithHashOnly : Model -> Model
replaceWorkspaceItemReferencesWithHashOnly model =
    let
        workspaceItems =
            WorkspaceItems.map WorkspaceItem.toHashReference model.workspaceItems
    in
    { model | workspaceItems = workspaceItems }


open : Config -> WithWorkspaceItems m -> Reference -> ( WithWorkspaceItems m, Cmd Msg )
open config model ref =
    openItem config model Nothing ref


{-| openReference opens a definition relative to another definition. This is
done within Workspace, as opposed to from the outside via a URL change. This
function returns a Focused command for the newly opened reference and as such
changes the URL.
-}
openReference : Config -> WithWorkspaceItems m -> Reference -> Reference -> ( WithWorkspaceItems m, Cmd Msg, OutMsg )
openReference config model relativeToRef ref =
    let
        ( newModel, cmd ) =
            openItem config model (Just relativeToRef) ref

        out =
            openDefinitionsFocusToOutMsg newModel.workspaceItems
    in
    ( newModel, cmd, out )


openItem : Config -> WithWorkspaceItems m -> Maybe Reference -> Reference -> ( WithWorkspaceItems m, Cmd Msg )
openItem config ({ workspaceItems } as model) relativeToRef ref =
    -- We don't want to refetch or replace any already open definitions, but we
    -- do want to focus and scroll to it (unless its already currently focused)
    if WorkspaceItems.member workspaceItems ref then
        if not (WorkspaceItems.isFocused workspaceItems ref) then
            let
                nextWorkspaceItems =
                    WorkspaceItems.focusOn workspaceItems ref
            in
            ( { model | workspaceItems = nextWorkspaceItems }
            , scrollToDefinition ref
            )

        else
            ( model, Cmd.none )

    else
        let
            toInsert =
                WorkspaceItem.Loading ref

            nextWorkspaceItems =
                case relativeToRef of
                    Nothing ->
                        WorkspaceItems.prependWithFocus workspaceItems toInsert

                    Just r ->
                        WorkspaceItems.insertWithFocusBefore workspaceItems r toInsert
        in
        ( { model | workspaceItems = nextWorkspaceItems }
        , Cmd.batch
            [ HttpApi.perform config.api (fetchDefinition config ref)
            , scrollToDefinition ref
            ]
        )


openDefinitionsFocusToOutMsg : WorkspaceItems -> OutMsg
openDefinitionsFocusToOutMsg openDefs =
    openDefs
        |> WorkspaceItems.focusedReference
        |> Maybe.map Focused
        |> Maybe.withDefault Emptied


handleKeyboardShortcut :
    ViewMode
    -> Model
    -> KeyboardShortcut
    -> ( Model, Cmd Msg, OutMsg )
handleKeyboardShortcut viewMode model shortcut =
    let
        scrollToCmd =
            WorkspaceItems.focus
                >> Maybe.map WorkspaceItem.reference
                >> Maybe.map scrollToDefinition
                >> Maybe.withDefault Cmd.none

        nextDefinition =
            let
                next =
                    WorkspaceItems.next model.workspaceItems
            in
            ( { model | workspaceItems = next }, scrollToCmd next, openDefinitionsFocusToOutMsg next )

        prevDefinitions =
            let
                prev =
                    WorkspaceItems.prev model.workspaceItems
            in
            ( { model | workspaceItems = prev }, scrollToCmd prev, openDefinitionsFocusToOutMsg prev )

        moveDown =
            let
                next =
                    WorkspaceItems.moveDown model.workspaceItems
            in
            ( { model | workspaceItems = next }, scrollToCmd next, openDefinitionsFocusToOutMsg next )

        moveUp =
            let
                next =
                    WorkspaceItems.moveUp model.workspaceItems
            in
            ( { model | workspaceItems = next }, scrollToCmd next, openDefinitionsFocusToOutMsg next )
    in
    case ( viewMode, shortcut ) of
        ( ViewMode.Regular, Chord Alt ArrowDown ) ->
            moveDown

        ( ViewMode.Regular, Chord Alt ArrowUp ) ->
            moveUp

        {- TODO: Support vim keys for moving. The reason this isn't straight
           forward is that Alt+j results in the "∆" character instead of a "j"
           (k is "˚") on a Mac. We could add those characters as Chord Alt (Raw
           "∆"), but is it uniform that Alt+j produces "∆" across all standard
           international keyboard layouts? KeyboardEvent.code could be used
           instead of KeyboardEvent.key as it will produce the physical key
           pressed as opposed to the key produced —  this of course is strange
           for things like question marks...

              Chord Alt (J _) ->
                  moveDown
              Chord Alt (K _) ->
                  moveUp
        -}
        ( ViewMode.Regular, Sequence _ ArrowDown ) ->
            nextDefinition

        ( ViewMode.Regular, Sequence _ (J _) ) ->
            nextDefinition

        ( ViewMode.Regular, Sequence _ ArrowUp ) ->
            prevDefinitions

        ( ViewMode.Regular, Sequence _ (K _) ) ->
            prevDefinitions

        ( ViewMode.Regular, Sequence _ Space ) ->
            let
                cycleZoom wItems ref =
                    WorkspaceItems.updateData WorkspaceItem.cycleZoom ref wItems

                cycled =
                    model.workspaceItems
                        |> WorkspaceItems.focus
                        |> Maybe.map (WorkspaceItem.reference >> cycleZoom model.workspaceItems)
                        |> Maybe.withDefault model.workspaceItems
            in
            ( { model | workspaceItems = cycled }, Cmd.none, None )

        ( ViewMode.Regular, Sequence _ (X _) ) ->
            let
                without =
                    model.workspaceItems
                        |> WorkspaceItems.focus
                        |> Maybe.map (WorkspaceItem.reference >> WorkspaceItems.remove model.workspaceItems)
                        |> Maybe.withDefault model.workspaceItems
            in
            ( { model | workspaceItems = without }
            , Cmd.none
            , openDefinitionsFocusToOutMsg without
            )

        _ ->
            ( model, Cmd.none, None )



-- EFFECTS


fetchDefinition : Config -> Reference -> ApiRequest (List ItemWithReference) Msg
fetchDefinition config ref =
    let
        endpoint =
            CodebaseApi.Definition
                { perspective = config.perspective
                , ref = ref
                }
    in
    endpoint
        |> config.toApiEndpoint
        |> HttpApi.toRequest (WorkspaceItem.decodeList ref) (FetchItemFinished ref)


isDocCropped : Reference -> Cmd Msg
isDocCropped ref =
    let
        id =
            "definition-doc-" ++ Reference.toString ref
    in
    Dom.getViewportOf id
        |> Task.map (\v -> v.viewport.height < v.scene.height)
        |> Task.attempt (IsDocCropped ref)


scrollToDefinition : Reference -> Cmd Msg
scrollToDefinition ref =
    let
        targetId =
            "definition-" ++ Reference.toString ref
    in
    ScrollTo.scrollTo NoOp "page-content" targetId



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    KeyboardEvent.subscribe KeyboardEvent.Keydown Keydown



-- VIEW


view : ViewMode -> Model -> Html Msg
view viewMode model =
    case model.workspaceItems of
        WorkspaceItems.Empty ->
            -- TODO: Remove WorkspaceItems.Empty
            -- this state is now determined via Route
            div [] []

        WorkspaceItems.WorkspaceItems { focus } ->
            case viewMode of
                ViewMode.Regular ->
                    let
                        minimap =
                            if WorkspaceItems.length model.workspaceItems > 1 then
                                model
                                    |> toMinimap
                                    |> WorkspaceMinimap.view

                            else
                                UI.nothing
                    in
                    article [ id "workspace", class (ViewMode.toCssClass viewMode) ]
                        [ minimap
                        , section
                            [ id "workspace-content" ]
                            (viewWorkspaceItems model.workspaceItemViewState model.workspaceItems)
                        ]

                ViewMode.Presentation ->
                    article [ id "workspace", class (ViewMode.toCssClass viewMode) ]
                        [ section
                            [ id "workspace-content" ]
                            [ viewItem model.workspaceItemViewState ViewMode.Presentation focus True ]
                        ]


viewItem : WorkspaceItemViewState -> ViewMode -> WorkspaceItem -> Bool -> Html Msg
viewItem viewState viewMode workspaceItem isFocused =
    Html.map WorkspaceItemMsg (WorkspaceItem.view viewState viewMode workspaceItem isFocused)


viewWorkspaceItems : WorkspaceItemViewState -> WorkspaceItems -> List (Html Msg)
viewWorkspaceItems viewState items =
    WorkspaceItems.mapToList (viewItem viewState ViewMode.Regular) items


toMinimap : Model -> WorkspaceMinimap.Minimap Msg
toMinimap model =
    { keyboardShortcut = model.keyboardShortcut
    , workspaceItems = model.workspaceItems
    , selectItemMsg = SelectItem
    , closeItemMsg = CloseItem
    , closeAllMsg = CloseAll
    , isToggled = model.isMinimapToggled
    , toggleMinimapMsg = ToggleMinimap
    }
