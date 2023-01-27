module UI.Form.TextField exposing (..)

import Html exposing (Html, div, input, label, small, text, textarea)
import Html.Attributes
    exposing
        ( autofocus
        , class
        , maxlength
        , minlength
        , placeholder
        , rows
        , type_
        , value
        )
import Html.Events exposing (onInput)
import Maybe.Extra as MaybeE
import UI


type alias TextField msg =
    { onInput : String -> msg
    , label : String
    , placeholder : Maybe String
    , rows : Int
    , helpText : Maybe String
    , maxlength : Maybe Int
    , minlength : Maybe Int
    , autofocus : Bool
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
    , maxlength = Nothing
    , minlength = Nothing
    , autofocus = False
    , value = value
    }



-- MODIFY


withPlaceholder : String -> TextField msg -> TextField msg
withPlaceholder placeholder textField =
    { textField | placeholder = Just placeholder }


withHelpText : String -> TextField msg -> TextField msg
withHelpText helpText textField =
    { textField | helpText = Just helpText }


withMaxLength : Int -> TextField msg -> TextField msg
withMaxLength maxlength_ textField =
    { textField | maxlength = Just maxlength_ }


withMinLength : Int -> TextField msg -> TextField msg
withMinLength minlength_ textField =
    { textField | minlength = Just minlength_ }


withAutofocus : TextField msg -> TextField msg
withAutofocus textField =
    { textField | autofocus = True }


withRows : Int -> TextField msg -> TextField msg
withRows nl textField =
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
    , maxlength = t.maxlength
    , minlength = t.minlength
    , autofocus = t.autofocus
    , value = t.value
    }



-- VIEW


view : TextField msg -> Html msg
view textField =
    let
        attrs =
            [ Maybe.map placeholder textField.placeholder
            , Maybe.map maxlength textField.maxlength
            , Maybe.map minlength textField.minlength
            , Just (class "text-field-input")
            , Just (onInput textField.onInput)
            , Just (autofocus textField.autofocus)
            ]
                |> MaybeE.values

        input_ =
            if textField.rows > 1 then
                textarea (rows textField.rows :: attrs) [ text textField.value ]

            else
                input (value textField.value :: type_ "text" :: attrs) []
    in
    div [ class "form-field text-field" ]
        [ label [ class "label" ] [ text textField.label ]
        , input_
        , MaybeE.unwrap UI.nothing (\ht -> small [ class "help-text" ] [ text ht ]) textField.helpText
        ]
