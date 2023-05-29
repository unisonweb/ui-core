module Stories.UI.PlaceholderShape exposing (..)

import Browser
import Helpers.Layout exposing (col)
import Html exposing (Html)
import UI.PlaceholderShape as P


main : Program () () msg
main =
    Browser.element
        { init = \_ -> ( (), Cmd.none )
        , view = \_ -> view
        , update = \_ currentModel -> ( currentModel, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }


elements : List P.PlaceholderShape
elements =
    [ P.text
    , P.text |> P.tiny
    , P.text |> P.small
    , P.text |> P.medium
    , P.text |> P.large
    , P.text |> P.huge
    , P.text |> P.emphasized
    , P.text |> P.normal
    , P.text |> P.subdued
    ]


view : Html msg
view =
    elements
        |> List.map P.view
        |> col []
