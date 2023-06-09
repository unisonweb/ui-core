module Stories.UI.Tooltip exposing (..)

import Browser
import Helpers.Layout exposing (columns)
import Html exposing (Html, span, text)
import Html.Attributes exposing (class)
import UI.Placeholder as Placeholder
import UI.Tooltip as Tooltip


main : Program () () msg
main =
    Browser.element
        { init = \_ -> ( (), Cmd.none )
        , view = \_ -> view
        , update = \_ currentModel -> ( currentModel, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }


trigger : String -> Html msg
trigger t =
    span [] [ text t ]


elements : List (Html msg)
elements =
    [ Tooltip.tooltip (Tooltip.text "Text tooltip")
        |> Tooltip.view (trigger "Text tooltip")
    , Tooltip.tooltip (Placeholder.text |> Placeholder.small |> Placeholder.view |> Tooltip.rich)
        |> Tooltip.view (trigger "Placeholder tooltip")
    ]


view : Html msg
view =
    columns [ class "padded" ] elements
