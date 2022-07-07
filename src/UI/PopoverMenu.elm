module UI.PopoverMenu exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import List.Nonempty as Nonempty exposing (Nonempty)
import UI.Button as Button
import UI.Click as Click exposing (Click)
import UI.Icon as Icon exposing (Icon)


type PopoverState
    = Open
    | Closed


type alias PopoverMenuItem msg =
    { icon : Icon msg
    , label : String
    , click : Click msg
    }


type alias PopoverMenu msg =
    { toggleMsg : msg
    , state : PopoverState
    , buttonIcon : Maybe (Icon msg)
    , buttonLabel : String
    , menu : Nonempty (PopoverMenuItem msg)
    }



-- CREATE
-- MODIFY
-- VIEW


view : PopoverMenu msg -> Html msg
view { toggleMsg, state, buttonIcon, buttonLabel } =
    let
        buttonBase =
            Button.button toggleMsg buttonLabel
                |> (\b ->
                        case buttonIcon of
                            Just i ->
                                Button.withIconBeforeLabel i b

                            Nothing ->
                                b
                   )
                |> Button.small

        button =
            case state of
                Open ->
                    buttonBase |> Button.withIconAfterLabel Icon.chevronUp

                Closed ->
                    buttonBase |> Button.withIconAfterLabel Icon.chevronDown
    in
    div [ class "popoverMenu" ] []
