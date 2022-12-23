module Stories.UI.CopyField exposing (..)

import Html exposing (Html)
import Lib.Util exposing (col)
import Storybook.Story exposing (Story)
import UI.CopyField as C


main : Story () Msg
main =
    Storybook.Story.stateless
        { view = view
        }


type Msg
    = Copied String


elements : List (C.CopyField Msg)
elements =
    [ C.copyField Copied "field"
    ]


view : Html Msg
view =
    (elements |> List.map C.view)
        |> col []
