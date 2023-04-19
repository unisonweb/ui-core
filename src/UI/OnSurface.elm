module UI.OnSurface exposing (..)

import Html
import Html.Attributes exposing (class)


type OnSurface
    = Dark
    | Light


dark : OnSurface
dark =
    Dark


light : OnSurface
light =
    Light


toClassName : OnSurface -> String
toClassName onSurface =
    case onSurface of
        Light ->
            "on-light"

        Dark ->
            "on-dark"


toClass : OnSurface -> Html.Attribute msg
toClass =
    toClassName >> class
