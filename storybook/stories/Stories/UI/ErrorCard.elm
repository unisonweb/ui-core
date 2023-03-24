module Stories.UI.ErrorCard exposing (..)

import Browser
import Helpers.Layout exposing (col)
import Html exposing (Html)
import UI.ErrorCard as E


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


elements : List (E.ErrorCard Msg)
elements =
    [ E.empty
    , E.errorCard "Error Card Title" "Error Card Text"
    ]


view : Model -> Html Msg
view _ =
    (elements |> List.map E.view)
        |> col []
