module UI.CopyOnClick exposing (..)

import Html exposing (Attribute, Html, div, node)
import Html.Attributes exposing (attribute, class)
import Html.Events exposing (on)
import Json.Decode as Decode


onCopy : (String -> msg) -> Attribute msg
onCopy msg =
    Decode.map msg Decode.string
        |> on "copy"


view : (String -> msg) -> String -> Html msg -> Html msg -> Html msg
view onCopyMsg toCopy trigger success =
    node "copy-on-click"
        [ class "copy-on-click", onCopy onCopyMsg, attribute "text" toCopy ]
        [ trigger, div [ class "copy-on-click_success" ] [ success ] ]
