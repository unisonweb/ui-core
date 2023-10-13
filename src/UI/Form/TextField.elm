module UI.Form.TextField exposing (..)

import Html exposing (Html, div, input, label, small, text, textarea)
import Html.Attributes
    exposing
        ( autofocus
        , class
        , classList
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
import UI.Click as Click
import UI.Icon as Icon exposing (Icon)
import UI.StatusIndicator as StatusIndicator exposing (StatusIndicator)


type TextFieldIcon msg
    = NoIcon
    | TextFieldIcon (Icon msg)
    | TextFieldStatusIndicator StatusIndicator


type alias TextField msg =
    { onInput : String -> msg
    , icon : TextFieldIcon msg
    , label : Maybe String
    , placeholder : Maybe String
    , rows : Int
    , helpText : Maybe String
    , maxlength : Maybe Int
    , minlength : Maybe Int
    , autofocus : Bool
    , value : String
    , isValid : Maybe (String -> Bool)
    , clearMsg : Maybe msg
    }



-- CREATE


field : (String -> msg) -> String -> String -> TextField msg
field onInput label value =
    field_ onInput (Just label) Nothing value


fieldWithoutLabel : (String -> msg) -> String -> String -> TextField msg
fieldWithoutLabel onInput placeholder value =
    field_ onInput Nothing (Just placeholder) value


field_ : (String -> msg) -> Maybe String -> Maybe String -> String -> TextField msg
field_ onInput label placeholder value =
    { onInput = onInput
    , icon = NoIcon
    , label = label
    , placeholder = placeholder
    , rows = 1
    , helpText = Nothing
    , maxlength = Nothing
    , minlength = Nothing
    , autofocus = False
    , value = value
    , isValid = Nothing
    , clearMsg = Nothing
    }



-- MODIFY


withPlaceholder : String -> TextField msg -> TextField msg
withPlaceholder placeholder textField =
    { textField | placeholder = Just placeholder }


withHelpText : String -> TextField msg -> TextField msg
withHelpText helpText textField =
    { textField | helpText = Just helpText }


withMaxlength : Int -> TextField msg -> TextField msg
withMaxlength maxlength_ textField =
    { textField | maxlength = Just maxlength_ }


withMinlength : Int -> TextField msg -> TextField msg
withMinlength minlength_ textField =
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


withIcon : Icon msg -> TextField msg -> TextField msg
withIcon icon tf =
    withTextFieldIcon (TextFieldIcon icon) tf


withIsValid : (String -> Bool) -> TextField msg -> TextField msg
withIsValid isValid tf =
    { tf | isValid = Just isValid }


withStatusIndicator : StatusIndicator -> TextField msg -> TextField msg
withStatusIndicator indicator tf =
    withTextFieldIcon (TextFieldStatusIndicator indicator) tf


withIconOrIndicator : Icon msg -> StatusIndicator -> Bool -> TextField msg -> TextField msg
withIconOrIndicator icon indicator showIndicator tf =
    let
        icon_ =
            if showIndicator then
                TextFieldStatusIndicator indicator

            else
                TextFieldIcon icon
    in
    withTextFieldIcon icon_ tf


withIconOrWorking : Icon msg -> Bool -> TextField msg -> TextField msg
withIconOrWorking icon showWorking tf =
    let
        icon_ =
            if showWorking then
                TextFieldStatusIndicator StatusIndicator.working

            else
                TextFieldIcon icon
    in
    withTextFieldIcon icon_ tf


withTextFieldIcon : TextFieldIcon msg -> TextField msg -> TextField msg
withTextFieldIcon tfIcon tf =
    { tf | icon = tfIcon }


withClear : msg -> TextField msg -> TextField msg
withClear clearMsg tf =
    { tf | clearMsg = Just clearMsg }



-- MAP


mapIcon : (msgA -> msgB) -> TextFieldIcon msgA -> TextFieldIcon msgB
mapIcon f i =
    case i of
        NoIcon ->
            NoIcon

        TextFieldIcon icon ->
            TextFieldIcon (Icon.map f icon)

        TextFieldStatusIndicator statusIndicator ->
            TextFieldStatusIndicator statusIndicator


map : (msgA -> msgB) -> TextField msgA -> TextField msgB
map f t =
    { onInput = t.onInput >> f
    , icon = mapIcon f t.icon
    , label = t.label
    , placeholder = t.placeholder
    , rows = t.rows
    , helpText = t.helpText
    , maxlength = t.maxlength
    , minlength = t.minlength
    , autofocus = t.autofocus
    , value = t.value
    , isValid = t.isValid
    , clearMsg = Maybe.map f t.clearMsg
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

        input__ =
            if textField.rows > 1 then
                textarea (rows textField.rows :: attrs) [ text textField.value ]

            else
                input (value textField.value :: type_ "text" :: attrs) []

        clear =
            case textField.clearMsg of
                Just c ->
                    if textField.value /= "" then
                        c
                            |> Click.onClick
                            |> Click.view [ class "text-field_clear" ] [ Icon.view Icon.x ]

                    else
                        UI.nothing

                Nothing ->
                    UI.nothing

        input_ =
            case textField.icon of
                NoIcon ->
                    div [ class "text-field_input " ] [ input__, clear ]

                TextFieldIcon i ->
                    div [ class "text-field_input text-field_with-icon" ] [ div [ class "text-field_icon" ] [ Icon.view i ], input__, clear ]

                TextFieldStatusIndicator i ->
                    div [ class "text-field_input text-field_with-icon" ] [ StatusIndicator.view i, input__, clear ]

        label_ =
            textField.label
                |> Maybe.map (\l -> label [ class "label" ] [ text l ])
                |> Maybe.withDefault UI.nothing

        helpText_ =
            MaybeE.unwrap UI.nothing (\ht -> small [ class "help-text" ] [ text ht ]) textField.helpText

        isInvalid =
            case ( String.isEmpty textField.value, textField.isValid ) of
                ( False, Just v ) ->
                    not (v textField.value)

                _ ->
                    False
    in
    div
        [ class "form-field text-field"
        , classList [ ( "text-field_is-invalid", isInvalid ) ]
        ]
        [ label_, input_, helpText_ ]
