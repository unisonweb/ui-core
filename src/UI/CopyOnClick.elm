module UI.CopyOnClick exposing (..)

import Html exposing (Attribute, Html, button, div, node)
import Html.Attributes exposing (attribute, class)
import Html.Events exposing (on)
import Json.Decode as Decode
import UI.Icon as Icon


onCopy : (String -> msg) -> Attribute msg
onCopy msg =
    Decode.map msg Decode.string
        |> on "copy"


view : String -> Html msg -> Html msg -> Html msg
view toCopy trigger success =
    node "copy-on-click"
        [ class "copy-on-click", attribute "text" toCopy ]
        [ trigger, div [ class "copy-on-click_success" ] [ success ] ]


view_ : (String -> msg) -> String -> Html msg -> Html msg -> Html msg
view_ onCopyMsg toCopy trigger success =
    node "copy-on-click"
        [ class "copy-on-click", onCopy onCopyMsg, attribute "text" toCopy ]
        [ trigger, div [ class "copy-on-click_success" ] [ success ] ]


{-| We're not using UI.Button here since a click handler is added from
the webcomponent in JS land.
-}
copyButton : String -> Html msg
copyButton toCopy =
    view
        toCopy
        (button [ class "button contained default" ] [ Icon.view Icon.clipboard ])
        (div [ class "copy-field_success" ] [ Icon.view Icon.checkmark ])


copyButton_ : (String -> msg) -> String -> Html msg
copyButton_ onCopyMsg toCopy =
    view_ onCopyMsg
        toCopy
        (button [ class "button contained default" ] [ Icon.view Icon.clipboard ])
        (div [ class "copy-field_success" ] [ Icon.view Icon.checkmark ])
