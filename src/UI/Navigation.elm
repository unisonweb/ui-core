module UI.Navigation exposing
    ( NavItem
    , Navigation
    , empty
    , map
    , navItem
    , navItemWithIcon
    , navItemWithNudge
    , navItemWithTooltip
    , view
    , withItems
    , withNoSelectedItems
    )

import Html exposing (Html, nav, span, text)
import Html.Attributes exposing (class, classList)
import List.Zipper as Zipper exposing (Zipper)
import UI.Click as Click exposing (Click)
import UI.Icon as Icon exposing (Icon)
import UI.Nudge as Nudge exposing (Nudge)
import UI.Tooltip as Tooltip exposing (Tooltip)



{-

   Navigation
   ==========

   A very generic UI element that in and off itself holds little styling.
   It's intended to be used contextually and get the proper styling in that way

-}


type alias NavItem msg =
    { icon : Maybe (Icon msg)
    , label : String
    , nudge : Nudge msg
    , click : Click msg
    , tooltip : Maybe (Tooltip msg)
    }


type Navigation msg
    = WithoutSelected (List (NavItem msg))
    | WithSelected (Zipper (NavItem msg))



-- CREATE


navItem : String -> Click msg -> NavItem msg
navItem label click =
    { icon = Nothing
    , label = label
    , nudge = Nudge.NoNudge
    , click = click
    , tooltip = Nothing
    }


navItemWithIcon : Icon msg -> NavItem msg -> NavItem msg
navItemWithIcon icon item =
    { item | icon = Just icon }


navItemWithNudge : Nudge msg -> NavItem msg -> NavItem msg
navItemWithNudge nudge item =
    { item | nudge = nudge }


navItemWithTooltip : Tooltip msg -> NavItem msg -> NavItem msg
navItemWithTooltip tooltip item =
    { item | tooltip = Just tooltip }


empty : Navigation msg
empty =
    WithoutSelected []



-- MODIFY


withItems : List (NavItem msg) -> NavItem msg -> List (NavItem msg) -> Navigation msg -> Navigation msg
withItems before selected after _ =
    WithSelected (Zipper.from before selected after)


withNoSelectedItems : List (NavItem msg) -> Navigation msg -> Navigation msg
withNoSelectedItems items _ =
    WithoutSelected items



-- MAP


mapNavItem : (a -> msg) -> NavItem a -> NavItem msg
mapNavItem toMsg navItemA =
    { icon = Maybe.map (Icon.map toMsg) navItemA.icon
    , label = navItemA.label
    , nudge = Nudge.map toMsg navItemA.nudge
    , click = Click.map toMsg navItemA.click
    , tooltip = Maybe.map (Tooltip.map toMsg) navItemA.tooltip
    }


map : (a -> msg) -> Navigation a -> Navigation msg
map toMsg navA =
    case navA of
        WithoutSelected items ->
            WithoutSelected (List.map (mapNavItem toMsg) items)

        WithSelected items ->
            WithSelected (Zipper.map (mapNavItem toMsg) items)



-- VIEW


viewItem : Bool -> NavItem msg -> Html msg
viewItem isSelected { icon, label, nudge, tooltip, click } =
    let
        content =
            case icon of
                Nothing ->
                    span [ class "nav-item_content" ] [ text label, Nudge.view nudge ]

                Just i ->
                    span [ class "nav-item_content" ] [ Icon.view i, text label, Nudge.view nudge ]

        item =
            case tooltip of
                Just t ->
                    Tooltip.view content t

                Nothing ->
                    content
    in
    Click.view [ classList [ ( "nav-item", True ), ( "selected", isSelected ) ] ] [ item ] click


view : Navigation msg -> Html msg
view navigation =
    case navigation of
        WithoutSelected items ->
            nav [ class "navigation" ] (List.map (viewItem False) items)

        WithSelected items ->
            let
                before =
                    List.map (viewItem False) (Zipper.before items)

                current =
                    viewItem True (Zipper.current items)

                after =
                    List.map (viewItem False) (Zipper.after items)
            in
            nav [ class "navigation" ] (before ++ (current :: after))
