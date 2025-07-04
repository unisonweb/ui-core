module Code.Workspace.WorkspaceItem exposing (..)

import Code.Definition.AbilityConstructor as AbilityConstructor exposing (AbilityConstructor(..), AbilityConstructorDetail)
import Code.Definition.Category as Category exposing (Category)
import Code.Definition.DataConstructor as DataConstructor exposing (DataConstructor(..), DataConstructorDetail)
import Code.Definition.Doc as Doc exposing (Doc, DocFoldToggles)
import Code.Definition.Info as Info exposing (Info)
import Code.Definition.Reference as Reference exposing (Reference)
import Code.Definition.Source as Source
import Code.Definition.Term as Term exposing (Term(..), TermCategory, TermDetail, TermSource)
import Code.Definition.Type as Type exposing (Type(..), TypeCategory, TypeDetail, TypeSource)
import Code.DefinitionSummaryTooltip as DefinitionSummaryTooltip
import Code.FullyQualifiedName as FQN exposing (FQN)
import Code.Hash as Hash exposing (Hash)
import Code.HashQualified as HQ
import Code.Source.SourceViewConfig as SourceViewConfig exposing (SourceViewConfig)
import Code.Syntax.SyntaxConfig as SyntaxConfig exposing (SyntaxConfig)
import Code.Workspace.Zoom as Zoom exposing (Zoom(..))
import Html exposing (Attribute, Html, div, h3, header, section, span, text)
import Html.Attributes exposing (class, classList, id, title)
import Http
import Json.Decode as Decode exposing (field, index)
import Lib.Decode.Helpers exposing (nonEmptyList)
import Lib.Util as Util
import List.Nonempty as NEL
import Maybe.Extra as MaybeE
import String.Extra exposing (pluralize)
import UI
import UI.ActionMenu as ActionMenu
import UI.Button as Button
import UI.Click as Click
import UI.CopyOnClick as CopyOnClick
import UI.Divider as Divider
import UI.FoldToggle as FoldToggle
import UI.Icon as Icon
import UI.Placeholder as Placeholder
import UI.Tag as Tag
import UI.Tooltip as Tooltip


type WorkspaceItem
    = Loading Reference
    | Failure Reference Http.Error
    | Success Reference ItemData -- This Reference is based on API response (not request), to handle multiple-response case


type DocVisibility
    = Unknown
    | Cropped
    | NotCropped
    | MadeFullyVisible


type alias ItemData =
    { item : Item
    , zoom : Zoom
    , docFoldToggles : DocFoldToggles
    , docVisibility : DocVisibility
    }


type alias WithDoc =
    { doc : Maybe Doc }


type alias TermDetailWithDoc =
    TermDetail WithDoc


type alias TypeDetailWithDoc =
    TypeDetail WithDoc


type Item
    = TermItem TermDetailWithDoc
    | TypeItem TypeDetailWithDoc
      -- TODO: DataConstructorItem and AbilityConstructorItem are currently not
      -- rendered separate from TypeItem
    | DataConstructorItem DataConstructorDetail
    | AbilityConstructorItem AbilityConstructorDetail


type alias ItemWithReferences =
    { item : Item
    , refRequest : Reference
    , refResponse : Reference
    }


type NamespaceActionMenu
    = NotVisible
    | Visible Reference


type alias WorkspaceItemViewState =
    { definitionSummaryTooltip : DefinitionSummaryTooltip.Model
    , namespaceActionMenu : NamespaceActionMenu
    }


viewState : WorkspaceItemViewState
viewState =
    { definitionSummaryTooltip = DefinitionSummaryTooltip.init
    , namespaceActionMenu = NotVisible
    }


toggleNamespaceActionMenu : WorkspaceItemViewState -> Reference -> WorkspaceItemViewState
toggleNamespaceActionMenu viewState_ ref =
    let
        namespaceActionMenu =
            case viewState_.namespaceActionMenu of
                Visible _ ->
                    NotVisible

                NotVisible ->
                    Visible ref
    in
    { viewState_ | namespaceActionMenu = namespaceActionMenu }


isNamespaceActionMenuOpen : NamespaceActionMenu -> Reference -> Bool
isNamespaceActionMenuOpen actionMenu ref =
    actionMenu == Visible ref


{-| WorkspaceItem doesn't manage state itself, but has a limited set of actions
-}
type Msg
    = Close Reference
    | OpenReference Reference Reference
    | UpdateZoom Reference Zoom
    | ToggleDocFold Reference Doc.FoldId
    | ChangePerspectiveToSubNamespace FQN
    | FindWithinNamespace FQN
    | ShowFullDoc Reference
    | DefinitionSummaryTooltipMsg DefinitionSummaryTooltip.Msg
    | ToggleNamespaceActionMenu Reference
    | NoOp


fromItem : Reference -> Item -> WorkspaceItem
fromItem refResponse item =
    let
        zoom =
            -- Doc items always have docs
            if isDocItem item then
                Medium

            else if hasDoc item then
                Medium

            else
                Near

        docVisibility =
            if isDocItem item then
                MadeFullyVisible

            else
                Unknown
    in
    Success refResponse
        { item = item
        , zoom = zoom
        , docFoldToggles = Doc.emptyDocFoldToggles
        , docVisibility = docVisibility
        }


reference : WorkspaceItem -> Reference
reference item =
    case item of
        Loading r ->
            r

        Failure r _ ->
            r

        Success refResponse _ ->
            refResponse


allFqns : WorkspaceItem -> List FQN
allFqns workspaceItem =
    case workspaceItem of
        Loading r ->
            MaybeE.values [ Reference.fqn r ]

        Failure r _ ->
            MaybeE.values [ Reference.fqn r ]

        Success _ { item } ->
            case item of
                TermItem (Term _ _ { info }) ->
                    Info.allFqns info

                TypeItem (Type _ _ { info }) ->
                    Info.allFqns info

                AbilityConstructorItem (AbilityConstructor _ { info }) ->
                    Info.allFqns info

                DataConstructorItem (DataConstructor _ { info }) ->
                    Info.allFqns info


{-| Convert the Reference of a WorkspaceItem to be HashOnly
-}
toHashReference : WorkspaceItem -> WorkspaceItem
toHashReference workspaceItem =
    let
        toHashOnly hash_ hq =
            case hq of
                HQ.NameOnly _ ->
                    HQ.HashOnly hash_

                HQ.HashOnly h ->
                    HQ.HashOnly h

                HQ.HashQualified _ h ->
                    HQ.HashOnly h
    in
    case workspaceItem of
        Success refResponse d ->
            Success (Reference.map (toHashOnly (itemHash d.item)) refResponse) d

        -- Can't change references where we don't have hash information
        _ ->
            workspaceItem


{-| Builtins and Types can't be expanded, so we can skip the Medium Zoom level entirely
TODO: Remove isTypeItem from this conditional when we can collapse types (TypeSummary)
-}
cycleZoom : ItemData -> ItemData
cycleZoom data =
    if isBuiltinItem data.item || isTypeItem data.item || not (hasDoc data.item) then
        { data | zoom = Zoom.cycleEdges data.zoom }

    else
        { data | zoom = Zoom.cycle data.zoom }


isSameReference : WorkspaceItem -> Reference -> Bool
isSameReference item ref =
    reference item == ref


isSameByReference : WorkspaceItem -> WorkspaceItem -> Bool
isSameByReference a b =
    reference a == reference b


isBuiltinItem : Item -> Bool
isBuiltinItem item =
    case item of
        TermItem term ->
            Term.isBuiltin term

        TypeItem type_ ->
            Type.isBuiltin type_

        _ ->
            False


isTypeItem : Item -> Bool
isTypeItem item =
    case item of
        TypeItem _ ->
            True

        _ ->
            False


isTermItem : Item -> Bool
isTermItem item =
    case item of
        TermItem _ ->
            True

        _ ->
            False


isDataConstructorItem : Item -> Bool
isDataConstructorItem item =
    case item of
        DataConstructorItem _ ->
            True

        _ ->
            False


isAbilityConstructorItem : Item -> Bool
isAbilityConstructorItem item =
    case item of
        AbilityConstructorItem _ ->
            True

        _ ->
            False


isDocItem : Item -> Bool
isDocItem item =
    case item of
        TermItem (Term _ Term.DocTerm _) ->
            True

        _ ->
            False


hasDoc : Item -> Bool
hasDoc item =
    let
        hasDoc_ details =
            MaybeE.isJust details.doc
    in
    case item of
        TermItem (Term _ _ d) ->
            hasDoc_ d

        TypeItem (Type _ _ d) ->
            hasDoc_ d

        _ ->
            False


{-| Attempt to get the Hash of a WorkspaceItem. First by checking if the
Reference includes the Hash, secondly by checking the item data itself.
-}
hash : WorkspaceItem -> Maybe Hash
hash wItem =
    let
        itemHash_ =
            case wItem of
                Success _ d ->
                    Just (itemHash d.item)

                _ ->
                    Nothing
    in
    wItem
        |> reference
        |> Reference.hash
        |> MaybeE.orElse itemHash_


itemHash : Item -> Hash
itemHash item =
    case item of
        TermItem (Term h _ _) ->
            h

        TypeItem (Type h _ _) ->
            h

        AbilityConstructorItem (AbilityConstructor h _) ->
            h

        DataConstructorItem (DataConstructor h _) ->
            h



-- VIEW


viewBuiltinTag : FQN -> Category -> Html msg
viewBuiltinTag name_ category =
    let
        content =
            FQN.toString name_
                ++ " is a "
                ++ "built-in "
                ++ Category.name category
                ++ " provided by the Unison runtime"
    in
    content
        |> Tag.tag
        |> Tag.withIcon Icon.unisonMark
        |> Tag.view


viewBuiltin : Item -> Maybe (Html msg)
viewBuiltin item =
    case item of
        TermItem (Term _ category detail) ->
            case detail.source of
                Term.Builtin _ ->
                    Just
                        (div [ class "workspace-item_built-in" ]
                            [ viewBuiltinTag detail.info.name (Category.Term category) ]
                        )

                Term.Source _ _ ->
                    Nothing

        TypeItem (Type _ category detail) ->
            case detail.source of
                Type.Builtin ->
                    Just
                        (div [ class "workspace-item_built-in" ]
                            [ viewBuiltinTag detail.info.name (Category.Type category) ]
                        )

                Type.Source _ ->
                    Nothing

        DataConstructorItem (DataConstructor _ detail) ->
            case detail.source of
                Type.Builtin ->
                    Just
                        (div [ class "workspace-item_built-in" ]
                            [ viewBuiltinTag detail.info.name (Category.Type Type.DataType) ]
                        )

                Type.Source _ ->
                    Nothing

        AbilityConstructorItem (AbilityConstructor _ detail) ->
            case detail.source of
                Type.Builtin ->
                    Just
                        (div [ class "workspace-item_built-in" ]
                            [ viewBuiltinTag detail.info.name (Category.Type Type.AbilityType) ]
                        )

                Type.Source _ ->
                    Nothing


viewInfoItem : List (Html msg) -> Html msg
viewInfoItem content =
    div [ class "workspace-item_info-item" ] content


viewInfoItems : NamespaceActionMenu -> Reference -> Hash -> Maybe String -> Info -> Html Msg
viewInfoItems namespaceActionMenu ref hash_ rawSource info =
    let
        namespace =
            case info.namespace of
                Just fqn ->
                    let
                        ns =
                            FQN.toString fqn
                    in
                    ActionMenu.items
                        (ActionMenu.optionItem Icon.browse ("Find within " ++ ns) (Click.onClick (FindWithinNamespace fqn)))
                        [ ActionMenu.optionItem Icon.intoFolder ("Change perspective to " ++ ns) (Click.onClick (ChangePerspectiveToSubNamespace fqn)) ]
                        |> ActionMenu.fromButton (ToggleNamespaceActionMenu ref) ns
                        |> ActionMenu.withButtonIcon Icon.folderOutlined
                        |> ActionMenu.withButtonColor Button.Outlined
                        |> ActionMenu.shouldBeOpen (isNamespaceActionMenuOpen namespaceActionMenu ref)
                        |> ActionMenu.view

                Nothing ->
                    UI.nothing

        numOtherNames =
            List.length info.otherNames

        otherNames =
            if numOtherNames > 0 then
                let
                    otherNamesTooltipContent =
                        Tooltip.rich (div [ class "workspace-item_other-names" ] (List.map (\n -> div [] [ text (FQN.toString n) ]) info.otherNames))

                    otherNamesLabel =
                        pluralize "other name..." "other names..." numOtherNames
                in
                Tooltip.tooltip otherNamesTooltipContent
                    |> Tooltip.withArrow Tooltip.Start
                    |> Tooltip.view (viewInfoItem [ Icon.view Icon.tagsOutlined, text otherNamesLabel ])

            else
                UI.nothing

        hashInfoItem =
            Hash.view hash_

        copySourceToClipboard =
            case rawSource of
                Just s ->
                    div [ class "copy-code" ]
                        [ Tooltip.tooltip (Tooltip.text "Copy full source")
                            |> Tooltip.withArrow Tooltip.Middle
                            |> Tooltip.view
                                (CopyOnClick.view s
                                    (div [ class "button small outlined content-icon" ]
                                        [ Icon.view Icon.clipboard ]
                                    )
                                    (Icon.view Icon.checkmark)
                                )
                        ]

                Nothing ->
                    UI.nothing
    in
    div [ class "workspace-item_info-items" ]
        [ hashInfoItem
        , otherNames
        , namespace
        , copySourceToClipboard
        ]


viewInfo : NamespaceActionMenu -> Reference -> Hash -> Maybe String -> Info -> Category -> Html Msg
viewInfo namespaceActionMenu ref hash_ rawSource info category =
    div [ class "workspace-item_info" ]
        [ div [ class "category-icon" ] [ Icon.view (Category.icon category) ]
        , h3 [ class "name" ] [ FQN.view info.name ]
        , viewInfoItems namespaceActionMenu ref hash_ rawSource info
        ]


viewDoc : SyntaxConfig Msg -> Reference -> DocVisibility -> DocFoldToggles -> Doc -> Html Msg
viewDoc syntaxConfig ref docVisibility docFoldToggles doc =
    let
        ( showFullDoc, shownInFull ) =
            case docVisibility of
                Unknown ->
                    ( UI.nothing, False )

                Cropped ->
                    ( div [ class "show-full-doc" ]
                        [ Button.iconThenLabel (ShowFullDoc ref) Icon.arrowDown "Show full documentation"
                            |> Button.small
                            |> Button.view
                        ]
                    , False
                    )

                _ ->
                    ( UI.nothing, True )

        classes =
            classList
                [ ( "workspace-item_inner-content workspace-item_definition-doc", True )
                , ( "shown-in-full", shownInFull )
                ]
    in
    div [ classes ]
        [ div [ class "definition-doc-columns" ]
            [ div [ class "icon-column" ] [ Icon.view Icon.doc ]
            , div
                [ class "doc-column"
                , id ("definition-doc-" ++ Reference.toString ref)
                ]
                [ Doc.view syntaxConfig
                    (ToggleDocFold ref)
                    docFoldToggles
                    doc
                ]
            ]
        , showFullDoc
        ]


viewSource : Zoom -> Msg -> SourceViewConfig Msg -> Item -> Html Msg
viewSource zoom onSourceToggleClick sourceConfig item =
    let
        viewToggableSource foldToggle renderedSource =
            div [ class "definition-source" ]
                [ FoldToggle.view foldToggle, renderedSource ]

        isBuiltin_ =
            isBuiltinItem item
    in
    case item of
        TermItem (Term _ _ detail) ->
            let
                source =
                    case zoom of
                        Near ->
                            Source.viewTermSource sourceConfig detail.info.name detail.source

                        _ ->
                            Source.viewNamedTermSignature sourceConfig detail.info.name (Term.termSignature detail.source)

                foldToggle =
                    if isBuiltin_ then
                        FoldToggle.disabled |> FoldToggle.close

                    else
                        FoldToggle.foldToggle onSourceToggleClick |> FoldToggle.isOpen (zoom == Near)
            in
            viewToggableSource foldToggle source

        TypeItem (Type _ _ detail) ->
            detail.source
                |> Source.viewTypeSource sourceConfig
                |> viewToggableSource (FoldToggle.disabled |> FoldToggle.isClosed isBuiltin_)

        DataConstructorItem (DataConstructor _ detail) ->
            detail.source
                |> Source.viewTypeSource sourceConfig
                |> viewToggableSource (FoldToggle.disabled |> FoldToggle.isClosed isBuiltin_)

        AbilityConstructorItem (AbilityConstructor _ detail) ->
            detail.source
                |> Source.viewTypeSource sourceConfig
                |> viewToggableSource (FoldToggle.disabled |> FoldToggle.isClosed isBuiltin_)


viewItem : SyntaxConfig Msg -> NamespaceActionMenu -> Reference -> ItemData -> Bool -> Html Msg
viewItem syntaxConfig namespaceActionMenu ref data isFocused =
    let
        ( zoomClass, rowZoomToggle, sourceZoomToggle ) =
            case data.zoom of
                Far ->
                    ( "zoom-level-far", UpdateZoom ref Medium, UpdateZoom ref Near )

                Medium ->
                    ( "zoom-level-medium", UpdateZoom ref Far, UpdateZoom ref Near )

                Near ->
                    ( "zoom-level-near", UpdateZoom ref Far, UpdateZoom ref Medium )

        attrs =
            [ class zoomClass, classList [ ( "workspace-item_is-focused", isFocused ) ] ]

        sourceConfig =
            SourceViewConfig.rich syntaxConfig

        viewDoc_ doc =
            doc
                |> Maybe.map (viewDoc syntaxConfig ref data.docVisibility data.docFoldToggles)
                |> Maybe.map
                    (\d ->
                        [ Divider.divider |> Divider.small |> Divider.withoutMargin |> Divider.view
                        , d
                        ]
                    )
                |> Maybe.withDefault []

        viewContent doc =
            viewSource data.zoom sourceZoomToggle sourceConfig data.item
                :: MaybeE.unwrap [] (\i -> [ i ]) (viewBuiltin data.item)
                ++ viewDoc_ doc

        viewInfo_ hash_ rawSource info cat =
            viewInfo namespaceActionMenu ref hash_ rawSource info cat

        foldRow =
            Just { zoom = data.zoom, toggle = rowZoomToggle }
    in
    case data.item of
        TermItem ((Term h category detail) as term) ->
            viewClosableRow
                ref
                attrs
                (viewInfo_ h (Term.rawSource term) detail.info (Category.Term category))
                (viewContent detail.doc)
                foldRow

        TypeItem ((Type h category detail) as type_) ->
            viewClosableRow
                ref
                attrs
                (viewInfo_ h (Type.rawSource type_) detail.info (Category.Type category))
                (viewContent detail.doc)
                foldRow

        DataConstructorItem ((DataConstructor h detail) as ctor) ->
            viewClosableRow
                ref
                attrs
                (viewInfo_ h (DataConstructor.rawSource ctor) detail.info (Category.Type Type.DataType))
                (viewContent Nothing)
                foldRow

        AbilityConstructorItem ((AbilityConstructor h detail) as ctor) ->
            viewClosableRow
                ref
                attrs
                (viewInfo_ h (AbilityConstructor.rawSource ctor) detail.info (Category.Type Type.AbilityType))
                (viewContent Nothing)
                foldRow


view : WorkspaceItemViewState -> WorkspaceItem -> Bool -> Html Msg
view { definitionSummaryTooltip, namespaceActionMenu } workspaceItem isFocused =
    let
        attrs =
            [ classList [ ( "focused", isFocused ) ]
            ]
    in
    case workspaceItem of
        Loading ref ->
            viewRow ref
                attrs
                []
                (Placeholder.text
                    |> Placeholder.withSize Placeholder.Large
                    |> Placeholder.withLength Placeholder.Medium
                    |> Placeholder.view
                )
                [ Placeholder.text
                    |> Placeholder.withSize Placeholder.Large
                    |> Placeholder.withLength Placeholder.Large
                    |> Placeholder.withIntensity Placeholder.Subdued
                    |> Placeholder.view
                ]

        Failure ref err ->
            viewClosableRow
                ref
                attrs
                (div [ class "workspace-item_error-header" ]
                    [ Icon.view Icon.warn
                    , Icon.view (Reference.toIcon ref)
                    , h3 [ title (Util.httpErrorToString err) ] [ text (HQ.toString (Reference.hashQualified ref)) ]
                    ]
                )
                [ div
                    [ class "error" ]
                    [ text "Unable to load definition: "
                    , span [ class "definition-with-error" ] [ text (Reference.toHumanString ref) ]
                    , text " —  please try again."
                    ]
                ]
                Nothing

        Success ref data ->
            let
                syntaxConfig =
                    SyntaxConfig.default
                        (OpenReference ref >> Click.onClick)
                        (DefinitionSummaryTooltip.tooltipConfig
                            DefinitionSummaryTooltipMsg
                            definitionSummaryTooltip
                        )
            in
            viewItem syntaxConfig namespaceActionMenu ref data isFocused



-- VIEW HELPERS


viewRow :
    Reference
    -> List (Attribute msg)
    -> List (Html msg)
    -> Html msg
    -> List (Html msg)
    -> Html msg
viewRow ref attrs actionsContent headerContent content =
    let
        actions =
            if not (List.isEmpty actionsContent) then
                div [ class "actions" ] actionsContent

            else
                UI.nothing

        headerItems =
            [ headerContent, actions ]
    in
    div
        (class "workspace-item" :: id ("definition-" ++ Reference.toString ref) :: attrs)
        [ header [ class "workspace-item_header" ] headerItems
        , section [ class "workspace-item_content" ] content
        ]


viewClosableRow :
    Reference
    -> List (Attribute Msg)
    -> Html Msg
    -> List (Html Msg)
    -> Maybe { zoom : Zoom, toggle : Msg }
    -> Html Msg
viewClosableRow ref attrs header content foldRow =
    let
        foldIcon zoom =
            if zoom /= Far then
                Icon.arrowsToLine

            else
                Icon.arrowsFromLine

        foldButton fr =
            Button.icon fr.toggle (foldIcon fr.zoom)
                |> Button.subdued
                |> Button.small
                |> Button.view

        toggleFold =
            foldRow
                |> Maybe.map foldButton
                |> Maybe.withDefault UI.nothing

        close =
            Button.icon (Close ref) Icon.x
                |> Button.subdued
                |> Button.small
                |> Button.view
    in
    viewRow ref attrs [ toggleFold, close ] header content



-- JSON DECODERS


decodeDocs : String -> Decode.Decoder (Maybe Doc)
decodeDocs fieldName =
    Decode.oneOf
        [ Decode.map Just (field fieldName (index 0 (index 2 Doc.decode)))
        , Decode.succeed Nothing
        ]


type alias RawTypeDetails =
    { category : TypeCategory
    , name : FQN
    , otherNames : NEL.Nonempty FQN
    , source : TypeSource
    , doc : Maybe Doc
    }


decodeTypeDetails : Decode.Decoder RawTypeDetails
decodeTypeDetails =
    Decode.map5 RawTypeDetails
        (Type.decodeTypeCategory [ "defnTypeTag" ])
        (field "bestTypeName" FQN.decode)
        (field "typeNames" (nonEmptyList FQN.decode))
        (Type.decodeTypeSource [ "typeDefinition", "tag" ] [ "typeDefinition", "contents" ])
        (decodeDocs "typeDocs")


makeTypeDetailWithDoc : Reference -> RawTypeDetails -> Hash -> TypeDetailWithDoc
makeTypeDetailWithDoc ref d hash_ =
    let
        info =
            Info.makeInfo ref d.name d.otherNames

        typeDetailFieldsWithDoc =
            { doc = d.doc
            , info = info
            , source = d.source
            }
    in
    Type hash_
        d.category
        typeDetailFieldsWithDoc


decodeTypes : Decode.Decoder (List ( Reference, TypeDetailWithDoc ))
decodeTypes =
    let
        makeType : ( String, RawTypeDetails ) -> Maybe ( Reference, TypeDetailWithDoc )
        makeType ( hash_, d ) =
            let
                -- make ref based on response
                ref =
                    d.otherNames
                        |> NEL.head
                        |> Reference.fromFQN Reference.TypeReference
            in
            hash_
                |> Hash.fromString
                |> Maybe.map (makeTypeDetailWithDoc ref d)
                |> Maybe.map (Tuple.pair ref)

        buildTypes : List ( String, RawTypeDetails ) -> List ( Reference, TypeDetailWithDoc )
        buildTypes =
            List.map makeType >> MaybeE.values
    in
    Decode.keyValuePairs decodeTypeDetails
        |> Decode.map buildTypes


type alias RawTermDetails =
    { category : TermCategory
    , name : FQN
    , otherNames : NEL.Nonempty FQN
    , source : TermSource
    , doc : Maybe Doc
    }


decodeRawTermDetails : Decode.Decoder RawTermDetails
decodeRawTermDetails =
    Decode.map5 RawTermDetails
        (Term.decodeTermCategory [ "defnTermTag" ])
        (field "bestTermName" FQN.decode)
        (field "termNames" (nonEmptyList FQN.decode))
        (Term.decodeTermSource
            [ "termDefinition", "tag" ]
            [ "signature" ]
            [ "termDefinition", "contents" ]
        )
        (decodeDocs "termDocs")


makeTermDetailWithDoc : Reference -> RawTermDetails -> Hash -> TermDetailWithDoc
makeTermDetailWithDoc ref d hash_ =
    let
        info =
            Info.makeInfo ref d.name d.otherNames

        termDetailFieldsWithDoc =
            { doc = d.doc
            , info = info
            , source = d.source
            }
    in
    Term hash_
        d.category
        termDetailFieldsWithDoc


decodeTerms : Decode.Decoder (List ( Reference, TermDetailWithDoc ))
decodeTerms =
    let
        makeTerm : ( String, RawTermDetails ) -> Maybe ( Reference, TermDetailWithDoc )
        makeTerm ( hash_, d ) =
            let
                -- make ref based on response
                ref =
                    d.otherNames
                        |> NEL.head
                        |> Reference.fromFQN Reference.TermReference
            in
            hash_
                |> Hash.fromString
                |> Maybe.map (makeTermDetailWithDoc ref d)
                |> Maybe.map (Tuple.pair ref)

        buildTerms : List ( String, RawTermDetails ) -> List ( Reference, TermDetailWithDoc )
        buildTerms =
            List.map makeTerm >> MaybeE.values
    in
    Decode.keyValuePairs decodeRawTermDetails
        |> Decode.map buildTerms



-- `getDefinition` API could return more than 1 result, e.g. when the same name elements exist as `term` and `type` (though this is rare). To handle this, this `decodeList` decodes the response into a list of `ItemWithReferences`, which have decoded items and decoded references based on the API response.


decodeList : Reference -> Decode.Decoder (List ItemWithReferences)
decodeList refRequest =
    let
        termDefinitions =
            field "termDefinitions" decodeTerms
                |> Decode.map
                    (List.map
                        (\( decodedRef, term ) ->
                            { item = TermItem term
                            , refRequest = refRequest
                            , refResponse = decodedRef
                            }
                        )
                    )

        typeDefinitions =
            field "typeDefinitions" decodeTypes
                |> Decode.map
                    (List.map
                        (\( decodedRef, typeDef ) ->
                            { item = TypeItem typeDef
                            , refRequest = refRequest
                            , refResponse = decodedRef
                            }
                        )
                    )
    in
    Decode.map2
        List.append
        termDefinitions
        typeDefinitions
