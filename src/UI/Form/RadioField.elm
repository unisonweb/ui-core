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


type alias RadioOptions a =
    Nonempty (RadioOption a)


type alias RadioField a msg =
    { name : String
    , onChange : a -> msg
    , options : RadioOptions a
    , selected : a
    }



-- CREATE


{-| Create a RadioField.

Example:

    field
        "currency"
        UpdateCurrency
        (options
            (option "USD" "United States Dollars" USD)
            [ option "DKK" "Danish Kroner" DKK
            , option "CAD" "Canadian Dollars" CAD
            ]
        )
        USD

-}
field : String -> (a -> msg) -> RadioOptions a -> a -> RadioField a msg
field =
    RadioField


{-| Create an option for a RadioField

Example:

    option "USD" "United States Dollars" USD

-}
option : String -> String -> a -> RadioOption a
option label helpText value =
    RadioOption label (Just helpText) value


{-| Create an option for a RadioField without a help text (not usually recommended).

Example:

    option_ "USD" USD

-}
option_ : String -> a -> RadioOption a
option_ label value =
    RadioOption label Nothing value


{-| Options collection helper. Makes it easier to deal with than directly
constructing a Nonempty List.

Example:

    options
        (option "USD" "United States Dollars" USD)
        [ option "DKK" "Danish Kroner" DKK
        , option "CAD" "Canadian Dollars" CAD
        ]

-}
options : RadioOption a -> List (RadioOption a) -> RadioOptions a
options option__ options_ =
    NEL.singleton option__
        |> NEL.replaceTail options_


{-| Options collection helper to create exactly 2 options.

Example:

    options2
        (option "USD" "United States Dollars" USD)
        (option "DKK" "Danish Kroner" DKK)

-}
options2 : RadioOption a -> RadioOption a -> RadioOptions a
options2 option1 option2 =
    options option1 [ option2 ]


{-| Options collection helper to create exactly 3 options.

Example:

    options3
        (option "USD" "United States Dollars" USD)
        (option "DKK" "Danish Kroner" DKK)
        (option "CAD" "Canadian Dollars" CAD)

-}
options3 : RadioOption a -> RadioOption a -> RadioOption a -> RadioOptions a
options3 option1 option2 option3 =
    options option1 [ option2, option3 ]


{-| Options collection helper to create exactly 4 options.

Example:

    options4
        (option "USD" "United States Dollars" USD)
        (option "DKK" "Danish Kroner" DKK)
        (option "CAD" "Canadian Dollars" CAD)
        (option "AUD" "Australian Dollars" AUD)

-}
options4 :
    RadioOption a
    -> RadioOption a
    -> RadioOption a
    -> RadioOption a
    -> RadioOptions a
options4 option1 option2 option3 option4 =
    options option1 [ option2, option3, option4 ]


{-| Options collection helper to create exactly 5 options.

Example:

    options5
        (option "USD" "United States Dollars" USD)
        (option "DKK" "Danish Kroner" DKK)
        (option "CAD" "Canadian Dollars" CAD)
        (option "AUD" "Australian Dollars" AUD)
        (option "SEK" "Swedish Kroner" SEK)

Need more than 5? Look at the `options` function.

-}
options5 :
    RadioOption a
    -> RadioOption a
    -> RadioOption a
    -> RadioOption a
    -> RadioOption a
    -> RadioOptions a
options5 option1 option2 option3 option4 option5 =
    options option1 [ option2, option3, option4, option5 ]



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
