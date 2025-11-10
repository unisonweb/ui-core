module UI.ButtonGroup exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import UI.Button as Button exposing (Button)
import UI.CopyOnClick as CopyOnClick


type Direction
    = Horizontal
    | Vertical


type alias ButtonGroup msg =
    { buttons : List (Button msg)
    , direction : Direction
    , withCopyButton : Maybe String
    }


empty : ButtonGroup msg
empty =
    { buttons = [], direction = Horizontal, withCopyButton = Nothing }


buttonGroup : List (Button msg) -> ButtonGroup msg
buttonGroup buttons =
    { buttons = buttons, direction = Horizontal, withCopyButton = Nothing }



-- MODIFY


horizontal : ButtonGroup msg -> ButtonGroup msg
horizontal group =
    { group | direction = Horizontal }


vertical : ButtonGroup msg -> ButtonGroup msg
vertical group =
    { group | direction = Vertical }


add : Button msg -> ButtonGroup msg -> ButtonGroup msg
add button group =
    add_ [ button ] group


add_ : List (Button msg) -> ButtonGroup msg -> ButtonGroup msg
add_ buttons group =
    { group | buttons = group.buttons ++ buttons }


withCopyButton : String -> ButtonGroup msg -> ButtonGroup msg
withCopyButton textToCopy group =
    { group | withCopyButton = Just textToCopy }



-- VIEW


view : ButtonGroup msg -> Html msg
view group =
    let
        directionClass =
            case group.direction of
                Horizontal ->
                    "button-group_horizontal"

                Vertical ->
                    "button-group_vertical"
    in
    div [ class ("button-group " ++ directionClass) ]
        (List.map Button.view group.buttons)
