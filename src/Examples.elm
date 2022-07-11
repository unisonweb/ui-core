module Examples exposing (..)

import Browser
import Html exposing (Html, div, text)
import UI.ActionMenu as ActionMenu


type alias Model =
    ()


init : Model
init =
    ()


type Msg
    = NoOp


update : Msg -> Model -> Model
update _ model =
    model


view : Model -> Html Msg
view _ =
    div [] [ text "ActionMenu" ]


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }
