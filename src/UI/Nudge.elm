module UI.Nudge exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import UI
import UI.Icon as Icon
import UI.Tooltip as Tooltip exposing (Tooltip)


type Nudge msg
    = NoNudge
    | Nudge
        { withTooltip : Maybe (Tooltip msg)
        , pulsate : Bool
        }



-- CREATE


empty : Nudge msg
empty =
    NoNudge


nudge : Nudge msg
nudge =
    Nudge { withTooltip = Nothing, pulsate = False }



-- MODIFY


withTooltip : Tooltip msg -> Nudge msg -> Nudge msg
withTooltip tooltip nudge_ =
    case nudge_ of
        NoNudge ->
            withTooltip tooltip nudge

        Nudge n ->
            Nudge { n | withTooltip = Just tooltip }


pulsate : Nudge msg -> Nudge msg
pulsate nudge_ =
    case nudge_ of
        NoNudge ->
            pulsate nudge

        Nudge n ->
            Nudge { n | pulsate = True }



-- VIEW


viewNudgeDot : Bool -> Html msg
viewNudgeDot pulsate_ =
    div
        [ if pulsate_ then
            class "nudge pulsate"

          else
            class "nudge"
        ]
        [ Icon.largeDot |> Icon.view
        ]


view : Nudge msg -> Html msg
view nudge_ =
    case nudge_ of
        NoNudge ->
            UI.nothing

        Nudge settings ->
            case settings.withTooltip of
                Nothing ->
                    viewNudgeDot settings.pulsate

                Just tooltip ->
                    Tooltip.view (viewNudgeDot settings.pulsate) tooltip
