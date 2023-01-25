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
    , selected : a
    , options : Nonempty (RadioOption a)
    , onChange : a -> msg
    }



-- CREATE


field : String -> a -> Nonempty (RadioOption a) -> (a -> msg) -> RadioField a msg
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
            Click.view []
                [ input
                    [ type_ "radio"
                    , name element.name
                    , checked (option_.value == element.selected)
                    ]
                    []
                , div
                    []
                    [ label [] [ text option_.label ]
                    , small [] [ text option_.description ]
                    ]
                ]
                (click option_.value)
    in
    div [ class "radio-field" ] (NEL.map viewRadioOption element.options |> NEL.toList)
