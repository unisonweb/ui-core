module Code.DefinitionSummaryTooltip exposing (Model, Msg, init, tooltipConfig, update)

import Code.CodebaseApi as CodebaseApi
import Code.Config exposing (Config)
import Code.Definition.AbilityConstructor as AbilityConstructor exposing (AbilityConstructor(..), AbilityConstructorSummary)
import Code.Definition.DataConstructor as DataConstructor exposing (DataConstructor(..), DataConstructorSummary)
import Code.Definition.Reference as Reference exposing (Reference)
import Code.Definition.Term as Term exposing (Term(..), TermSummary, termSignatureSyntax)
import Code.Definition.Type as Type exposing (Type(..), TypeSummary, typeSourceSyntax)
import Code.FullyQualifiedName as FQN
import Code.Hash as Hash
import Code.Syntax as Syntax
import Json.Decode as Decode exposing (at, field)
import Json.Decode.Extra exposing (when)
import Lib.HttpApi as HttpApi exposing (ApiRequest, HttpResult)
import Lib.Util exposing (decodeTag)
import RemoteData exposing (RemoteData(..), WebData)
import UI
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
        |> HttpApi.toRequest decodeSummary
            (FetchDefinitionFinished ref)



-- VIEW


viewSummary : WebData DefinitionSummary -> Tooltip.Content msg
viewSummary summary =
    let
        viewSummary_ s =
            case s of
                TermHover (Term _ _ { signature }) ->
                    Syntax.view Syntax.NotLinked (termSignatureSyntax signature)

                TypeHover (Type _ _ { source }) ->
                    source
                        |> typeSourceSyntax
                        |> Maybe.map (Syntax.view Syntax.NotLinked)
                        |> Maybe.withDefault UI.nothing

                AbilityConstructorHover (AbilityConstructor _ { signature }) ->
                    Syntax.view Syntax.NotLinked (termSignatureSyntax signature)

                DataConstructorHover (DataConstructor _ { signature }) ->
                    Syntax.view Syntax.NotLinked (termSignatureSyntax signature)
    in
    case summary of
        NotAsked ->
            Tooltip.text ""

        Loading ->
            Tooltip.text ""

        Success sum ->
            Tooltip.rich (viewSummary_ sum)

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
            (at [ "namedType", "typeHash" ] Hash.decode)
            (Type.decodeTypeCategory [ "namedType", "typeTag" ])
            (Decode.map3 makeSummary
                (at [ "namedType", "typeName" ] FQN.decode)
                (field "bestFoundTypeName" FQN.decode)
                (Type.decodeTypeSource [ "typeDef", "tag" ] [ "typeDef", "contents" ])
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
                (field "bestFoundTermName" FQN.decode)
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


decodeSummary : Decode.Decoder DefinitionSummary
decodeSummary =
    let
        termTypeByHash hash =
            if Hash.isAbilityConstructorHash hash then
                "AbilityConstructor"

            else if Hash.isDataConstructorHash hash then
                "DataConstructor"

            else
                "Term"

        decodeConstructorSuffix =
            Decode.map termTypeByHash (at [ "hash" ] Hash.decode)
    in
    Decode.oneOf
        [ decodeTermSummary ]



{-
   [ when decodeConstructorSuffix ((==) "AbilityConstructor") (field "contents" decodeAbilityConstructorSummary)
   , when decodeConstructorSuffix ((==) "DataConstructor") (field "contents" decodeDataConstructorSummary)
   , when decodeTag ((==) "FoundTermResult") (field "contents" decodeTermSummary)
   , when decodeTag ((==) "FoundTypeResult") (field "contents" decodeTypeSummary)
   ]
-}
