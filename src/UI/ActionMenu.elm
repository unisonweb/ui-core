module UI.ActionMenu exposing
    ( ActionItem
    , ActionItems
    , ActionMenu
    , actionMenu
    , close
    , items
    , open
    , shouldBeOpen
    , view
    , withActionItem
    , withButtonIcon
    )

import Html exposing (Html, div, text)
import Html.Attributes exposing (class, classList)
import List.Nonempty as Nonempty exposing (Nonempty(..))
import UI
import UI.Button as Button exposing (Button)
import UI.Click as Click exposing (Click)
import UI.Icon as Icon exposing (Icon)


type OpenState
    = Open
    | Closed


type alias ActionItem msg =
    { icon : Icon msg
    , label : String
    , click : Click msg
    }


type ActionItems msg
    = ActionItems (Nonempty (ActionItem msg))


type alias ActionMenu msg =
    { toggleMsg : msg
    , state : OpenState
    , buttonIcon : Maybe (Icon msg)
    , buttonLabel : String
    , actionItems : ActionItems msg
    }



-- CREATE


actionMenu : msg -> String -> ActionItems msg -> ActionMenu msg
actionMenu toggleMsg buttonLabel actionItems =
    { toggleMsg = toggleMsg
    , state = Closed
    , buttonIcon = Nothing
    , buttonLabel = buttonLabel
    , actionItems = actionItems
    }


items : ActionItem msg -> List (ActionItem msg) -> ActionItems msg
items actionItem actionItems =
    ActionItems (Nonempty actionItem actionItems)



-- MODIFY


withButtonIcon : Icon msg -> ActionMenu msg -> ActionMenu msg
withButtonIcon icon actionMenu_ =
    { actionMenu_ | buttonIcon = Just icon }


withActionItem : ActionItem msg -> ActionMenu msg -> ActionMenu msg
withActionItem item_ actionMenu_ =
    let
        newActionItems =
            case actionMenu_.actionItems of
                ActionItems l ->
                    ActionItems (Nonempty.append (Nonempty.fromElement item_) l)
    in
    { actionMenu_ | actionItems = newActionItems }


shouldBeOpen : Bool -> ActionMenu msg -> ActionMenu msg
shouldBeOpen shouldBeOpen_ menu =
    if shouldBeOpen_ then
        open menu

    else
        close menu


open : ActionMenu msg -> ActionMenu msg
open menu =
    { menu | state = Open }


close : ActionMenu msg -> ActionMenu msg
close menu =
    { menu | state = Closed }



-- VIEW


viewButton : msg -> String -> Maybe (Icon msg) -> OpenState -> Button msg
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


viewItems : ActionItems msg -> Html msg
viewItems (ActionItems items_) =
    let
        viewItem i =
            Click.view [ class "action-menu_action-item" ] [ Icon.view i.icon, text i.label ] i.click
    in
    div [ class "action-menu_action-items" ] (items_ |> Nonempty.toList |> List.map viewItem)


view : ActionMenu msg -> Html msg
view { toggleMsg, state, buttonIcon, buttonLabel, actionItems } =
    let
        button =
            viewButton toggleMsg buttonLabel buttonIcon state

        ( menu, isOpen ) =
            case state of
                Closed ->
                    ( UI.nothing, False )

                Open ->
                    ( viewItems actionItems, True )
    in
    div [ classList [ ( "action-menu", True ), ( "action-menu_is-open", isOpen ) ] ]
        [ button |> Button.view
        , menu
        ]
