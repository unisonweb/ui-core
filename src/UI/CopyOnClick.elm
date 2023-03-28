module UI.CopyOnClick exposing (..)

import Html exposing (Html, node)
import Html.Attributes exposing (attribute)


view : String -> Html msg -> Html msg
view toCopy trigger =
    node "copy-on-click"
        [ attribute "text" toCopy ]
        [ trigger ]
