module UI.Nudge exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class, classList)
import UI
import UI.Tooltip as Tooltip exposing (Tooltip)


type NudgeEmphasis
    = NormalEmphasis
    | Emphasized


type Nudge msg
    = NoNudge
    | Nudge
        { withTooltip : Maybe (Tooltip msg)
        , pulsate : Bool
        , withNumber : Maybe Int
        , emphasis : NudgeEmphasis
        }



-- CREATE


empty : Nudge msg
empty =
    NoNudge


nudge : Nudge msg
nudge =
    Nudge
        { withTooltip = Nothing
        , pulsate = False
        , withNumber = Nothing
        , emphasis = NormalEmphasis
        }



-- MODIFY


withTooltip : Tooltip msg -> Nudge msg -> Nudge msg
withTooltip tooltip nudge_ =
    case nudge_ of
        NoNudge ->
            -- create a new Nudge with the default settings
            withTooltip tooltip nudge

        Nudge n ->
            Nudge { n | withTooltip = Just tooltip }


withEmphasis : NudgeEmphasis -> Nudge msg -> Nudge msg
withEmphasis emphasis nudge_ =
    case nudge_ of
        NoNudge ->
            nudge_

        Nudge n ->
            Nudge { n | emphasis = emphasis }


emphasized : Nudge msg -> Nudge msg
emphasized nudge_ =
    withEmphasis Emphasized nudge_


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
                , emphasis = n.emphasis
                }



-- VIEW


viewNudgeDot : NudgeEmphasis -> Bool -> Maybe Int -> Html msg
viewNudgeDot emphasis pulsate_ withNumber_ =
    let
        ( num, hasNumber ) =
            withNumber_
                |> Maybe.map (String.fromInt >> text)
                |> Maybe.map (\n -> ( n, True ))
                |> Maybe.withDefault ( UI.nothing, False )
    in
    div
        [ class "nudge"
        , classList
            [ ( "pulsate", pulsate_ )
            , ( "with-number", hasNumber )
            , ( "nudge_emphasized", emphasis == Emphasized )
            ]
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
                    viewNudgeDot settings.emphasis settings.pulsate settings.withNumber

                Just tooltip ->
                    Tooltip.view (viewNudgeDot settings.emphasis settings.pulsate settings.withNumber) tooltip
