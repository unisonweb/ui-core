module UI.PopoverMenu exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import List.Nonempty as Nonempty exposing (Nonempty)
import UI
import UI.Button as Button exposing (Button)
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


viewButton : msg -> String -> Maybe (Icon msg) -> PopoverState -> Button msg
viewButton toggleMsg label icon state =
    let
        chevron =
            case state of
                Open ->
                    Icon.chevronUp

                Closed ->
                    Icon.chevronDown
    in
    Button.button toggleMsg label
        |> Button.withIconAfterLabel chevron
        |> Button.small
        |> buttonWithIcon icon


buttonWithIcon : Maybe (Icon msg) -> Button msg -> Button msg
buttonWithIcon icon button =
    case icon of
        Just i ->
            Button.withIconBeforeLabel i button

        Nothing ->
            button


view : PopoverMenu msg -> Html msg
view { toggleMsg, state, buttonIcon, buttonLabel } =
    let
        button =
            viewButton toggleMsg buttonLabel buttonIcon state

        menu =
            case state of
                Closed ->
                    UI.nothing

                Open ->
                    div [] []
    in
    div [ class "popoverMenu" ]
        [ button |> Button.view
        , menu
        ]
