module UI.Form.CheckboxField exposing (..)

import Html exposing (Html, div, label, small, text)
import Html.Attributes exposing (class)
import UI.Click as Click
import UI.Form.Checkbox as Checkbox


type alias CheckboxField msg =
    { label : String
    , helpText : Maybe String
    , onChange : msg
    , checked : Bool
    }



-- CREATE


field : String -> msg -> Bool -> CheckboxField msg
field label onChange checked =
    CheckboxField label Nothing onChange checked



-- MODIFY


withHelpText : String -> CheckboxField msg -> CheckboxField msg
withHelpText helpText field_ =
    { field_ | helpText = Just helpText }



-- VIEW


view : CheckboxField msg -> Html msg
view checkboxField =
    let
        labelAndHelpText =
            case checkboxField.helpText of
                Just ht ->
                    div
                        [ class "label-and-help-text" ]
                        [ label [ class "label" ] [ text checkboxField.label ]
                        , small [ class "help-text" ] [ text ht ]
                        ]

                Nothing ->
                    label [ class "label" ] [ text checkboxField.label ]
    in
    Click.view [ class "form-field checkbox-field" ]
        [ Checkbox.checkbox_ Nothing checkboxField.checked |> Checkbox.view
        , labelAndHelpText
        ]
        (Click.onClick checkboxField.onChange)
