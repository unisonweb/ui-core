module Stories.UI.ErrorCard exposing (..)

import Browser
import Helpers.Layout exposing (columns)
import Html exposing (Html)
import UI.ErrorCard as E


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


elements : List (E.ErrorCard Msg)
elements =
    [ E.empty
    , E.errorCard "Error Card Title" "Error Card Text"
    ]


view : Html Msg
view =
    columns [] (elements |> List.map E.view)
