module Code.Workspace.WorkspaceItem exposing (..)

import Code.Definition.AbilityConstructor exposing (AbilityConstructor(..), AbilityConstructorDetail)
import Code.Definition.Category as Category exposing (Category)
import Code.Definition.DataConstructor exposing (DataConstructor(..), DataConstructorDetail)
import Code.Definition.Doc as Doc exposing (Doc, DocFoldToggles)
import Code.Definition.Info as Info exposing (Info)
import Code.Definition.Reference as Reference exposing (Reference)
import Code.Definition.Source as Source
import Code.Definition.Term as Term exposing (Term(..), TermCategory(..), TermDetail, TermSource)
import Code.Definition.Type as Type exposing (Type(..), TypeCategory, TypeDetail, TypeSource)
import Code.DefinitionSummaryTooltip as DefinitionSummaryTooltip
import Code.FullyQualifiedName as FQN exposing (FQN)
import Code.Hash as Hash exposing (Hash)
import Code.HashQualified as HQ
import Code.Syntax as Syntax
import Code.Workspace.Zoom as Zoom exposing (Zoom(..))
import Html exposing (Attribute, Html, div, h3, header, section, span, text)
import Html.Attributes exposing (class, classList, id, title)
import Http
import Json.Decode as Decode exposing (field, index)
import Lib.Util as Util
import List.Nonempty as NEL
import Maybe.Extra as MaybeE
import String.Extra exposing (pluralize)
import UI
import UI.ActionMenu as ActionMenu
import UI.Button as Button
import UI.Click as Click
import UI.Divider as Divider
import UI.FoldToggle as FoldToggle
import UI.Icon as Icon
import UI.Placeholder as Placeholder
import UI.Tag as Tag
import UI.Tooltip as Tooltip
import UI.ViewMode as ViewMode exposing (ViewMode)


type WorkspaceItem
    = Loading Reference
    | Failure Reference Http.Error
    | Success Reference Reference ItemData -- refRequest / refResponse


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


fromItem : Reference -> Reference -> Item -> WorkspaceItem
fromItem refRequest refResponse item =
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
    Success refRequest
        refResponse
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

        Success _ refResponse _ ->
            refResponse


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
        Success refRequest refResponse d ->
            Success (Reference.map (toHashOnly (itemHash d.item)) refRequest) (Reference.map (toHashOnly (itemHash d.item)) refResponse) d

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
                Success _ _ d ->
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


viewInfoItems : NamespaceActionMenu -> Reference -> Hash -> Info -> Html Msg
viewInfoItems namespaceActionMenu ref hash_ info =
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
                        |> ActionMenu.withButtonColor Button.Subdued
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
    in
    div [ class "workspace-item_info-items" ] [ hashInfoItem, otherNames, namespace ]


viewInfo : NamespaceActionMenu -> Reference -> Hash -> Info -> Category -> Html Msg
viewInfo namespaceActionMenu ref hash_ info category =
    div [ class "workspace-item_info" ]
        [ div [ class "category-icon" ] [ Icon.view (Category.icon category) ]
        , h3 [ class "name" ] [ FQN.view info.name ]
        , viewInfoItems namespaceActionMenu ref hash_ info
        ]


viewDoc : Syntax.LinkedWithTooltipConfig Msg -> Reference -> DocVisibility -> DocFoldToggles -> Doc -> Html Msg
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


viewSource : Zoom -> Msg -> Source.ViewConfig Msg -> Item -> Html Msg
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


viewItem : Syntax.LinkedWithTooltipConfig Msg -> NamespaceActionMenu -> Reference -> ItemData -> Bool -> Html Msg
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
            Source.Rich syntaxConfig

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

        viewInfo_ hash_ info cat =
            viewInfo namespaceActionMenu ref hash_ info cat

        foldRow =
            Just { zoom = data.zoom, toggle = rowZoomToggle }
    in
    case data.item of
        TermItem (Term h category detail) ->
            viewClosableRow
                ref
                attrs
                (viewInfo_ h detail.info (Category.Term category))
                (viewContent detail.doc)
                foldRow

        TypeItem (Type h category detail) ->
            viewClosableRow
                ref
                attrs
                (viewInfo_ h detail.info (Category.Type category))
                (viewContent detail.doc)
                foldRow

        DataConstructorItem (DataConstructor h detail) ->
            viewClosableRow
                ref
                attrs
                (viewInfo_ h detail.info (Category.Type Type.DataType))
                (viewContent Nothing)
                foldRow

        AbilityConstructorItem (AbilityConstructor h detail) ->
            viewClosableRow
                ref
                attrs
                (viewInfo_ h detail.info (Category.Type Type.AbilityType))
                (viewContent Nothing)
                foldRow


viewPresentationItem : Syntax.LinkedWithTooltipConfig Msg -> Reference -> ItemData -> Html Msg
viewPresentationItem syntaxConfig ref data =
    case data.item of
        TermItem (Term _ category detail) ->
            case category of
                DocTerm ->
                    detail.doc
                        |> Maybe.map (Doc.view syntaxConfig (ToggleDocFold ref) data.docFoldToggles)
                        |> Maybe.withDefault UI.nothing

                _ ->
                    UI.nothing

        TypeItem _ ->
            UI.nothing

        DataConstructorItem _ ->
            UI.nothing

        AbilityConstructorItem _ ->
            UI.nothing


view : WorkspaceItemViewState -> ViewMode -> WorkspaceItem -> Bool -> Html Msg
view { definitionSummaryTooltip, namespaceActionMenu } viewMode workspaceItem isFocused =
    let
        attrs =
            [ classList [ ( "focused", isFocused && ViewMode.isRegular viewMode ) ]
            , class (ViewMode.toCssClass viewMode)
            ]
    in
    case workspaceItem of
        Loading ref ->
            case viewMode of
                ViewMode.Regular ->
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

                ViewMode.Presentation ->
                    div [ class "workspace-item_loading" ]
                        [ Placeholder.text
                            |> Placeholder.withSize Placeholder.Large
                            |> Placeholder.withLength Placeholder.Medium
                            |> Placeholder.view
                        , Placeholder.text
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

        Success _ ref data ->
            let
                linkedWithTooltipConfig =
                    Syntax.linkedWithTooltipConfig
                        (OpenReference ref >> Click.onClick)
                        (DefinitionSummaryTooltip.tooltipConfig
                            DefinitionSummaryTooltipMsg
                            definitionSummaryTooltip
                        )
            in
            case viewMode of
                ViewMode.Regular ->
                    viewItem linkedWithTooltipConfig namespaceActionMenu ref data isFocused

                ViewMode.Presentation ->
                    viewPresentationItem linkedWithTooltipConfig ref data



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


decodeTypeDetails :
    Decode.Decoder
        { category : TypeCategory
        , name : FQN
        , otherNames : NEL.Nonempty FQN
        , source : TypeSource
        , doc : Maybe Doc
        }
decodeTypeDetails =
    let
        make cat name otherNames source doc =
            { category = cat
            , doc = doc
            , name = name
            , otherNames = otherNames
            , source = source
            }
    in
    Decode.map5 make
        (Type.decodeTypeCategory [ "defnTypeTag" ])
        (field "bestTypeName" FQN.decode)
        (field "typeNames" (Util.decodeNonEmptyList FQN.decode))
        (Type.decodeTypeSource [ "typeDefinition", "tag" ] [ "typeDefinition", "contents" ])
        (decodeDocs "typeDocs")


decodeTypes : Reference -> Decode.Decoder (List TypeDetailWithDoc)
decodeTypes ref =
    let
        makeType ( hash_, d ) =
            hash_
                |> Hash.fromString
                |> Maybe.map
                    (\h ->
                        Type h
                            d.category
                            { doc = d.doc
                            , info = Info.makeInfo ref d.name d.otherNames
                            , source = d.source
                            }
                    )

        buildTypes =
            List.map makeType >> MaybeE.values
    in
    Decode.keyValuePairs decodeTypeDetails |> Decode.map buildTypes


decodeTypesWithRef : Decode.Decoder (List ( Reference, TypeDetailWithDoc ))
decodeTypesWithRef =
    let
        makeType ( hash_, d ) =
            let
                ref =
                    d.otherNames
                        |> NEL.head
                        |> Reference.fromFQN Reference.TypeReference

                typeDetailWithDoc =
                    hash_
                        |> Hash.fromString
                        |> Maybe.map
                            (\h ->
                                Type h
                                    d.category
                                    { doc = d.doc
                                    , info = Info.makeInfo ref d.name d.otherNames
                                    , source = d.source
                                    }
                            )
            in
            Maybe.map (\t -> ( ref, t )) typeDetailWithDoc

        buildTypes =
            List.map makeType >> MaybeE.values
    in
    Decode.keyValuePairs decodeTypeDetails |> Decode.map buildTypes


decodeTermDetails :
    Decode.Decoder
        { category : TermCategory
        , name : FQN
        , otherNames : NEL.Nonempty FQN
        , source : TermSource
        , doc : Maybe Doc
        }
decodeTermDetails =
    let
        make cat name otherNames source doc =
            { category = cat
            , name = name
            , otherNames = otherNames
            , source = source
            , doc = doc
            }
    in
    Decode.map5 make
        (Term.decodeTermCategory [ "defnTermTag" ])
        (field "bestTermName" FQN.decode)
        (field "termNames" (Util.decodeNonEmptyList FQN.decode))
        (Term.decodeTermSource
            [ "termDefinition", "tag" ]
            [ "signature" ]
            [ "termDefinition", "contents" ]
        )
        (decodeDocs "termDocs")


decodeTerms : Reference -> Decode.Decoder (List TermDetailWithDoc)
decodeTerms ref =
    let
        makeTerm ( hash_, d ) =
            hash_
                |> Hash.fromString
                |> Maybe.map
                    (\h ->
                        Term h
                            d.category
                            { doc = d.doc
                            , info = Info.makeInfo ref d.name d.otherNames
                            , source = d.source
                            }
                    )

        buildTerms =
            List.map makeTerm >> MaybeE.values
    in
    Decode.keyValuePairs decodeTermDetails |> Decode.map buildTerms


decodeTermsWithRef : Decode.Decoder (List ( Reference, TermDetailWithDoc ))
decodeTermsWithRef =
    let
        makeTerm ( hash_, d ) =
            let
                ref =
                    d.otherNames
                        |> NEL.head
                        |> Reference.fromFQN Reference.TermReference

                termDetailWithDoc =
                    hash_
                        |> Hash.fromString
                        |> Maybe.map
                            (\h ->
                                Term h
                                    d.category
                                    { doc = d.doc
                                    , info = Info.makeInfo ref d.name d.otherNames
                                    , source = d.source
                                    }
                            )
            in
            Maybe.map (\t -> ( ref, t )) termDetailWithDoc

        buildTerms =
            List.map makeTerm >> MaybeE.values
    in
    Decode.keyValuePairs decodeTermDetails |> Decode.map buildTerms


decodeList : Reference -> Decode.Decoder (List ItemWithReferences)
decodeList refRequest =
    let
        termDefinitions =
            field
                "termDefinitions"
                (decodeTermsWithRef
                    |> Decode.map
                        (List.map
                            (\( decodedRef, term ) ->
                                { item = TermItem term
                                , refRequest = refRequest
                                , refResponse = decodedRef
                                }
                            )
                        )
                )

        typeDefinitions =
            field
                "typeDefinitions"
                (decodeTypesWithRef
                    |> Decode.map
                        (List.map
                            (\( decodedRef, typeDef ) ->
                                { item = TypeItem typeDef
                                , refRequest = refRequest
                                , refResponse = decodedRef
                                }
                            )
                        )
                )
    in
    Decode.map2
        List.append
        termDefinitions
        typeDefinitions


decodeItem : Reference -> Decode.Decoder ItemWithReferences
decodeItem refRequest =
    Decode.map List.head (decodeList refRequest)
        |> Decode.andThen
            (Maybe.map Decode.succeed
                >> Maybe.withDefault (Decode.fail "Empty list")
            )
