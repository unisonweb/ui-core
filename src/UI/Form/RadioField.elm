module UI.Form.RadioField exposing (..)

import Html exposing (Html, div, input, label, small, text)
import Html.Attributes exposing (checked, class, name, type_)
import List.Nonempty as NEL exposing (Nonempty)
import UI.Click as Click


type alias RadioOption a =
    { value : a
    , label : String
    , description : String
    }


type alias RadioField a msg =
    { name : String
    , onChange : a -> msg
    , options : Nonempty (RadioOption a)
    , selected : a
    }



-- CREATE


field : String -> (a -> msg) -> Nonempty (RadioOption a) -> a -> RadioField a msg
field =
    RadioField


option : a -> String -> String -> RadioOption a
option =
    RadioOption



-- VIEW


view : RadioField a msg -> Html msg
view element =
    let
        click value =
            Click.onClick (element.onChange value)

        viewRadioOption option_ =
            Click.view [ class "radio-field" ]
                [ input
                    [ type_ "radio"
                    , name element.name
                    , checked (option_.value == element.selected)
                    ]
                    []
                , div
                    [ class "label-and-help-text" ]
                    [ label [ class "label" ] [ text option_.label ]
                    , small [ class "help-text" ] [ text option_.description ]
                    ]
                ]
                (click option_.value)
    in
    div [ class "radio-field" ] (NEL.map viewRadioOption element.options |> NEL.toList)
