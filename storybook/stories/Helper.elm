module Helper exposing (..)

import Html exposing (Attribute, Html)
import Html.Attributes


col : List (Attribute msg) -> List (Html msg) -> Html msg
col attrs children =
    Html.div (Html.Attributes.class "col" :: attrs) children
