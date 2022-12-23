module Stories.UI.Card exposing (..)

import Html exposing (Html)
import Lib.Util exposing (col)
import Storybook.Story exposing (Story)
import UI.Card as C


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


elements : List (C.Card Msg)
elements =
    [ C.card items
    , C.titled "Title" items
    ]


view : Html Msg
view =
    (elements |> List.map C.view)
        |> col []
