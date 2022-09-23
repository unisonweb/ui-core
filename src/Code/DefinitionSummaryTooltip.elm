module Code.DefinitionSummaryTooltip exposing (Model, Msg, init, tooltipConfig, update)

import Code.Definition.Reference as Reference exposing (Reference)
import Code.Syntax as Syntax
import Html exposing (div, text)
import RemoteData exposing (RemoteData(..), WebData)
import UI.Tooltip as Tooltip exposing (Tooltip)



-- MODEL


type DefinitionSummary
    = Term
    | Type


type alias Model =
    Maybe ( Reference, WebData DefinitionSummary )


init : Model
init =
    Nothing



-- UPDATE


type Msg
    = ShowTooltip Reference
    | HideTooltip Reference
    | FetchDefinitionFinished Reference (WebData DefinitionSummary)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShowTooltip ref ->
            ( Just ( ref, Loading ), fetchDefinition ref )

        HideTooltip _ ->
            ( Nothing, Cmd.none )

        FetchDefinitionFinished ref d ->
            case model of
                Just ( r, _ ) ->
                    if Reference.equals ref r then
                        ( Just ( r, d ), Cmd.none )

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


fetchDefinition : Reference -> Cmd Msg
fetchDefinition _ =
    Cmd.none



-- VIEW


viewSummary : WebData DefinitionSummary -> Tooltip.Content msg
viewSummary _ =
    Tooltip.rich (div [] [ text "TODO" ])


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
                |> Tooltip.show
    in
    model
        |> Maybe.andThen withMatchingReference
        |> Maybe.map view_
