module UI.Form.CheckboxField exposing (..)

import Html exposing (Html, div, label, small, text)
import Html.Attributes exposing (class)
import Maybe.Extra as MaybeE
import UI
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
    Click.view [ class "form-field checkbox-field" ]
        [ Checkbox.checkbox_ Nothing checkboxField.checked |> Checkbox.view
        , div
            [ class "label-and-help-text" ]
            [ label [ class "label" ] [ text checkboxField.label ]
            , MaybeE.unwrap UI.nothing (\ht -> small [ class "help-text" ] [ text ht ]) checkboxField.helpText
            ]
        ]
        (Click.onClick checkboxField.onChange)
