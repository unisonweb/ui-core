module Stories.UI.ErrorCard exposing (..)

import Html exposing (Html)
import Lib.Util exposing (col)
import Storybook.Story exposing (Story)
import UI.ErrorCard as E


main : Story () Msg
main =
    Storybook.Story.stateless
        { view = view
        }


type Msg
    = UserClicked


elements : List (E.ErrorCard Msg)
elements =
    [ E.empty
    , E.errorCard "Error Card Title"
    ]


view : Html Msg
view =
    (elements |> List.map E.view)
        |> col []
