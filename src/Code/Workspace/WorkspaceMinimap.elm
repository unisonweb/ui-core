module Code.Workspace.WorkspaceMinimap exposing (Model, Msg(..), init, update, view)

import Code.Definition.AbilityConstructor exposing (AbilityConstructor(..))
import Code.Definition.Category as Category exposing (Category)
import Code.Definition.DataConstructor exposing (DataConstructor(..))
import Code.Definition.Term exposing (Term(..))
import Code.Definition.Type as Type exposing (Type(..))
import Code.FullyQualifiedName as FQN
import Code.Workspace.WorkspaceItem as WorkspaceItem exposing (Item(..), WorkspaceItem(..))
import Code.Workspace.WorkspaceItems as WorkspaceItems exposing (WorkspaceItems, toListWithFocus)
import Html exposing (Html, a, div, h3, header, text)
import Html.Attributes exposing (class, classList, hidden)
import Html.Events exposing (onClick)
import UI.Icon as Icon
import UI.KeyboardShortcut as KeyboardShortcut exposing (KeyboardShortcut(..))
import UI.KeyboardShortcut.Key as Key


type alias Model =
    { keyboardShortcut : KeyboardShortcut.Model
    , workspaceItems : WorkspaceItems
    }


type Msg
    = SelectItem WorkspaceItem
    | CloseAll


init : KeyboardShortcut.Model -> WorkspaceItems -> Model
init keyboardShortcut workspaceItems =
    { keyboardShortcut = keyboardShortcut
    , workspaceItems = workspaceItems
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectItem workspaceItem ->
            let
                newWorkspaceItems =
                    WorkspaceItems.focusOn model.workspaceItems (workspaceItem |> WorkspaceItem.reference)
            in
            ( { model | workspaceItems = newWorkspaceItems }
            , Cmd.none
            )

        CloseAll ->
            ( { model | workspaceItems = WorkspaceItems.empty }, Cmd.none )


view : Model -> Html Msg
view model =
    let
        header =
            viewHeader

        section =
            model.workspaceItems
                |> toListWithFocus
                |> List.indexedMap (viewTableRow model.keyboardShortcut)
                |> Html.tbody []
                |> List.singleton
                |> Html.table []
                |> List.singleton
                |> Html.section []
    in
    div
        [ class "workspace-minimap-content" ]
        [ header
        , section
        ]


viewHeader : Html Msg
viewHeader =
    header
        [ class "workspace-minimap-header" ]
        [ div
            [ class "workspace-minimap-title" ]
            [ text "MAP" ]
        , a
            [ class "close", onClick CloseAll ]
            [ text "Close all" ]
        ]


viewTableRow : KeyboardShortcut.Model -> Int -> ( Bool, WorkspaceItem ) -> Html Msg
viewTableRow keyboardShortcut index ( focused, item ) =
    item
        |> viewEntry keyboardShortcut index focused
        |> List.singleton
        |> Html.td []
        |> List.singleton
        |> Html.tr []


viewEntry : KeyboardShortcut.Model -> Int -> Bool -> WorkspaceItem -> Html Msg
viewEntry keyboardShortcut index focused item =
    let
        content =
            case item of
                Loading _ ->
                    [ div
                        [ class "name" ]
                        [ text "Loading" ]
                    ]

                Failure _ _ ->
                    [ div
                        [ class "name" ]
                        [ text "Failure" ]
                    ]

                Success _ itemData ->
                    let
                        ( info, category ) =
                            case itemData.item of
                                TermItem (Term _ category_ detail) ->
                                    ( detail.info, Category.Term category_ )

                                TypeItem (Type _ category_ detail) ->
                                    ( detail.info, Category.Type category_ )

                                DataConstructorItem (DataConstructor _ detail) ->
                                    ( detail.info, Category.Type Type.DataType )

                                AbilityConstructorItem (AbilityConstructor _ detail) ->
                                    ( detail.info, Category.Type Type.AbilityType )
                    in
                    [ viewEntryContent category info.name
                    , div
                        [ hidden True ]
                        -- currently hidden as feature is not supported yet
                        [ viewEntryKeyboardShortcut keyboardShortcut index ]
                    ]
    in
    div
        [ classList
            [ ( "workspace-minimap-entry", True )
            , ( "focused", focused )
            ]
        , onClick (SelectItem item)
        ]
        content


viewEntryContent : Category -> FQN.FQN -> Html Msg
viewEntryContent category name =
    div
        [ class "workspace-minimap-entry-content" ]
        [ div
            [ class "category-icon" ]
            [ Icon.view (Category.icon category) ]
        , h3
            [ class "name" ]
            [ FQN.view name ]
        ]


viewEntryKeyboardShortcut : KeyboardShortcut.Model -> Int -> Html Msg
viewEntryKeyboardShortcut model index =
    KeyboardShortcut.view model (Chord (Key.fromString "J") (Key.fromString (String.fromInt index)))
