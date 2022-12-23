module Stories.UI.FoldToggle exposing (..)

import Html exposing (Html)
import Lib.Util exposing (col)
import Storybook.Story exposing (Story)
import UI.FoldToggle as F


main : Story () Msg
main =
    Storybook.Story.stateless
        { view = view
        }


type Msg
    = UserClicked


elements : List (F.FoldToggle Msg)
elements =
    [ F.foldToggle UserClicked
    , F.foldToggle UserClicked |> F.open
    , F.disabled
    ]


view : Html Msg
view =
    (elements |> List.map F.view)
        |> col []
