module UI.Sidebar exposing (..)

import Html exposing (Html, aside, div, footer, h3, span, text)
import Html.Attributes exposing (class, id)
import Maybe.Extra as MaybeE
import UI
import UI.Button as Button exposing (Button)
import UI.Click as Click exposing (Click)
import UI.Icon as Icon exposing (Icon)


type SidebarHeader msg
    = SidebarHeader (List (Html msg))


type alias SidebarSection msg =
    { title : String
    , titleButton : Maybe (Button msg)
    , content : List (Html msg)
    , scrollable : Bool
    }


type alias SidebarMenuItem msg =
    { click : Click msg
    , icon : Icon msg
    , label : String
    , count : Maybe Int
    }


type SidebarContentItem msg
    = MenuItem (SidebarMenuItem msg)
    | Divider
    | Section (SidebarSection msg)


type alias ToggleConfig msg =
    { isToggled : Bool, toggleMsg : msg }


type Toggle msg
    = NotToggleable
    | Toggle (ToggleConfig msg)


type alias Sidebar msg =
    { id : String
    , header : Maybe (SidebarHeader msg)
    , content : List (SidebarContentItem msg)
    , toggle : Toggle msg
    }



-- CREATE


sidebar : String -> SidebarHeader msg -> Sidebar msg
sidebar id h =
    empty id |> withHeader h


empty : String -> Sidebar msg
empty id =
    { id = id, header = Nothing, content = [], toggle = NotToggleable }



-- MAP


mapSection : (a -> msg) -> SidebarSection a -> SidebarSection msg
mapSection toMsg sectionA =
    { title = sectionA.title
    , titleButton = Maybe.map (Button.map toMsg) sectionA.titleButton
    , content = List.map (Html.map toMsg) sectionA.content
    , scrollable = sectionA.scrollable
    }



-- CREATE ELEMENT


header : List (Html msg) -> SidebarHeader msg
header content =
    SidebarHeader content


section : String -> List (Html msg) -> SidebarSection msg
section title content =
    { title = title, titleButton = Nothing, content = content, scrollable = False }


sectionWithTitleButton : Button msg -> SidebarSection msg -> SidebarSection msg
sectionWithTitleButton button section_ =
    { section_ | titleButton = Just button }


sectionWithScrollable : SidebarSection msg -> SidebarSection msg
sectionWithScrollable section_ =
    { section_ | scrollable = True }


menuItem : msg -> Icon msg -> String -> SidebarMenuItem msg
menuItem clickMsg icon label_ =
    menuItem_ (Click.onClick clickMsg) icon label_


menuItem_ : Click msg -> Icon msg -> String -> SidebarMenuItem msg
menuItem_ click icon label_ =
    { click = click, icon = icon, label = label_, count = Nothing }


menuItemWithCount : Int -> SidebarMenuItem msg -> SidebarMenuItem msg
menuItemWithCount count menuItem__ =
    { menuItem__ | count = Just count }



-- MODIFY


withHeader : SidebarHeader msg -> Sidebar msg -> Sidebar msg
withHeader header_ sidebar_ =
    { sidebar_ | header = Just header_ }


withContent : List (SidebarContentItem msg) -> Sidebar msg -> Sidebar msg
withContent content sidebar_ =
    { sidebar_ | content = content }


withContentItem : SidebarContentItem msg -> Sidebar msg -> Sidebar msg
withContentItem contentItem sidebar_ =
    withContentItems [ contentItem ] sidebar_


withContentItems : List (SidebarContentItem msg) -> Sidebar msg -> Sidebar msg
withContentItems contentItems sidebar_ =
    { sidebar_ | content = sidebar_.content ++ contentItems }


withMenuItem : SidebarMenuItem msg -> Sidebar msg -> Sidebar msg
withMenuItem menuItem__ sidebar_ =
    withContentItem (MenuItem menuItem__) sidebar_


withMenuItems : List (SidebarMenuItem msg) -> Sidebar msg -> Sidebar msg
withMenuItems menuItems sidebar_ =
    withContentItems (List.map MenuItem menuItems) sidebar_


withDivider : Sidebar msg -> Sidebar msg
withDivider sidebar_ =
    withContentItem Divider sidebar_


withSection : SidebarSection msg -> Sidebar msg -> Sidebar msg
withSection section_ sidebar_ =
    withContentItem (Section section_) sidebar_


withToggle : ToggleConfig msg -> Sidebar msg -> Sidebar msg
withToggle toggleConfig sidebar_ =
    { sidebar_ | toggle = Toggle toggleConfig }



-- VIEW


viewHeader : SidebarHeader msg -> Html msg
viewHeader (SidebarHeader items) =
    let
        viewHeaderItem i =
            div [ class "sidebar-header-item" ] [ i ]
    in
    Html.header [ class "sidebar-header" ] (List.map viewHeaderItem items)


viewSection : SidebarSection msg -> Html msg
viewSection { title, titleButton, content, scrollable } =
    let
        sectionHeader =
            Html.header
                [ class "sidebar-section-header" ]
                [ h3 [ class "sidebar-section-title" ] [ text title ]
                , MaybeE.unwrap UI.nothing Button.view titleButton
                ]

        section_ =
            Html.section
                [ class "sidebar-section" ]
                (sectionHeader :: content)
    in
    if scrollable then
        div [ class "sidebar-scroll-area" ] [ section_ ]

    else
        section_


viewMenuItem : SidebarMenuItem msg -> Html msg
viewMenuItem { click, icon, label, count } =
    let
        count_ =
            case count of
                Just c ->
                    span
                        [ class "sidebar-menu-item-count" ]
                        [ text (String.fromInt c) ]

                Nothing ->
                    UI.nothing
    in
    Click.view [ class "sidebar-menu-item" ]
        [ Icon.view icon, Html.label [] [ text label ], count_ ]
        click


viewSidebarContentItem : SidebarContentItem msg -> Html msg
viewSidebarContentItem item =
    case item of
        MenuItem mi ->
            viewMenuItem mi

        Divider ->
            UI.divider

        Section s ->
            viewSection s


view : Sidebar msg -> Html msg
view sidebar_ =
    let
        header_ =
            MaybeE.unwrap UI.nothing viewHeader sidebar_.header

        toggle =
            case sidebar_.toggle of
                NotToggleable ->
                    UI.nothing

                Toggle { isToggled, toggleMsg } ->
                    if isToggled then
                        footer [ class "sidebar-footer" ]
                            [ Button.icon toggleMsg Icon.leftSidebarOn
                                |> Button.small
                                |> Button.view
                            ]

                    else
                        footer [ class "sidebar-footer" ]
                            [ Button.iconThenLabel toggleMsg Icon.leftSidebarOff "Toggle Sidebar"
                                |> Button.small
                                |> Button.view
                            ]
    in
    aside [ id sidebar_.id, class "sidebar" ]
        (header_ :: List.map viewSidebarContentItem sidebar_.content ++ [ toggle ])
