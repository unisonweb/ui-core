module UI.Form.SelectField exposing (..)

import Html exposing (Html, div, label, select, small, text)
import Html.Attributes as Attr exposing (class, classList, disabled, selected, value)
import Html.Events exposing (on, targetValue)
import Json.Decode as Json
import List.Extra as ListE
import List.Nonempty as NEL exposing (Nonempty)
import Maybe.Extra as MaybeE
import UI
import UI.Icon as Icon


type alias SelectOption a =
    { label : String
    , value : a
    }


type alias SelectOptions a =
    Nonempty (SelectOption a)


type Validity
    = None
    | MarkedAsValid
    | MarkedAsInvalid


type alias SelectField a msg =
    { onChange : a -> msg
    , options : SelectOptions a
    , selected : a
    , label : Maybe String
    , helpText : Maybe String
    , validity : Validity
    , disabled : Bool
    , id : Maybe String
    }



-- CREATE


{-| Create a SelectField.

Example:

    field
        OnCurrencyChange
        (options
            (option "United States Dollars" USD)
            [ option "Danish Kroner" DKK
            , option "Canadian Dollars" CAD
            ]
        )
        USD

-}
field : (a -> msg) -> SelectOptions a -> a -> SelectField a msg
field onChange options_ selected_ =
    { onChange = onChange
    , options = options_
    , selected = selected_
    , label = Nothing
    , helpText = Nothing
    , validity = None
    , disabled = False
    , id = Nothing
    }


{-| Create an option for a SelectField

Example:

    option "United States Dollars" USD

-}
option : String -> a -> SelectOption a
option label_ value_ =
    SelectOption label_ value_


{-| Options collection helper. Makes it easier to deal with than directly
constructing a Nonempty List.

Example:

    options
        (option "United States Dollars" USD)
        [ option "Danish Kroner" DKK
        , option "Canadian Dollars" CAD
        ]

-}
options : SelectOption a -> List (SelectOption a) -> SelectOptions a
options option__ options_ =
    NEL.singleton option__
        |> NEL.replaceTail options_


options2 : SelectOption a -> SelectOption a -> SelectOptions a
options2 option1 option2_ =
    options option1 [ option2_ ]


options3 : SelectOption a -> SelectOption a -> SelectOption a -> SelectOptions a
options3 option1 option2_ option3_ =
    options option1 [ option2_, option3_ ]


options4 :
    SelectOption a
    -> SelectOption a
    -> SelectOption a
    -> SelectOption a
    -> SelectOptions a
options4 option1 option2_ option3_ option4_ =
    options option1 [ option2_, option3_, option4_ ]


options5 :
    SelectOption a
    -> SelectOption a
    -> SelectOption a
    -> SelectOption a
    -> SelectOption a
    -> SelectOptions a
options5 option1 option2_ option3_ option4_ option5_ =
    options option1 [ option2_, option3_, option4_, option5_ ]



-- MODIFY


withLabel : String -> SelectField a msg -> SelectField a msg
withLabel label_ selectField =
    { selectField | label = Just label_ }


withHelpText : String -> SelectField a msg -> SelectField a msg
withHelpText helpText selectField =
    { selectField | helpText = Just helpText }


withId : String -> SelectField a msg -> SelectField a msg
withId id_ selectField =
    { selectField | id = Just id_ }


withDisabled : SelectField a msg -> SelectField a msg
withDisabled selectField =
    { selectField | disabled = True }


markAsValid : SelectField a msg -> SelectField a msg
markAsValid selectField =
    { selectField | validity = MarkedAsValid }


markAsInvalid : SelectField a msg -> SelectField a msg
markAsInvalid selectField =
    { selectField | validity = MarkedAsInvalid }


when : Bool -> (SelectField a msg -> SelectField a msg) -> SelectField a msg -> SelectField a msg
when condition f selectField =
    whenElse condition f identity selectField


whenMaybe : Maybe m -> (m -> SelectField a msg -> SelectField a msg) -> SelectField a msg -> SelectField a msg
whenMaybe maybe f selectField =
    case maybe of
        Just a ->
            f a selectField

        Nothing ->
            selectField


whenElse :
    Bool
    -> (SelectField a msg -> SelectField a msg)
    -> (SelectField a msg -> SelectField a msg)
    -> SelectField a msg
    -> SelectField a msg
whenElse condition f g selectField =
    if condition then
        f selectField

    else
        g selectField


whenNot : Bool -> (SelectField a msg -> SelectField a msg) -> SelectField a msg -> SelectField a msg
whenNot condition f selectField =
    when (not condition) f selectField



-- MAP


map : (msgA -> msgB) -> SelectField a msgA -> SelectField a msgB
map f selectField =
    { onChange = selectField.onChange >> f
    , options = selectField.options
    , selected = selectField.selected
    , label = selectField.label
    , helpText = selectField.helpText
    , validity = selectField.validity
    , disabled = selectField.disabled
    , id = selectField.id
    }



-- VIEW


{-| The DOM only gives us back the string value of the chosen <option>, so
each option is rendered with its list index as its value and the index is
used to look the originally provided option value back up on change.
-}
view : SelectField a msg -> Html msg
view selectField =
    let
        indexedOptions =
            selectField.options
                |> NEL.toList
                |> List.indexedMap Tuple.pair

        viewOption ( index, opt ) =
            Html.option
                [ value (String.fromInt index)
                , selected (opt.value == selectField.selected)
                ]
                [ text opt.label ]

        onChange_ =
            targetValue
                |> Json.andThen
                    (\indexAsString ->
                        indexAsString
                            |> String.toInt
                            |> Maybe.andThen (\i -> ListE.getAt i indexedOptions)
                            |> Maybe.map (\( _, opt ) -> Json.succeed (selectField.onChange opt.value))
                            |> Maybe.withDefault (Json.fail "Invalid SelectField option")
                    )
                |> on "change"

        select_ =
            select
                ([ Just onChange_
                 , Just (disabled selectField.disabled)
                 , Maybe.map Attr.id selectField.id
                 ]
                    |> MaybeE.values
                )
                (List.map viewOption indexedOptions)

        label_ =
            selectField.label
                |> Maybe.map (\l -> label [ class "label" ] [ text l ])
                |> Maybe.withDefault UI.nothing

        helpText_ =
            MaybeE.unwrap UI.nothing (\ht -> small [ class "help-text" ] [ text ht ]) selectField.helpText

        isInvalid =
            selectField.validity == MarkedAsInvalid
    in
    div
        [ class "form-field select-field"
        , classList [ ( "select-field_is-invalid", isInvalid ) ]
        ]
        [ label_
        , div [ class "select-field_input" ]
            [ select_, div [ class "select-field_icon" ] [ Icon.view Icon.chevronDown ] ]
        , helpText_
        ]
