module Stories.UI.Button exposing (..)

import Browser
import Helpers.Layout exposing (columns)
import Html exposing (Html)
import UI.Button as B
import UI.Icon as I


main : Program () () Msg
main =
    Browser.element
        { init = \_ -> ( (), Cmd.none )
        , view = \_ -> view
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }


type Msg
    = UserClicked


elements : List (B.Button Msg)
elements =
    [ B.button UserClicked "Button"
    , B.icon UserClicked I.unisonMark
    , B.iconThenLabel UserClicked I.unisonMark "Icon then Label"
    , B.labelThenIcon UserClicked "Label then Icon" I.unisonMark
    , B.iconThenLabelThenIcon UserClicked I.unisonMark "Icon then Label then Icon" I.caretDown
    ]


view : Html Msg
view =
    columns [] (elements |> List.map B.view)
