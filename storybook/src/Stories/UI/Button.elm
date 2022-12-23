module Stories.UI.Button exposing (..)

import Html exposing (Html)
import Storybook.Story exposing (Story)
import UI.Button as B
import UI.Icon as I
import Util exposing (col)


main : Story () Msg
main =
    Storybook.Story.stateless
        { view = view
        }


type Msg
    = UserClicked


elements : List (B.Button Msg)
elements =
    [ B.button UserClicked "Button"
    , B.icon UserClicked I.unisonMark
    , B.iconThenLabel UserClicked I.unisonMark "Icon then Label"
    , B.labelThenIcon UserClicked "Label then Icon" I.unisonMark
    , B.iconThenLabelThenIcon UserClicked I.unisonMark "Icon then Label then Icon" I.unisonMark
    ]


view : Html Msg
view =
    (elements |> List.map B.view)
        |> col []
