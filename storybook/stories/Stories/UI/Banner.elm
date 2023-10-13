module Stories.UI.Banner exposing (..)

import Browser
import Helpers.Layout exposing (columns)
import Html exposing (Html)
import UI.Banner as B
import UI.Click as C


main : Program () () Msg
main =
    Browser.element
        { init = \_ -> ( (), Cmd.none )
        , view = \_ -> view
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }


type alias Msg =
    ()


elements : List (B.Banner Msg)
elements =
    [ B.info "Info"
    , B.promotion "Promotion ID" "Content" (C.ExternalHref C.Blank "https://unison-lang.org") "Link"
    ]


view : Html Msg
view =
    columns [] (elements |> List.map B.view)
