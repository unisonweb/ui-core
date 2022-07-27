module UI.Nudge exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import UI
import UI.Icon as Icon
import UI.Tooltip as Tooltip exposing (Tooltip)


type Nudge msg
    = NoNudge
    | Nudge { withTooltip : Maybe (Html msg -> Tooltip msg) }



-- CREATE


empty : Nudge msg
empty =
    NoNudge


nudge : Nudge msg
nudge =
    Nudge { withTooltip = Nothing }



-- MODIFY


withTooltip : (Html msg -> Tooltip msg) -> Nudge msg -> Nudge msg
withTooltip toTooltip _ =
    Nudge { withTooltip = Just toTooltip }



-- VIEW


viewNudgeDot : Html msg
viewNudgeDot =
    div [ class "nudge" ]
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
                    viewNudgeDot

                Just toTooltip ->
                    viewNudgeDot
                        |> toTooltip
                        |> Tooltip.view
