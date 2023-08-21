module UI.Nudge exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Maybe.Extra as MaybeE
import UI
import UI.Tooltip as Tooltip exposing (Tooltip)


type Nudge msg
    = NoNudge
    | Nudge
        { withTooltip : Maybe (Tooltip msg)
        , pulsate : Bool
        , withNumber : Maybe Int
        }



-- CREATE


empty : Nudge msg
empty =
    NoNudge


nudge : Nudge msg
nudge =
    Nudge { withTooltip = Nothing, pulsate = False, withNumber = Nothing }



-- MODIFY


withTooltip : Tooltip msg -> Nudge msg -> Nudge msg
withTooltip tooltip nudge_ =
    case nudge_ of
        NoNudge ->
            -- create a new Nudge with the default settings
            withTooltip tooltip nudge

        Nudge n ->
            Nudge { n | withTooltip = Just tooltip }


pulsate : Nudge msg -> Nudge msg
pulsate nudge_ =
    case nudge_ of
        NoNudge ->
            -- create a new Nudge with the default settings
            pulsate nudge

        Nudge n ->
            Nudge { n | pulsate = True }


withNumber : Int -> Nudge msg -> Nudge msg
withNumber n nudge_ =
    case nudge_ of
        NoNudge ->
            -- create a new Nudge with the default settings
            withNumber n nudge

        Nudge n_ ->
            Nudge { n_ | withNumber = Just n }



-- MAP


map : (a -> msg) -> Nudge a -> Nudge msg
map toMsg nudgeA =
    case nudgeA of
        NoNudge ->
            NoNudge

        Nudge n ->
            Nudge
                { withTooltip = Maybe.map (Tooltip.map toMsg) n.withTooltip
                , pulsate = n.pulsate
                , withNumber = n.withNumber
                }



-- VIEW


viewNudgeDot : Bool -> Maybe Int -> Html msg
viewNudgeDot pulsate_ withNumber_ =
    let
        num =
            MaybeE.unwrap UI.nothing (String.fromInt >> text) withNumber_
    in
    div
        [ if pulsate_ then
            class "nudge pulsate"

          else
            class "nudge"
        ]
        [ div [ class "nudge_circle" ] [ num ]
        ]


view : Nudge msg -> Html msg
view nudge_ =
    case nudge_ of
        NoNudge ->
            UI.nothing

        Nudge settings ->
            case settings.withTooltip of
                Nothing ->
                    viewNudgeDot settings.pulsate settings.withNumber

                Just tooltip ->
                    Tooltip.view (viewNudgeDot settings.pulsate settings.withNumber) tooltip
