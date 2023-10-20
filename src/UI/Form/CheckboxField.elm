module UI.Form.CheckboxField exposing (..)

import Html exposing (Html, div, input, label, small, text)
import Html.Attributes exposing (checked, class, type_)
import Maybe.Extra as MaybeE
import UI
import UI.Click as Click


type alias CheckboxField msg =
    { label : String
    , helpText : Maybe String
    , onChange : msg
    , checked : Bool
    }



-- CREATE


field : String -> Maybe String -> msg -> Bool -> CheckboxField msg
field =
    CheckboxField



-- VIEW


view : CheckboxField msg -> Html msg
view checkboxField =
    Click.view [ class "form-field checkbox-field" ]
        [ div [ class "checkbox-field_checkbox" ]
            [ input
                [ type_ "checkbox"
                , checked checkboxField.checked
                ]
                []
            ]
        , div
            [ class "label-and-help-text" ]
            [ label [ class "label" ] [ text checkboxField.label ]
            , MaybeE.unwrap UI.nothing (\ht -> small [ class "help-text" ] [ text ht ]) checkboxField.helpText
            ]
        ]
        (Click.onClick checkboxField.onChange)
