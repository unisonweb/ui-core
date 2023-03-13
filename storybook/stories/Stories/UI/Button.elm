module Stories.UI.Button exposing (..)

import Browser
import Helpers.Layout exposing (col)
import Html exposing (Html)
import UI.Button as B
import UI.Icon as I


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
    = UserClicked


elements : List (B.Button Msg)
elements =
    [ B.button UserClicked "Button"
    , B.icon UserClicked I.unisonMark
    , B.iconThenLabel UserClicked I.unisonMark "Icon then Label"
    , B.labelThenIcon UserClicked "Label then Icon" I.unisonMark
    , B.iconThenLabelThenIcon UserClicked I.unisonMark "Icon then Label then Icon" I.unisonMark
    ]


view : Model -> Html Msg
view _ =
    (elements |> List.map B.view)
        |> col []
