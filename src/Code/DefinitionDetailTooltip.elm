module Code.DefinitionDetailTooltip exposing (Model, Msg, init, tooltipConfig, update)

import Code.CodebaseApi as CodebaseApi
import Code.Config exposing (Config)
import Code.Definition.AbilityConstructor as AbilityConstructor exposing (AbilityConstructor(..), AbilityConstructorDetail)
import Code.Definition.DataConstructor as DataConstructor exposing (DataConstructor(..), DataConstructorDetail)
import Code.Definition.Reference as Reference exposing (Reference(..))
import Code.Definition.Source as Source
import Code.Definition.Term as Term exposing (Term(..), TermDetail)
import Code.Definition.Type as Type exposing (Type(..), TypeDetail)
import Code.FullyQualifiedName as FQN
import Code.Hash as Hash
import Code.Source.SourceViewConfig as SourceViewConfig
import Code.Syntax.Linked exposing (Linked(..), TooltipConfig)
import Dict exposing (Dict)
import Html exposing (div)
import Html.Attributes exposing (class)
import Json.Decode as Decode exposing (field)
import Lib.HttpApi as HttpApi exposing (ApiRequest, HttpResult)
import Lib.Util as Util
import RemoteData exposing (RemoteData(..), WebData)
import UI.Placeholder as Placeholder
import UI.Tooltip as Tooltip exposing (Tooltip)



-- MODEL


type DefinitionDetail
    = TermHover (TermDetail {})
    | TypeHover (TypeDetail {})
    | DataConstructorHover DataConstructorDetail
    | AbilityConstructorHover AbilityConstructorDetail


type alias Model =
    { activeTooltip : Maybe ( Reference, WebData DefinitionDetail )
    , definitions : Dict String ( Reference, WebData DefinitionDetail )
    }


init : Model
init =
    { activeTooltip = Nothing
    , definitions = Dict.empty
    }



-- UPDATE


type Msg
    = ShowTooltip Reference
    | FetchDefinition Reference
    | HideTooltip Reference
    | FetchDefinitionFinished Reference (HttpResult DefinitionDetail)


update : Config -> Msg -> Model -> ( Model, Cmd Msg )
update config msg model =
    let
        debounceDelay =
            300
    in
    case msg of
        ShowTooltip ref ->
            let
                cached =
                    Dict.get (Reference.toString ref) model.definitions
            in
            case cached of
                Nothing ->
                    ( model, Util.delayMsg debounceDelay (FetchDefinition ref) )

                Just _ ->
                    ( { model | activeTooltip = cached }, Cmd.none )

        FetchDefinition ref ->
            let
                fetchDef =
                    ( { model | activeTooltip = Just ( ref, Loading ) }
                    , fetchDefinition config ref |> HttpApi.perform config.api
                    )
            in
            case model.activeTooltip of
                Just ( r, Loading ) ->
                    if Reference.equals ref r then
                        ( model, Cmd.none )

                    else
                        -- If we've moved on to hovering over a different
                        -- definition while another was loading, discard the
                        -- original request
                        fetchDef

                Just _ ->
                    ( model, Cmd.none )

                Nothing ->
                    fetchDef

        HideTooltip _ ->
            ( { model | activeTooltip = Nothing }, Cmd.none )

        FetchDefinitionFinished ref d ->
            case model.activeTooltip of
                Just ( r, _ ) ->
                    if Reference.equals ref r then
                        let
                            newActiveTooltip =
                                ( r, RemoteData.fromResult d )

                            updatedAlreadyFetched =
                                Dict.insert (Reference.toString ref) newActiveTooltip model.definitions
                        in
                        ( { model | activeTooltip = Just newActiveTooltip, definitions = updatedAlreadyFetched }, Cmd.none )

                    else
                        ( { model | activeTooltip = Nothing }, Cmd.none )

                Nothing ->
                    ( { model | activeTooltip = Nothing }, Cmd.none )



-- HELPERS


{-| This is intended to be used over `view`, and comes with a way to map the msg.
-}
tooltipConfig : (Msg -> msg) -> Model -> TooltipConfig msg
tooltipConfig toMsg model =
    { toHoverStart = ShowTooltip >> toMsg
    , toHoverEnd = HideTooltip >> toMsg
    , toTooltip = \ref -> view model ref
    }



-- EFFECTS


fetchDefinition : Config -> Reference -> ApiRequest DefinitionDetail Msg
fetchDefinition { toApiEndpoint, perspective } ref =
    CodebaseApi.Definition
        { perspective = perspective, ref = ref }
        |> toApiEndpoint
        |> HttpApi.toRequest (decodeDetail ref)
            (FetchDefinitionFinished ref)



-- VIEW


viewDetail : WebData DefinitionDetail -> Maybe (Tooltip.Content msg)
viewDetail detail =
    let
        viewDetail_ s =
            case s of
                TermHover (Term _ _ { info, source }) ->
                    Source.viewTermSource (SourceViewConfig.rich_ NotLinked) info.name source

                TypeHover (Type _ _ { source }) ->
                    Source.viewTypeSource (SourceViewConfig.rich_ NotLinked) source

                AbilityConstructorHover (AbilityConstructor _ { source }) ->
                    Source.viewTypeSource (SourceViewConfig.rich_ NotLinked) source

                DataConstructorHover (DataConstructor _ { source }) ->
                    Source.viewTypeSource (SourceViewConfig.rich_ NotLinked) source

        loading =
            Tooltip.rich
                (Placeholder.text
                    |> Placeholder.withSize Placeholder.Small
                    |> Placeholder.withLength Placeholder.Small
                    |> Placeholder.withIntensity Placeholder.Subdued
                    |> Placeholder.view
                )
    in
    case detail of
        NotAsked ->
            Just loading

        Loading ->
            Just loading

        Success sum ->
            Just (Tooltip.rich (div [ class "monochrome" ] [ viewDetail_ sum ]))

        Failure _ ->
            Nothing


view : Model -> Reference -> Maybe (Tooltip msg)
view model reference =
    let
        withMatchingReference ( r, d ) =
            if Reference.equals r reference then
                Just d

            else
                Nothing

        view_ d =
            d
                |> viewDetail
                |> Maybe.map Tooltip.tooltip
                |> Maybe.map (Tooltip.withArrow Tooltip.Start)
                |> Maybe.map (Tooltip.withPosition Tooltip.Below)
                |> Maybe.map Tooltip.show
    in
    model.activeTooltip
        |> Maybe.andThen withMatchingReference
        |> Maybe.andThen view_



-- JSON DECODERS


decodeTypeDetail : Decode.Decoder DefinitionDetail
decodeTypeDetail =
    let
        makeTypeDetail hash cat fqn name_ otherNames source =
            let
                info =
                    { name = name_
                    , namespace = Maybe.map FQN.fromString (FQN.namespaceOf name_ fqn)
                    , otherNames = otherNames
                    }
            in
            Type hash cat { info = info, source = source }
    in
    Decode.map TypeHover
        (Decode.map6 makeTypeDetail
            (field "hash" Hash.decode)
            (Type.decodeTypeCategory [ "tag" ])
            (field "name" FQN.decode)
            (field "bestTypeName" FQN.decode)
            (field "typeNames" (Decode.list FQN.decode))
            (Type.decodeTypeSource [ "typeDefinition", "tag" ] [ "typeDefinition", "contents" ])
        )


decodeTermDetail : Decode.Decoder DefinitionDetail
decodeTermDetail =
    let
        makeTermDetail hash cat fqn name_ otherNames source =
            let
                info =
                    { name = name_
                    , namespace = Maybe.map FQN.fromString (FQN.namespaceOf name_ fqn)
                    , otherNames = otherNames
                    }
            in
            Term hash cat { info = info, source = source }
    in
    Decode.map TermHover
        (Decode.map6 makeTermDetail
            (field "hash" Hash.decode)
            (Term.decodeTermCategory [ "tag" ])
            (field "name" FQN.decode)
            (field "bestTermName" FQN.decode)
            (field "termNames" (Decode.list FQN.decode))
            (Term.decodeTermSource [ "signature" ] [ "termDefinition", "tag" ] [ "termDefinition", "contents" ])
        )


decodeAbilityConstructorDetail : Decode.Decoder DefinitionDetail
decodeAbilityConstructorDetail =
    let
        makeAbilityConstructorDetail hash fqn name_ otherNames signature source =
            let
                info =
                    { name = name_
                    , namespace = Maybe.map FQN.fromString (FQN.namespaceOf name_ fqn)
                    , otherNames = otherNames
                    }
            in
            AbilityConstructor hash
                { info = info
                , signature = signature
                , source = source
                }
    in
    Decode.map AbilityConstructorHover
        (Decode.map6 makeAbilityConstructorDetail
            (field "hash" Hash.decode)
            (field "name" FQN.decode)
            (field "bestTypeName" FQN.decode)
            (field "typeNames" (Decode.list FQN.decode))
            (AbilityConstructor.decodeSignature [ "detail", "contents" ])
            (AbilityConstructor.decodeSource [ "typeDefinition", "tag" ] [ "typeDefinition", "contents" ])
        )


decodeDataConstructorDetail : Decode.Decoder DefinitionDetail
decodeDataConstructorDetail =
    let
        makeDataConstructorDetail hash fqn name_ otherNames signature source =
            let
                info =
                    { name = name_
                    , namespace = Maybe.map FQN.fromString (FQN.namespaceOf name_ fqn)
                    , otherNames = otherNames
                    }
            in
            DataConstructor hash
                { info = info
                , signature = signature
                , source = source
                }
    in
    Decode.map DataConstructorHover
        (Decode.map6 makeDataConstructorDetail
            (field "hash" Hash.decode)
            (field "name" FQN.decode)
            (field "bestTypeName" FQN.decode)
            (field "typeNames" (Decode.list FQN.decode))
            (DataConstructor.decodeSignature [ "detail", "contents" ])
            (DataConstructor.decodeSource [ "typeDefinition", "tag" ] [ "typeDefinition", "contents" ])
        )


decodeDetail : Reference -> Decode.Decoder DefinitionDetail
decodeDetail ref =
    case ref of
        TermReference _ ->
            decodeTermDetail

        TypeReference _ ->
            decodeTypeDetail

        AbilityConstructorReference _ ->
            decodeAbilityConstructorDetail

        DataConstructorReference _ ->
            decodeDataConstructorDetail
