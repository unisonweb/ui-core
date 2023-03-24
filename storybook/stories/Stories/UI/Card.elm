module Stories.UI.Card exposing (..)

import Browser
import Helpers.Layout exposing (col)
import Html exposing (Html)
import UI.Card as C


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( (), Cmd.none )
        , view = view
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    ()


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


view : Model -> Html Msg
view _ =
    (elements |> List.map C.view)
        |> col []
