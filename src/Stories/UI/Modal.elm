module Stories.UI.Modal exposing (..)

import Html exposing (Html)
import Lib.Util exposing (col)
import Storybook.Story exposing (Story)
import UI.Modal as M


main : Story () Msg
main =
    Storybook.Story.stateless
        { view = view
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
    (elements |> List.map M.view)
        |> col []
