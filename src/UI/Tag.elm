module UI.Tag exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import UI.Click as Click exposing (Click)


type alias Tag msg =
    { label : String, click : Maybe (Click msg) }



-- CREATE


tag : String -> Tag msg
tag label_ =
    { label = label_, click = Nothing }



-- MODIFY


withClick : Click msg -> Tag msg -> Tag msg
withClick click t =
    { t | click = Just click }



-- VIEW


view : Tag msg -> Html msg
view { label, click } =
    let
        attrs =
            [ class "tag" ]

        content =
            [ text label ]
    in
    case click of
        Just c ->
            Click.view attrs content c

        Nothing ->
            div attrs content
