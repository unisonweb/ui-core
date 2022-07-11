module Lib.OnClickOutside exposing (onClickOutside)

import Html exposing (Html, node)
import Html.Attributes exposing (id)
import Html.Events exposing (on)
import Json.Decode as Decode


onClickOutside : msg -> Html msg -> Html msg
onClickOutside clickOutsideMsg content =
    node "on-click-outside"
        [ id "on-click-outside", on "clickOutside" (Decode.succeed clickOutsideMsg) ]
        [ content ]
