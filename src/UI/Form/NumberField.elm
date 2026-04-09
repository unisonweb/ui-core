module UI.Form.NumberField exposing (..)

import Html exposing (Html, div, input, label, small, text)
import Html.Attributes
    exposing
        ( autocomplete
        , autofocus
        , class
        , classList
        , id
        , maxlength
        , minlength
        , placeholder
        , type_
        , value
        )
import Html.Events exposing (keyCode, on, onInput)
import Json.Decode as Json
import Maybe.Extra as MaybeE
import UI
import UI.Click as Click
import UI.Icon as Icon exposing (Icon)
import UI.StatusIndicator as StatusIndicator exposing (StatusIndicator)


type NumberFieldIcon msg
    = NoIcon
    | NumberFieldIcon (Icon msg)
    | NumberFieldStatusIndicator StatusIndicator


type Validity
    = None
    | ValidityCheck (Int -> Bool)
    | MarkedAsValid
    | MarkedAsInvalid


type alias NumberField msg =
    { onInput : Maybe Int -> msg
    , onKeydown : Maybe (Int -> msg)
    , icon : NumberFieldIcon msg
    , label : Maybe String
    , placeholder : Maybe String
    , helpText : Maybe String
    , maxlength : Maybe Int
    , minlength : Maybe Int
    , autofocus : Bool
    , value : Maybe Int
    , validity : Validity
    , clearMsg : Maybe msg
    , id : Maybe String
    }



-- CREATE


field : (Maybe Int -> msg) -> String -> NumberField msg
field onInput label =
    field_ onInput (Just label) Nothing Nothing


fieldWithoutLabel : (Maybe Int -> msg) -> String -> NumberField msg
fieldWithoutLabel onInput placeholder =
    field_ onInput Nothing (Just placeholder) Nothing


field_ : (Maybe Int -> msg) -> Maybe String -> Maybe String -> Maybe Int -> NumberField msg
field_ onInput label placeholder value =
    { onInput = onInput
    , onKeydown = Nothing
    , icon = NoIcon
    , label = label
    , placeholder = placeholder
    , helpText = Nothing
    , maxlength = Nothing
    , minlength = Nothing
    , autofocus = False
    , value = value
    , validity = None
    , clearMsg = Nothing
    , id = Nothing
    }



-- MODIFY


withPlaceholder : String -> NumberField msg -> NumberField msg
withPlaceholder placeholder numberField =
    { numberField | placeholder = Just placeholder }


withKeydown : (Int -> msg) -> NumberField msg -> NumberField msg
withKeydown keydownMsg numberField =
    { numberField | onKeydown = Just keydownMsg }


withHelpText : String -> NumberField msg -> NumberField msg
withHelpText helpText numberField =
    { numberField | helpText = Just helpText }


withMaxlength : Int -> NumberField msg -> NumberField msg
withMaxlength maxlength_ numberField =
    { numberField | maxlength = Just maxlength_ }


withMinlength : Int -> NumberField msg -> NumberField msg
withMinlength minlength_ numberField =
    { numberField | minlength = Just minlength_ }


withAutofocus : NumberField msg -> NumberField msg
withAutofocus numberField =
    { numberField | autofocus = True }


withIcon : Icon msg -> NumberField msg -> NumberField msg
withIcon icon tf =
    withNumberFieldIcon (NumberFieldIcon icon) tf


withValidityCheck : (Int -> Bool) -> NumberField msg -> NumberField msg
withValidityCheck isValid tf =
    { tf | validity = ValidityCheck isValid }


markAsValid : NumberField msg -> NumberField msg
markAsValid tf =
    { tf | validity = MarkedAsValid }


markAsInvalid : NumberField msg -> NumberField msg
markAsInvalid tf =
    { tf | validity = MarkedAsInvalid }


withStatusIndicator : StatusIndicator -> NumberField msg -> NumberField msg
withStatusIndicator indicator tf =
    withNumberFieldIcon (NumberFieldStatusIndicator indicator) tf


withIconOrIndicator : Icon msg -> StatusIndicator -> Bool -> NumberField msg -> NumberField msg
withIconOrIndicator icon indicator showIndicator tf =
    let
        icon_ =
            if showIndicator then
                NumberFieldStatusIndicator indicator

            else
                NumberFieldIcon icon
    in
    withNumberFieldIcon icon_ tf


withIconOrWorking : Icon msg -> Bool -> NumberField msg -> NumberField msg
withIconOrWorking icon showWorking tf =
    let
        icon_ =
            if showWorking then
                NumberFieldStatusIndicator StatusIndicator.working

            else
                NumberFieldIcon icon
    in
    withNumberFieldIcon icon_ tf


withNumberFieldIcon : NumberFieldIcon msg -> NumberField msg -> NumberField msg
withNumberFieldIcon tfIcon tf =
    { tf | icon = tfIcon }


withClear : msg -> NumberField msg -> NumberField msg
withClear clearMsg tf =
    { tf | clearMsg = Just clearMsg }


withId : String -> NumberField msg -> NumberField msg
withId id_ tf =
    { tf | id = Just id_ }


when : Bool -> (NumberField msg -> NumberField msg) -> NumberField msg -> NumberField msg
when condition f tf =
    whenElse condition f identity tf


whenMaybe : Maybe a -> (a -> NumberField msg -> NumberField msg) -> NumberField msg -> NumberField msg
whenMaybe maybe f tf =
    case maybe of
        Just a ->
            f a tf

        Nothing ->
            tf


whenElse :
    Bool
    -> (NumberField msg -> NumberField msg)
    -> (NumberField msg -> NumberField msg)
    -> NumberField msg
    -> NumberField msg
whenElse condition f g tf =
    if condition then
        f tf

    else
        g tf


whenNot : Bool -> (NumberField msg -> NumberField msg) -> NumberField msg -> NumberField msg
whenNot condition f tf =
    when (not condition) f tf



-- MAP


mapIcon : (msgA -> msgB) -> NumberFieldIcon msgA -> NumberFieldIcon msgB
mapIcon f i =
    case i of
        NoIcon ->
            NoIcon

        NumberFieldIcon icon ->
            NumberFieldIcon (Icon.map f icon)

        NumberFieldStatusIndicator statusIndicator ->
            NumberFieldStatusIndicator statusIndicator


map : (msgA -> msgB) -> NumberField msgA -> NumberField msgB
map f t =
    { onInput = t.onInput >> f
    , onKeydown = Maybe.map (\toMsg -> toMsg >> f) t.onKeydown
    , icon = mapIcon f t.icon
    , label = t.label
    , placeholder = t.placeholder
    , helpText = t.helpText
    , maxlength = t.maxlength
    , minlength = t.minlength
    , autofocus = t.autofocus
    , value = t.value
    , validity = t.validity
    , clearMsg = Maybe.map f t.clearMsg
    , id = t.id
    }



-- VIEW


view : NumberField msg -> Html msg
view numberField =
    let
        attrs =
            [ Maybe.map placeholder numberField.placeholder
            , Maybe.map maxlength numberField.maxlength
            , Maybe.map minlength numberField.minlength
            , Maybe.map id numberField.id
            , Maybe.map (\toMsg -> on "keydown" (Json.map toMsg keyCode)) numberField.onKeydown
            , Just (class "number-field-input")
            , Just (onInput (String.toInt >> numberField.onInput))
            , Just (autofocus numberField.autofocus)
            , Just (autocomplete False)
            ]
                |> MaybeE.values

        input__ =
            input
                ((numberField.value
                    |> Maybe.map String.fromInt
                    |> Maybe.withDefault ""
                    |> value
                 )
                    :: type_ "number"
                    :: attrs
                )
                []

        clear =
            case numberField.clearMsg of
                Just c ->
                    case numberField.value of
                        Just _ ->
                            c
                                |> Click.onClick
                                |> Click.view [ class "number-field_clear" ] [ Icon.view Icon.x ]

                        Nothing ->
                            UI.nothing

                Nothing ->
                    UI.nothing

        ( iconEl, hasIcon ) =
            case numberField.icon of
                NoIcon ->
                    ( UI.nothing, False )

                NumberFieldIcon i ->
                    ( div [ class "number-field_icon" ] [ Icon.view i ], True )

                NumberFieldStatusIndicator i ->
                    ( StatusIndicator.view i, True )

        input_ =
            div
                [ class "number-field_input"
                , classList
                    [ ( "number-field_with-icon", hasIcon )
                    ]
                ]
                [ iconEl, input__, clear ]

        label_ =
            numberField.label
                |> Maybe.map (\l -> label [ class "label" ] [ text l ])
                |> Maybe.withDefault UI.nothing

        helpText_ =
            MaybeE.unwrap UI.nothing (\ht -> small [ class "help-text" ] [ text ht ]) numberField.helpText

        isInvalid =
            case numberField.validity of
                None ->
                    False

                MarkedAsValid ->
                    False

                MarkedAsInvalid ->
                    True

                ValidityCheck check ->
                    case numberField.value of
                        Just n ->
                            not (check n)

                        Nothing ->
                            False
    in
    div
        [ class "form-field number-field"
        , classList [ ( "number-field_is-invalid", isInvalid ) ]
        ]
        [ label_, input_, helpText_ ]
