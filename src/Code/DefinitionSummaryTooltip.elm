module Code.DefinitionSummaryTooltip exposing (Model, Msg, init, tooltipConfig, update)

import Code.CodebaseApi as CodebaseApi
import Code.Config exposing (Config)
import Code.Definition.AbilityConstructor exposing (AbilityConstructor(..), AbilityConstructorSummary)
import Code.Definition.DataConstructor as DataConstructor exposing (DataConstructor(..), DataConstructorSummary)
import Code.Definition.Reference as Reference exposing (Reference(..))
import Code.Definition.Term as Term exposing (Term(..), TermSummary, termSignatureSyntax)
import Code.Definition.Type as Type exposing (Type(..), TypeSummary, typeSourceSyntax)
import Code.FullyQualifiedName as FQN
import Code.Hash as Hash
import Code.Syntax as Syntax
import Html exposing (div, span, text)
import Html.Attributes exposing (class)
import Json.Decode as Decode exposing (at, field)
import Lib.HttpApi as HttpApi exposing (ApiRequest, HttpResult)
import RemoteData exposing (RemoteData(..), WebData)
import UI.PlaceholderShape as PlaceholderShape
import UI.Tooltip as Tooltip exposing (Tooltip)



-- MODEL


type DefinitionSummary
    = TermHover TermSummary
    | TypeHover TypeSummary
    | DataConstructorHover DataConstructorSummary
    | AbilityConstructorHover AbilityConstructorSummary


type alias Model =
    Maybe ( Reference, WebData DefinitionSummary )


init : Model
init =
    Nothing



-- UPDATE


type Msg
    = ShowTooltip Reference
    | HideTooltip Reference
    | FetchDefinitionFinished Reference (HttpResult DefinitionSummary)


update : Config -> Msg -> Model -> ( Model, Cmd Msg )
update config msg model =
    case msg of
        ShowTooltip ref ->
            ( Just ( ref, Loading )
            , fetchDefinition config ref |> HttpApi.perform config.api
            )

        HideTooltip _ ->
            ( Nothing, Cmd.none )

        FetchDefinitionFinished ref d ->
            case model of
                Just ( r, _ ) ->
                    if Reference.equals ref r then
                        ( Just ( r, RemoteData.fromResult d ), Cmd.none )

                    else
                        ( Nothing, Cmd.none )

                Nothing ->
                    ( Nothing, Cmd.none )



-- HELPERS


{-| This is intended to be used over `view`, and comes with a way to map the msg.
-}
tooltipConfig : (Msg -> msg) -> Model -> Syntax.TooltipConfig msg
tooltipConfig toMsg model =
    { toHoverStart = ShowTooltip >> toMsg
    , toHoverEnd = HideTooltip >> toMsg
    , toTooltip = \ref -> view model ref
    }



-- EFFECTS


fetchDefinition : Config -> Reference -> ApiRequest DefinitionSummary Msg
fetchDefinition { toApiEndpoint, perspective } ref =
    CodebaseApi.Summary
        { perspective = perspective, ref = ref }
        |> toApiEndpoint
        |> HttpApi.toRequest (decodeSummary ref)
            (FetchDefinitionFinished ref)



-- VIEW


viewSummary : WebData DefinitionSummary -> Tooltip.Content msg
viewSummary summary =
    let
        viewBuiltinType name =
            span
                []
                [ span [ class "data-type-modifier" ] [ text "builtin " ]
                , span [ class "data-type-keyword" ] [ text "type" ]
                , span [ class "type-reference" ] [ text (" " ++ FQN.toString name) ]
                ]

        viewSummary_ s =
            case s of
                TermHover (Term _ _ { signature }) ->
                    Syntax.view Syntax.NotLinked (termSignatureSyntax signature)

                TypeHover (Type _ _ { fqn, source }) ->
                    source
                        |> typeSourceSyntax
                        |> Maybe.map (Syntax.view Syntax.NotLinked)
                        |> Maybe.withDefault (viewBuiltinType fqn)

                AbilityConstructorHover (AbilityConstructor _ { signature }) ->
                    Syntax.view Syntax.NotLinked (termSignatureSyntax signature)

                DataConstructorHover (DataConstructor _ { signature }) ->
                    Syntax.view Syntax.NotLinked (termSignatureSyntax signature)
    in
    case summary of
        NotAsked ->
            Tooltip.rich
                (PlaceholderShape.text
                    |> PlaceholderShape.withSize PlaceholderShape.Small
                    |> PlaceholderShape.withLength PlaceholderShape.Small
                    |> PlaceholderShape.withIntensity PlaceholderShape.Subdued
                    |> PlaceholderShape.view
                )

        Loading ->
            Tooltip.text ""

        Success sum ->
            Tooltip.rich (div [ class "monochrome" ] [ viewSummary_ sum ])

        Failure _ ->
            Tooltip.text ""


view : Model -> Reference -> Maybe (Tooltip msg)
view model reference =
    let
        withMatchingReference ( r, d ) =
            if Reference.equals r reference then
                Just d

            else
                Nothing

        view_ d =
            Tooltip.tooltip (viewSummary d)
                |> Tooltip.withArrow Tooltip.Start
                |> Tooltip.withPosition Tooltip.Below
                |> Tooltip.show
    in
    model
        |> Maybe.andThen withMatchingReference
        |> Maybe.map view_



-- JSON DECODERS


decodeTypeSummary : Decode.Decoder DefinitionSummary
decodeTypeSummary =
    let
        makeSummary fqn name_ source =
            { fqn = fqn
            , name = name_
            , namespace = FQN.namespaceOf name_ fqn
            , source = source
            }
    in
    Decode.map TypeHover
        (Decode.map3 Type
            (field "hash" Hash.decode)
            (Type.decodeTypeCategory [ "tag" ])
            (Decode.map3 makeSummary
                (field "fqn" FQN.decode)
                (field "fqn" FQN.decode)
                (Type.decodeTypeSource [ "summary", "tag" ] [ "summary", "contents" ])
            )
        )


decodeTermSummary : Decode.Decoder DefinitionSummary
decodeTermSummary =
    let
        makeSummary fqn name_ signature =
            { fqn = fqn
            , name = name_
            , namespace = FQN.namespaceOf name_ fqn
            , signature = signature
            }
    in
    Decode.map TermHover
        (Decode.map3 Term
            (field "hash" Hash.decode)
            (Term.decodeTermCategory [ "tag" ])
            (Decode.map3 makeSummary
                (field "fqn" FQN.decode)
                (field "fqn" FQN.decode)
                (Term.decodeSignature [ "summary", "contents" ])
            )
        )


decodeAbilityConstructorSummary : Decode.Decoder DefinitionSummary
decodeAbilityConstructorSummary =
    let
        makeSummary fqn name_ signature =
            { fqn = fqn
            , name = name_
            , namespace = FQN.namespaceOf name_ fqn
            , signature = signature
            }
    in
    Decode.map AbilityConstructorHover
        (Decode.map2 AbilityConstructor
            (field "hash" Hash.decode)
            (Decode.map3 makeSummary
                (field "fqn" FQN.decode)
                (field "fqn" FQN.decode)
                (DataConstructor.decodeSignature [ "summary", "contents" ])
            )
        )


decodeDataConstructorSummary : Decode.Decoder DefinitionSummary
decodeDataConstructorSummary =
    let
        makeSummary fqn name_ signature =
            { fqn = fqn
            , name = name_
            , namespace = FQN.namespaceOf name_ fqn
            , signature = signature
            }
    in
    Decode.map DataConstructorHover
        (Decode.map2 DataConstructor
            (at [ "hash" ] Hash.decode)
            (Decode.map3 makeSummary
                (field "fqn" FQN.decode)
                (field "fqn" FQN.decode)
                (DataConstructor.decodeSignature [ "summary", "contents" ])
            )
        )


decodeSummary : Reference -> Decode.Decoder DefinitionSummary
decodeSummary ref =
    case ref of
        TermReference _ ->
            decodeTermSummary

        TypeReference _ ->
            decodeTypeSummary

        AbilityConstructorReference _ ->
            decodeAbilityConstructorSummary

        DataConstructorReference _ ->
            decodeDataConstructorSummary
