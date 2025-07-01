module Lib.ProdDebug exposing (..)

import Html exposing (Html, node)
import Html.Attributes exposing (attribute)


view : String -> List (Html msg) -> Html msg
view debugMessage content =
    node "prod-debug" [ attribute "message" debugMessage ] content
