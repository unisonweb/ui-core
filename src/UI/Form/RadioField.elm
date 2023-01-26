module UI.Form.RadioField exposing (..)

import Html exposing (Html, div, input, label, small, text)
import Html.Attributes exposing (checked, class, name, type_)
import List.Nonempty as NEL exposing (Nonempty)
import Maybe.Extra as MaybeE
import UI
import UI.Click as Click


type alias RadioOption a =
    { label : String
    , helpText : Maybe String
    , value : a
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


option : String -> String -> a -> RadioOption a
option label helpText value =
    RadioOption label (Just helpText) value


option_ : String -> a -> RadioOption a
option_ label value =
    RadioOption label Nothing value



-- VIEW


view : RadioField a msg -> Html msg
view radioField =
    let
        click value =
            Click.onClick (radioField.onChange value)

        viewRadioOption o =
            Click.view [ class "radio-field_option" ]
                [ div [ class "radio-field_radio" ]
                    [ input
                        [ type_ "radio"
                        , name radioField.name
                        , checked (o.value == radioField.selected)
                        ]
                        []
                    ]
                , div
                    [ class "label-and-help-text" ]
                    [ label [ class "label" ] [ text o.label ]
                    , MaybeE.unwrap UI.nothing (\ht -> small [ class "help-text" ] [ text ht ]) o.helpText
                    ]
                ]
                (click o.value)
    in
    div [ class "form-field radio-field" ] (NEL.map viewRadioOption radioField.options |> NEL.toList)
