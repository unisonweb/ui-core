module Stories.UI.FoldToggle exposing (..)

import Browser
import Helpers.Layout exposing (col)
import Html exposing (Html)
import UI.FoldToggle as F


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


elements : List (F.FoldToggle Msg)
elements =
    [ F.foldToggle UserClicked
    , F.foldToggle UserClicked |> F.open
    , F.disabled
    ]


view : Model -> Html Msg
view _ =
    (elements |> List.map F.view)
        |> col []
