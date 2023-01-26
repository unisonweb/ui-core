module UI.Form.TextField exposing (..)

import Html exposing (Html, div, input, label, small, text, textarea)
import Html.Attributes exposing (class, placeholder, rows, type_, value)
import Maybe.Extra as MaybeE
import UI


type alias TextField msg =
    { onInput : String -> msg
    , label : String
    , placeholder : Maybe String
    , rows : Int
    , helpText : Maybe String
    , value : String
    }



-- CREATE


field : (String -> msg) -> String -> String -> TextField msg
field onInput label value =
    { onInput = onInput
    , label = label
    , placeholder = Nothing
    , rows = 1
    , helpText = Nothing
    , value = value
    }



-- MODIFY


withPlaceholder : String -> TextField msg -> TextField msg
withPlaceholder placeholder textField =
    { textField | placeholder = Just placeholder }


withHelpText : String -> TextField msg -> TextField msg
withHelpText helpText textField =
    { textField | helpText = Just helpText }


withNumLines : Int -> TextField msg -> TextField msg
withNumLines nl textField =
    if nl > 0 then
        { textField | rows = nl }

    else
        textField



-- MAP


map : (msgA -> msgB) -> TextField msgA -> TextField msgB
map f t =
    { onInput = t.onInput >> f
    , label = t.label
    , placeholder = t.placeholder
    , rows = t.rows
    , helpText = t.helpText
    , value = t.value
    }



-- VIEW


view : TextField msg -> Html msg
view textField =
    let
        placeholder_ =
            case textField.placeholder of
                Just p ->
                    [ placeholder p ]

                Nothing ->
                    []

        attrs =
            placeholder_ ++ [ type_ "text", class "text-field-input" ]

        input_ =
            if textField.rows > 1 then
                textarea (rows textField.rows :: attrs) [ text textField.value ]

            else
                input (value textField.value :: attrs) []
    in
    div [ class "form-field text-field" ]
        [ label [ class "label" ] [ text textField.label ]
        , input_
        , MaybeE.unwrap UI.nothing (\ht -> small [ class "help-text" ] [ text ht ]) textField.helpText
        ]
