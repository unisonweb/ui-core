module UI.ActionMenu exposing
    ( ActionItem
    , ActionItems
    , ActionMenu
    , Subtext(..)
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
    , withButtonColor
    , withButtonIcon
    , withMaxWidth
    , withNudge
    )

import Html exposing (Html, div, label, text)
import Html.Attributes exposing (class, classList, style)
import Lib.OnClickOutside exposing (onClickOutside)
import List.Nonempty as Nonempty exposing (Nonempty(..))
import Maybe.Extra as MaybeE
import UI
import UI.Button as Button exposing (Button)
import UI.Click as Click exposing (Click)
import UI.DateTime as DateTime exposing (DateTime, DateTimeFormat)
import UI.Divider as Divider
import UI.Icon as Icon exposing (Icon)
import UI.Nudge as Nudge exposing (Nudge(..))
import UI.Placeholder as Placeholder
import UI.Sizing exposing (Rem(..))


type OpenState
    = Open
    | Closed


type Subtext
    = NoSubtext
    | SimpleSubtext String
    | DateTimeSubtext DateTimeFormat DateTime


type alias ActionOption msg =
    { icon : Maybe (Icon msg)
    , label : String
    , subtext : Subtext
    , click : Click msg
    , nudge : Nudge msg
    }


type ActionItem msg
    = Option (ActionOption msg)
    | Divider
    | Title String
    | Loading


type ActionItems msg
    = ActionItems (Nonempty (ActionItem msg))


type ActionMenuTrigger msg
    = ButtonTrigger { icon : Maybe (Icon msg), label : String, color : Button.Color }
    | IconButtonTrigger (Icon msg)
    | CustomTrigger { toHtml : Bool -> Html msg }


type alias ActionMenu msg =
    { toggleMsg : msg
    , state : OpenState
    , trigger : ActionMenuTrigger msg
    , actionItems : ActionItems msg
    , nudge : Nudge msg
    , maxWidth : Maybe Rem
    }



-- CREATE


fromButton : msg -> String -> ActionItems msg -> ActionMenu msg
fromButton toggleMsg buttonLabel actionItems =
    { toggleMsg = toggleMsg
    , state = Closed
    , trigger = ButtonTrigger { icon = Nothing, label = buttonLabel, color = Button.Default }
    , actionItems = actionItems
    , nudge = NoNudge
    , maxWidth = Nothing
    }


fromIconButton : msg -> Icon msg -> ActionItems msg -> ActionMenu msg
fromIconButton toggleMsg icon actionItems =
    { toggleMsg = toggleMsg
    , state = Closed
    , trigger = IconButtonTrigger icon
    , actionItems = actionItems
    , nudge = NoNudge
    , maxWidth = Nothing
    }


fromCustom : msg -> (Bool -> Html msg) -> ActionItems msg -> ActionMenu msg
fromCustom toggleMsg toHtml actionItems =
    { toggleMsg = toggleMsg
    , state = Closed
    , trigger = CustomTrigger { toHtml = toHtml }
    , actionItems = actionItems
    , nudge = NoNudge
    , maxWidth = Nothing
    }


items : ActionItem msg -> List (ActionItem msg) -> ActionItems msg
items actionItem actionItems =
    ActionItems (Nonempty actionItem actionItems)


optionItem : Icon msg -> String -> Click msg -> ActionItem msg
optionItem icon label click =
    optionItem_ (Just icon) label NoSubtext NoNudge click


optionItemWithoutIcon : String -> Click msg -> ActionItem msg
optionItemWithoutIcon label click =
    optionItem_ Nothing label NoSubtext NoNudge click


optionItem_ :
    Maybe (Icon msg)
    -> String
    -> Subtext
    -> Nudge msg
    -> Click msg
    -> ActionItem msg
optionItem_ icon label subtext nudge click =
    Option
        { icon = icon
        , label = label
        , subtext = subtext
        , nudge = nudge
        , click = click
        }


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


withButtonColor : Button.Color -> ActionMenu msg -> ActionMenu msg
withButtonColor color actionMenu_ =
    case actionMenu_.trigger of
        ButtonTrigger b ->
            let
                bt =
                    ButtonTrigger { b | color = color }
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


withNudge : Nudge msg -> ActionMenu msg -> ActionMenu msg
withNudge nudge actionMenu_ =
    { actionMenu_ | nudge = nudge }


withMaxWidth : Rem -> ActionMenu msg -> ActionMenu msg
withMaxWidth maxWidth actionMenu_ =
    { actionMenu_ | maxWidth = Just maxWidth }


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


caret : OpenState -> Icon msg
caret state =
    case state of
        Open ->
            Icon.caretUp

        Closed ->
            Icon.caretDown


viewButton : msg -> String -> Maybe (Icon msg) -> Button.Color -> OpenState -> Button msg
viewButton toggleMsg label icon color state =
    Button.button toggleMsg label
        |> Button.withIconAfterLabel (caret state)
        |> Button.withColor color
        |> Button.small
        |> buttonWithIcon icon


buttonWithIcon : Maybe (Icon msg) -> Button msg -> Button msg
buttonWithIcon icon button =
    case icon of
        Just i ->
            Button.withIconBeforeLabel i button

        Nothing ->
            button


viewSheet : Maybe Rem -> ActionItems msg -> Html msg
viewSheet maxWidth (ActionItems items_) =
    let
        maxWidthStyle =
            maxWidth
                |> Maybe.map (\(Rem mw) -> style "max-width" (String.fromFloat mw ++ "rem"))
                |> Maybe.map List.singleton
                |> Maybe.withDefault []

        viewItem i =
            case i of
                Option o ->
                    let
                        subtext =
                            case o.subtext of
                                NoSubtext ->
                                    UI.nothing

                                SimpleSubtext t ->
                                    div [ class "action-menu_action-item-option_subtext" ] [ text t ]

                                DateTimeSubtext f t ->
                                    div [ class "action-menu_action-item-option_subtext" ] [ DateTime.view f t ]
                    in
                    Click.view
                        [ class "action-menu_action-item action-menu_action-item-option" ]
                        [ MaybeE.unwrap UI.nothing Icon.view o.icon
                        , div [ class "action-menu_action-item-option_text" ]
                            [ label
                                [ class "action-menu_action-item-option_label" ]
                                [ text o.label ]
                            , subtext
                            ]
                        , Nudge.view o.nudge
                        ]
                        o.click

                Divider ->
                    div [ class "action-menu_action-item action-menu_action-item-divider" ]
                        [ Divider.divider
                            |> Divider.small
                            |> Divider.onDark
                            |> Divider.withoutMargin
                            |> Divider.view
                        ]

                Loading ->
                    div [ class "action-menu_action-item action-menu_action-item-loading" ]
                        [ Placeholder.text
                            |> Placeholder.small
                            |> Placeholder.subdued
                            |> Placeholder.view
                        ]

                Title t ->
                    div [ class "action-menu_action-item action-menu_action-item-title" ] [ text t ]
    in
    div (class "action-menu_sheet" :: maxWidthStyle) (items_ |> Nonempty.toList |> List.map viewItem)


view : ActionMenu msg -> Html msg
view { toggleMsg, nudge, state, trigger, actionItems, maxWidth } =
    let
        ( menu, isOpen ) =
            case state of
                Closed ->
                    ( UI.nothing, False )

                Open ->
                    ( viewSheet maxWidth actionItems, True )

        trigger_ =
            case trigger of
                ButtonTrigger { label, icon, color } ->
                    let
                        b_ =
                            viewButton toggleMsg label icon color state
                    in
                    if isOpen then
                        b_ |> Button.active |> Button.view

                    else
                        Button.view b_

                IconButtonTrigger icon ->
                    let
                        b_ =
                            Button.icon toggleMsg icon
                                |> Button.withIconAfterLabel (caret state)
                                |> Button.small
                    in
                    if isOpen then
                        b_ |> Button.active |> Button.view

                    else
                        Button.view b_

                CustomTrigger { toHtml } ->
                    Click.view [] [ toHtml isOpen ] (Click.onClick toggleMsg)

        attrs =
            [ classList
                [ ( "action-menu", True )
                , ( "action-menu_is-open", isOpen )
                , ( "action-menu_with-max-width", MaybeE.isJust maxWidth )
                ]
            ]

        actionMenu_ =
            div attrs [ trigger_, Nudge.view nudge, menu ]
    in
    if isOpen then
        onClickOutside toggleMsg actionMenu_

    else
        actionMenu_
