module Stories.UI.CopyField exposing (..)

import Browser
import Helpers.Layout exposing (columns)
import Html exposing (Html)
import UI.CopyField as C


main : Program () () Msg
main =
    Browser.element
        { init = \_ -> ( (), Cmd.none )
        , view = \_ -> view
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }


type Msg
    = Copied String


elements : List (C.CopyField Msg)
elements =
    [ C.copyField Copied "field"
    ]


view : Html Msg
view =
    columns [] (elements |> List.map C.view)
