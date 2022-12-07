module UI.ActionMenu exposing
    ( ActionItem
    , ActionItems
    , ActionMenu
    , close
    , dividerItem
    , fromButton
    , fromCustom
    , fromIconButton
    , items
    , loadingItem
    , open
    , optionItem
    , optionItemWithoutIcon
    , optionItem_
    , shouldBeOpen
    , titleItem
    , view
    , withActionItem
    , withButtonIcon
    )

import Html exposing (Html, div, text)
import Html.Attributes exposing (class, classList)
import Lib.OnClickOutside exposing (onClickOutside)
import List.Nonempty as Nonempty exposing (Nonempty(..))
import Maybe.Extra as MaybeE
import UI
import UI.Button as Button exposing (Button)
import UI.Click as Click exposing (Click)
import UI.Icon as Icon exposing (Icon)
import UI.Nudge exposing (Nudge)
import UI.PlaceholderShape as PlaceholderShape


type OpenState
    = Open
    | Closed


type alias ActionOption msg =
    { icon : Maybe (Icon msg)
    , label : String
    , click : Click msg
    , nudge : Maybe (Nudge msg)
    }


type ActionItem msg
    = Option (ActionOption msg)
    | Divider
    | Title String
    | Loading


type ActionItems msg
    = ActionItems (Nonempty (ActionItem msg))


type ActionMenuTrigger msg
    = ButtonTrigger { icon : Maybe (Icon msg), label : String }
    | IconButtonTrigger (Icon msg)
    | CustomTrigger { toHtml : Bool -> Html msg }


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


fromIconButton : msg -> Icon msg -> ActionItems msg -> ActionMenu msg
fromIconButton toggleMsg icon actionItems =
    { toggleMsg = toggleMsg
    , state = Closed
    , trigger = IconButtonTrigger icon
    , actionItems = actionItems
    }


fromCustom : msg -> (Bool -> Html msg) -> ActionItems msg -> ActionMenu msg
fromCustom toggleMsg toHtml actionItems =
    { toggleMsg = toggleMsg
    , state = Closed
    , trigger = CustomTrigger { toHtml = toHtml }
    , actionItems = actionItems
    }


items : ActionItem msg -> List (ActionItem msg) -> ActionItems msg
items actionItem actionItems =
    ActionItems (Nonempty actionItem actionItems)


optionItem : Icon msg -> String -> Click msg -> ActionItem msg
optionItem icon label click =
    optionItem_ (Just icon) label click


optionItemWithoutIcon : String -> Click msg -> ActionItem msg
optionItemWithoutIcon label click =
    optionItem_ Nothing label click


optionItem_ : Maybe (Icon msg) -> String -> Click msg -> ActionItem msg
optionItem_ icon label click =
    Option { icon = icon, label = label, click = click, nudge = Nothing }


loadingItem : ActionItem msg
loadingItem =
    Loading


dividerItem : ActionItem msg
dividerItem =
    Divider


titleItem : String -> ActionItem msg
titleItem title =
    Title title



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

        IconButtonTrigger _ ->
            let
                ibt =
                    IconButtonTrigger icon
            in
            { actionMenu_ | trigger = ibt }

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


chevron : OpenState -> Icon msg
chevron state =
    case state of
        Open ->
            Icon.chevronUp

        Closed ->
            Icon.chevronDown


viewButton : msg -> String -> Maybe (Icon msg) -> OpenState -> Button msg
viewButton toggleMsg label icon state =
    Button.button toggleMsg label
        |> Button.withIconAfterLabel (chevron state)
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
            case i of
                Option o ->
                    Click.view
                        [ class "action-menu_action-item" ]
                        [ MaybeE.unwrap UI.nothing Icon.view o.icon, text o.label ]
                        o.click

                Divider ->
                    div [ class "action-menu_action-item" ] [ UI.divider ]

                Loading ->
                    div [ class "action-menu_action-item" ]
                        [ PlaceholderShape.text
                            |> PlaceholderShape.small
                            |> PlaceholderShape.subdued
                            |> PlaceholderShape.view
                        ]

                Title t ->
                    div [ class "action-menu_action-item action-menu_action-item-title" ] [ text t ]
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

                IconButtonTrigger icon ->
                    let
                        b_ =
                            Button.icon toggleMsg icon
                                |> Button.withIconAfterLabel (chevron state)
                                |> Button.small
                    in
                    if isOpen then
                        b_ |> Button.active |> Button.view

                    else
                        Button.view b_

                CustomTrigger { toHtml } ->
                    Click.view [] [ toHtml isOpen ] (Click.onClick toggleMsg)

        actionMenu_ =
            div [ classList [ ( "action-menu", True ), ( "action-menu_is-open", isOpen ) ] ]
                [ trigger_, menu ]
    in
    if isOpen then
        onClickOutside toggleMsg actionMenu_

    else
        actionMenu_
