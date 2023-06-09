module Helpers.Layout exposing (..)

import Html exposing (Attribute, Html)
import Html.Attributes exposing (class)


columns : List (Attribute msg) -> List (Html msg) -> Html msg
columns attrs children =
    Html.div (class "columns" :: attrs) children


rows : List (Attribute msg) -> List (Html msg) -> Html msg
rows attrs children =
    Html.div (class "rows" :: attrs) children
