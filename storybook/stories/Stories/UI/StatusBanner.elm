module Stories.UI.StatusBanner exposing (..)

import Browser
import Helpers.Layout exposing (col)
import Html exposing (Html)
import UI.StatusBanner as S


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
    [ S.good "good text"
    , S.bad "bad text"
    , S.info "info text"
    , S.working "working text"
    ]


view : Html msg
view =
    elements
        |> col []
