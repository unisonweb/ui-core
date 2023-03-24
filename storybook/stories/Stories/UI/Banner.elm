module Stories.UI.Banner exposing (..)

import Browser
import Helpers.Layout exposing (col)
import Html exposing (Html)
import UI.Banner as B
import UI.Click as C


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


type alias Msg =
    ()


elements : List (B.Banner Msg)
elements =
    [ B.info "Info"
    , B.promotion "Promotion ID" "Content" (C.ExternalHref "https://unison-lang.org") "Link"
    ]


view : Model -> Html Msg
view _ =
    (elements |> List.map B.view)
        |> col []
