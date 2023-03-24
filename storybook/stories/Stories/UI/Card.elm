module Stories.UI.Card exposing (..)

import Browser
import Helpers.Layout exposing (col)
import Html exposing (Html)
import UI.Card as C


main : Program () () Msg
main =
    Browser.element
        { init = \_ -> ( (), Cmd.none )
        , view = \_ -> view
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }


type alias Msg =
    ()


items : List (Html msg)
items =
    [ Html.text "Inner text"
    ]


elements : List (C.Card Msg)
elements =
    [ C.card items
    , C.titled "Title" items
    ]


view : Html Msg
view =
    (elements |> List.map C.view)
        |> col []
