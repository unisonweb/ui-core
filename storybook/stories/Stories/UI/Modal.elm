module Stories.UI.Modal exposing (..)

import Browser
import Helpers.Layout exposing (columns)
import Html exposing (Html)
import UI.Modal as M


main : Program () () Msg
main =
    Browser.element
        { init = \_ -> ( (), Cmd.none )
        , view = \_ -> view
        , update = \_ currentModel -> ( currentModel, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }


type Msg
    = UserClicked


elements : List (M.Modal Msg)
elements =
    [ M.modal "Modal" UserClicked (M.Content (Html.text "Content"))
    , M.modal "Modal" UserClicked (M.CustomContent (Html.text "Custom Content"))

    -- ,M.modal "Modal" UserClicked (M.Content (Html.text "Content")) |> M.withHeader "Header"
    ]


view : Html Msg
view =
    columns [] (elements |> List.map M.view)
