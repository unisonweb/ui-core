module UI.KpiTag exposing (..)

import Html exposing (Html, span, text)
import Html.Attributes exposing (class, classList)
import Lib.Util as Util
import Maybe.Extra as MaybeE
import UI
import UI.Click as Click exposing (Click)
import UI.Icon as Icon exposing (Icon)
import UI.Tooltip as Tooltip exposing (Tooltip)


type alias KpiTag msg =
    { singularLabel : String
    , pluralLabel : Maybe String
    , kpi : Int
    , tooltip : Maybe (Tooltip msg)
    , icon : Maybe (Icon msg)
    , click : Maybe (Click msg)
    }



-- CREATE


kpiTag : String -> Int -> KpiTag msg
kpiTag singular kpi =
    { singularLabel = singular
    , pluralLabel = Nothing
    , kpi = kpi
    , icon = Nothing
    , click = Nothing
    , tooltip = Nothing
    }



-- MODIFY


withPlural : String -> KpiTag msg -> KpiTag msg
withPlural plural kt =
    { kt | pluralLabel = Just plural }


withIcon : Icon msg -> KpiTag msg -> KpiTag msg
withIcon icon kt =
    { kt | icon = Just icon }


withClick : Click msg -> KpiTag msg -> KpiTag msg
withClick click kt =
    { kt | click = Just click }


withTooltip : Tooltip msg -> KpiTag msg -> KpiTag msg
withTooltip tooltip kt =
    { kt | tooltip = Just tooltip }



-- MAP


map : (msgA -> msgB) -> KpiTag msgA -> KpiTag msgB
map f kt =
    { singularLabel = kt.singularLabel
    , pluralLabel = kt.pluralLabel
    , kpi = kt.kpi
    , icon = Maybe.map (Icon.map f) kt.icon
    , click = Maybe.map (Click.map f) kt.click
    , tooltip = Maybe.map (Tooltip.map f) kt.tooltip
    }



-- VIEW


view : KpiTag msg -> Html msg
view { singularLabel, pluralLabel, kpi, icon, click, tooltip } =
    let
        kpi_ =
            span [ class "kpi-tag_kpi" ] [ text (String.fromInt kpi) ]

        icon_ =
            MaybeE.unwrap UI.nothing Icon.view icon

        label =
            let
                s =
                    singularLabel

                p =
                    Maybe.withDefault (s ++ "s") pluralLabel
            in
            Util.pluralize s p kpi

        label_ =
            span [ class "kpi-tag_label" ] [ text label ]

        content =
            [ kpi_, span [ class "kpi-tag_icon-then-label" ] [ icon_, label_ ] ]

        ( content_, hasTooltip ) =
            case tooltip of
                Just tooltip_ ->
                    ( [ Tooltip.view (span [] content) tooltip_ ], True )

                Nothing ->
                    ( content, False )

        classes interactive =
            classList
                [ ( "kpi-tag", True )
                , ( "kpi-tag_interactive", interactive )
                ]
    in
    case click of
        Just c ->
            Click.view [ classes True ] content_ c

        Nothing ->
            span [ classes hasTooltip ] content_
