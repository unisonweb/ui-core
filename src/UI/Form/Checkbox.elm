module UI.Form.Checkbox exposing (..)

import Html exposing (Html, div, input)
import Html.Attributes exposing (checked, class, type_)
import UI.Click as Click


type alias Checkbox msg =
    { onChange : Maybe msg
    , checked : Bool
    }



-- CREATE


checkbox : msg -> Bool -> Checkbox msg
checkbox onChange checked =
    checkbox_ (Just onChange) checked


checkbox_ : Maybe msg -> Bool -> Checkbox msg
checkbox_ onChange checked =
    Checkbox onChange checked



-- VIEW


view : Checkbox msg -> Html msg
view box =
    case box.onChange of
        Just onChange ->
            Click.view [ class "checkbox" ]
                [ input [ type_ "checkbox", checked box.checked ] [] ]
                (Click.onClick onChange)

        Nothing ->
            div [ class "checkbox" ]
                [ input [ type_ "checkbox", checked box.checked ] []
                ]
