module Stories.UI.Placeholder exposing (..)

import Browser
import Helpers.Layout exposing (columns)
import Html exposing (Html)
import Html.Attributes exposing (class)
import UI.Placeholder as Placeholder


main : Program () () msg
main =
    Browser.element
        { init = \_ -> ( (), Cmd.none )
        , view = \_ -> view
        , update = \_ currentModel -> ( currentModel, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }


elements : List (Html msg)
elements =
    [ Placeholder.text |> Placeholder.view
    ]


view : Html msg
view =
    columns [ class "padded" ] elements
