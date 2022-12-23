module Stories.UI.KeyboardShortcut exposing (..)

import Html exposing (Html)
import Lib.OperatingSystem
import Storybook.Story exposing (Story)
import UI.KeyboardShortcut as K
import UI.KeyboardShortcut.Key as Key
import Util exposing (col)


main : Story () Msg
main =
    Storybook.Story.stateless
        { view = view
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
