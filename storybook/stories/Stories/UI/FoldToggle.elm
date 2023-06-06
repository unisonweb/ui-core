module Stories.UI.FoldToggle exposing (..)

import Browser
import Helpers.Layout exposing (columns)
import Html exposing (Html)
import UI.FoldToggle as F


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


elements : List (F.FoldToggle Msg)
elements =
    [ F.foldToggle UserClicked
    , F.foldToggle UserClicked |> F.open
    , F.disabled
    ]


view : Html Msg
view =
    columns [] (elements |> List.map F.view)
