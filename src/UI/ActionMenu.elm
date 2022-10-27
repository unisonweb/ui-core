module UI.ActionMenu exposing
    ( ActionItem
    , ActionItems
    , ActionMenu
    , close
    , fromButton
    , fromCustom
    , items
    , open
    , shouldBeOpen
    , view
    , withActionItem
    , withButtonIcon
    )

import Html exposing (Html, div, text)
import Html.Attributes exposing (class, classList)
import Lib.OnClickOutside exposing (onClickOutside)
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


type ActionMenuTrigger msg
    = ButtonTrigger { icon : Maybe (Icon msg), label : String }
    | CustomTrigger (Html msg)


type alias ActionMenu msg =
    { toggleMsg : msg
    , state : OpenState
    , trigger : ActionMenuTrigger msg
    , actionItems : ActionItems msg
    }



-- CREATE


fromButton : msg -> String -> ActionItems msg -> ActionMenu msg
fromButton toggleMsg buttonLabel actionItems =
    { toggleMsg = toggleMsg
    , state = Closed
    , trigger = ButtonTrigger { icon = Nothing, label = buttonLabel }
    , actionItems = actionItems
    }


fromCustom : msg -> Html msg -> ActionItems msg -> ActionMenu msg
fromCustom toggleMsg trigger actionItems =
    { toggleMsg = toggleMsg
    , state = Closed
    , trigger = CustomTrigger trigger
    , actionItems = actionItems
    }


items : ActionItem msg -> List (ActionItem msg) -> ActionItems msg
items actionItem actionItems =
    ActionItems (Nonempty actionItem actionItems)



-- MODIFY


withButtonIcon : Icon msg -> ActionMenu msg -> ActionMenu msg
withButtonIcon icon actionMenu_ =
    case actionMenu_.trigger of
        ButtonTrigger b ->
            let
                bt =
                    ButtonTrigger { b | icon = Just icon }
            in
            { actionMenu_ | trigger = bt }

        _ ->
            actionMenu_


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
view { toggleMsg, state, trigger, actionItems } =
    let
        ( menu, isOpen ) =
            case state of
                Closed ->
                    ( UI.nothing, False )

                Open ->
                    ( viewItems actionItems, True )

        trigger_ =
            case trigger of
                ButtonTrigger { label, icon } ->
                    let
                        b_ =
                            viewButton toggleMsg label icon state
                    in
                    if isOpen then
                        b_ |> Button.active |> Button.view

                    else
                        Button.view b_

                CustomTrigger html ->
                    html

        actionMenu_ =
            div [ classList [ ( "action-menu", True ), ( "action-menu_is-open", isOpen ) ] ]
                [ trigger_, menu ]
    in
    if isOpen then
        onClickOutside toggleMsg actionMenu_

    else
        actionMenu_
