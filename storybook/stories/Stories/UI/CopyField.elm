module Stories.UI.CopyField exposing (..)

import Browser
import Helpers.Layout exposing (col)
import Html exposing (Html)
import UI.CopyField as C


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


type Msg
    = Copied String


elements : List (C.CopyField Msg)
elements =
    [ C.copyField Copied "field"
    ]


view : Model -> Html Msg
view _ =
    (elements |> List.map C.view)
        |> col []
