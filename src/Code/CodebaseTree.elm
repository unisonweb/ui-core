module Code.CodebaseTree exposing (Model, Msg, OutMsg(..), init, update, view)

import Code.CodebaseApi as CodebaseApi
import Code.CodebaseTree.NamespaceListing as NamespaceListing
    exposing
        ( DefinitionListing(..)
        , NamespaceListing(..)
        , NamespaceListingChild(..)
        , NamespaceListingContent
        )
import Code.Config exposing (Config)
import Code.Definition.Category as Category
import Code.Definition.Reference exposing (Reference(..))
import Code.FullyQualifiedName as FQN exposing (FQN, unqualifiedName)
import Code.FullyQualifiedNameSet as FQNSet exposing (FQNSet)
import Code.HashQualified exposing (HashQualified(..))
import Code.Namespace.NamespaceRef as NamespaceRef
import Code.Perspective as Perspective
import Html exposing (Html, a, div, label, span, text)
import Html.Attributes exposing (class, classList, title)
import Html.Events exposing (onClick)
import Http
import Lib.HttpApi as HttpApi exposing (ApiRequest)
import Lib.ProdDebug as ProdDebug
import Lib.Util as Util
import RemoteData exposing (RemoteData(..), WebData)
import UI
import UI.Button as Button
import UI.Icon as Icon exposing (Icon)
import UI.Tooltip as Tooltip



-- MODEL


type alias Model =
    { rootNamespaceListing : WebData NamespaceListing
    , expandedNamespaceListings : FQNSet
    }


init : Config -> ( Model, Cmd Msg )
init config =
    let
        model =
            { rootNamespaceListing = Loading, expandedNamespaceListings = FQNSet.empty }
    in
    ( model, HttpApi.perform config.api (fetchRootNamespaceListing config) )



-- UPDATE


type Msg
    = ToggleExpandedNamespaceListing FQN
    | FetchSubNamespaceListingFinished FQN (Result Http.Error NamespaceListing)
    | FetchRootNamespaceListingFinished (Result Http.Error NamespaceListing)
    | Out OutMsg


type OutMsg
    = None
    | OpenDefinition Reference
    | ChangePerspectiveToNamespace FQN


update : Config -> Msg -> Model -> ( Model, Cmd Msg, OutMsg )
update config msg model =
    case msg of
        ToggleExpandedNamespaceListing fqn ->
            let
                shouldExpand =
                    not (FQNSet.member fqn model.expandedNamespaceListings)

                setLoading ((NamespaceListing h f _) as namespaceListing) =
                    if FQN.equals f fqn then
                        NamespaceListing h f Loading

                    else
                        namespaceListing

                nextNamespaceListing =
                    if shouldExpand && not namespaceContentFetched then
                        RemoteData.map (NamespaceListing.map setLoading) model.rootNamespaceListing

                    else
                        model.rootNamespaceListing

                namespaceContentFetched =
                    model.rootNamespaceListing
                        |> RemoteData.map (\nl -> NamespaceListing.contentFetched nl fqn)
                        |> RemoteData.withDefault False

                newModel =
                    { model
                        | expandedNamespaceListings = FQNSet.toggle fqn model.expandedNamespaceListings
                        , rootNamespaceListing = nextNamespaceListing
                    }

                cmd =
                    if shouldExpand && not namespaceContentFetched then
                        HttpApi.perform config.api (fetchSubNamespaceListing config fqn)

                    else
                        Cmd.none
            in
            ( newModel, cmd, None )

        FetchSubNamespaceListingFinished fetchedFqn result ->
            let
                replaceNamespaceListing ((NamespaceListing hash fqn _) as namespaceListing) =
                    if FQN.equals fetchedFqn fqn then
                        case result of
                            Ok (NamespaceListing _ _ content) ->
                                NamespaceListing hash fqn content

                            Err err ->
                                NamespaceListing hash fqn (Failure err)

                    else
                        namespaceListing

                nextNamespaceListing =
                    RemoteData.map (NamespaceListing.map replaceNamespaceListing) model.rootNamespaceListing
            in
            ( { model | rootNamespaceListing = nextNamespaceListing }, Cmd.none, None )

        FetchRootNamespaceListingFinished result ->
            case result of
                Ok (NamespaceListing hash fqn content) ->
                    ( { model | rootNamespaceListing = Success (NamespaceListing hash fqn content) }
                    , Cmd.none
                    , None
                    )

                Err err ->
                    ( { model | rootNamespaceListing = Failure err }, Cmd.none, None )

        Out outMsg ->
            case outMsg of
                {- CodebaseTree deals in names relative to the
                   Perspective and perspectives need to be relative to the
                   codebase, so when changing the perspective when a
                   namespace perspective already exists, merge the
                   namespace perspective fqn with the relative name of the
                   namespace being selected.
                -}
                ChangePerspectiveToNamespace name ->
                    let
                        newPerspectiveFqn =
                            case config.perspective of
                                Perspective.Namespace { fqn } ->
                                    FQN.append fqn name

                                Perspective.Root _ ->
                                    name
                    in
                    ( model, Cmd.none, ChangePerspectiveToNamespace newPerspectiveFqn )

                _ ->
                    ( model, Cmd.none, outMsg )



-- EFFECTS


fetchRootNamespaceListing : Config -> ApiRequest NamespaceListing Msg
fetchRootNamespaceListing config =
    fetchNamespaceListing config Nothing FetchRootNamespaceListingFinished


fetchSubNamespaceListing : Config -> FQN -> ApiRequest NamespaceListing Msg
fetchSubNamespaceListing config fqn =
    fetchNamespaceListing config (Just fqn) (FetchSubNamespaceListingFinished fqn)


fetchNamespaceListing : Config -> Maybe FQN -> (Result Http.Error NamespaceListing -> msg) -> ApiRequest NamespaceListing msg
fetchNamespaceListing config fqn toMsg =
    CodebaseApi.Browse { perspective = config.perspective, ref = Maybe.map NamespaceRef.NameRef fqn }
        |> config.toApiEndpoint
        |> HttpApi.toRequest (NamespaceListing.decode fqn) toMsg



-- VIEW


viewListingRow : Maybe msg -> Bool -> String -> String -> Icon msg -> Html msg
viewListingRow clickMsg isOpen label_ category icon =
    let
        containerClass =
            class ("node " ++ category)

        container =
            clickMsg
                |> Maybe.map
                    (\msg ->
                        a
                            [ containerClass
                            , onClick msg
                            , classList [ ( "is-open", isOpen ) ]
                            ]
                    )
                |> Maybe.withDefault (span [ containerClass ])
    in
    container [ Icon.view icon, viewListingLabel label_ ]


viewListingLabel : String -> Html msg
viewListingLabel label_ =
    label [ title label_ ] [ text label_ ]


viewDefinitionListing : FQNSet -> Maybe FQN -> DefinitionListing -> Html Msg
viewDefinitionListing openDefinitions parentNamespace listing =
    let
        fullFqn fqn =
            case parentNamespace of
                Just n ->
                    FQN.append n fqn

                Nothing ->
                    fqn

        isOpen fqn =
            FQNSet.member (fullFqn fqn) openDefinitions

        viewDefRow ref fqn =
            viewListingRow
                (Just (Out (OpenDefinition ref)))
                (isOpen fqn)
                (unqualifiedName fqn)
    in
    case listing of
        TypeListing _ fqn category ->
            viewDefRow (TypeReference (NameOnly fqn)) fqn (Category.name category) (Category.icon category)

        TermListing _ fqn category ->
            ProdDebug.view
                (FQN.toString (fullFqn fqn))
                [ viewDefRow (TermReference (NameOnly fqn)) fqn (Category.name category) (Category.icon category) ]

        DataConstructorListing _ fqn ->
            viewDefRow (DataConstructorReference (NameOnly fqn)) fqn "constructor" Icon.dataConstructor

        AbilityConstructorListing _ fqn ->
            viewDefRow (AbilityConstructorReference (NameOnly fqn)) fqn "constructor" Icon.abilityConstructor

        PatchListing p ->
            viewListingRow Nothing False p "patch" Icon.patch


viewLoadedNamespaceListingContent : ViewConfig -> FQNSet -> Maybe FQN -> FQNSet -> NamespaceListingContent -> Html Msg
viewLoadedNamespaceListingContent viewConfig openDefinitions namespace expandedNamespaceListings content =
    let
        viewChild c =
            case c of
                SubNamespace nl ->
                    viewNamespaceListing
                        viewConfig
                        openDefinitions
                        expandedNamespaceListings
                        nl

                SubDefinition dl ->
                    viewDefinitionListing openDefinitions namespace dl
    in
    div [] (List.map viewChild content)


viewNamespaceListingContent : ViewConfig -> FQNSet -> Maybe FQN -> FQNSet -> WebData NamespaceListingContent -> Html Msg
viewNamespaceListingContent viewConfig openDefinitions namespace expandedNamespaceListings content =
    case content of
        Success loadedContent ->
            viewLoadedNamespaceListingContent viewConfig
                openDefinitions
                namespace
                expandedNamespaceListings
                loadedContent

        Failure err ->
            viewError err

        NotAsked ->
            UI.nothing

        Loading ->
            viewLoading


viewNamespaceListing : ViewConfig -> FQNSet -> FQNSet -> NamespaceListing -> Html Msg
viewNamespaceListing viewConfig openDefinitions expandedNamespaceListings (NamespaceListing _ name content) =
    let
        ( isExpanded, namespaceContent ) =
            if FQNSet.member name expandedNamespaceListings then
                ( True
                , div [ class "namespace-content" ]
                    [ viewNamespaceListingContent
                        viewConfig
                        openDefinitions
                        (Just name)
                        expandedNamespaceListings
                        content
                    ]
                )

            else
                ( False, UI.nothing )

        changePerspectiveTo =
            if viewConfig.withPerspective then
                Button.icon (Out (ChangePerspectiveToNamespace name)) Icon.intoFolder
                    |> Button.stopPropagation
                    |> Button.subdued
                    |> Button.small
                    |> Button.view

            else
                UI.nothing

        fullName =
            FQN.toString name

        namespaceIcon =
            div [ class "namespace-icon", classList [ ( "expanded", isExpanded ) ] ]
                [ if isExpanded then
                    Icon.view Icon.folderOpen

                  else
                    Icon.view Icon.folder
                ]

        hasOpenDefinitions =
            FQNSet.isPrefixOfAny openDefinitions name
    in
    div [ class "subtree" ]
        [ a
            [ class "node namespace"
            , classList [ ( "has-open-definitions", hasOpenDefinitions ) ]
            , onClick (ToggleExpandedNamespaceListing name)
            ]
            [ namespaceIcon
            , viewListingLabel (unqualifiedName name)
            , Tooltip.tooltip (Tooltip.text ("Change perspective to " ++ fullName))
                |> Tooltip.withArrow Tooltip.End
                |> Tooltip.view changePerspectiveTo
            ]
        , namespaceContent
        ]


viewError : Http.Error -> Html msg
viewError err =
    div [ class "error", title (Util.httpErrorToString err) ]
        [ Icon.view Icon.warn
        , text "Unable to load namespace"
        ]


viewLoading : Html msg
viewLoading =
    div [ class "loading" ]
        [ UI.loadingPlaceholderRow
        , UI.loadingPlaceholderRow
        , UI.loadingPlaceholderRow
        ]


type alias ViewConfig =
    { withPerspective : Bool
    }


view : ViewConfig -> FQNSet -> Model -> Html Msg
view viewConfig openDefinitions model =
    let
        listings =
            case model.rootNamespaceListing of
                Success (NamespaceListing _ _ content) ->
                    viewNamespaceListingContent
                        viewConfig
                        openDefinitions
                        Nothing
                        model.expandedNamespaceListings
                        content

                Failure err ->
                    viewError err

                NotAsked ->
                    viewLoading

                Loading ->
                    viewLoading
    in
    div [ class "codebase-tree" ]
        [ div [ class "namespace-tree" ] [ listings ]
        ]
