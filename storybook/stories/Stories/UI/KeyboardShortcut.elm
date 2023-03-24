module Stories.UI.KeyboardShortcut exposing (..)

import Browser
import Helpers.Layout exposing (col)
import Html exposing (Html)
import Lib.OperatingSystem
import UI.KeyboardShortcut as K
import UI.KeyboardShortcut.Key as Key


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


items : List (Html msg)
items =
    [ Html.text "Inner text"
    ]


elements : List K.KeyboardShortcut
elements =
    [ K.single Key.Shift
    , K.Sequence (Just Key.Alt) Key.Shift
    , K.Chord Key.Ctrl (Key.K Key.Lower)
    ]


model : K.Model
model =
    { key = Just Key.Ctrl
    , operatingSystem = Lib.OperatingSystem.MacOS
    }


view : Html Msg
view =
    (elements |> List.map (K.view model))
        |> col []
