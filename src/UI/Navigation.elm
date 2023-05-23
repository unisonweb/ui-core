module UI.Navigation exposing
    ( NavItem
    , Navigation
    , empty
    , map
    , navItem
    , navItemWithAnchoredOverlay
    , navItemWithButton
    , navItemWithIcon
    , navItemWithNudge
    , navItemWithTag
    , navItemWithTooltip
    , selected
    , view
    , viewCondensed
    , withItems
    , withNoSelectedItems
    )

import Html exposing (Html, div, nav, span, text)
import Html.Attributes exposing (class, classList)
import List.Zipper as Zipper exposing (Zipper)
import Maybe.Extra as MaybeE
import UI
import UI.AnchoredOverlay as AnchoredOverlay exposing (AnchoredOverlay)
import UI.Button as Button exposing (Button)
import UI.Click as Click exposing (Click)
import UI.Icon as Icon exposing (Icon)
import UI.Nudge as Nudge exposing (Nudge)
import UI.Tag as Tag exposing (Tag)
import UI.Tooltip as Tooltip exposing (Tooltip)



{-

   Navigation
   ==========

   A very generic UI element that in and off itself holds little styling.
   It's intended to be used contextually and get the proper styling in that way

-}


type NavItemSecondaryContent msg
    = NoContent
    | TagContent (Tag msg)
    | ButtonContent (Button msg)
    | AnchoredOverlayContent (AnchoredOverlay msg)


type alias NavItem msg =
    { icon : Maybe (Icon msg)
    , label : String
    , secondary : NavItemSecondaryContent msg
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
    , secondary = NoContent
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


navItemWithTag : Tag msg -> NavItem msg -> NavItem msg
navItemWithTag tag item =
    { item | secondary = TagContent tag }


navItemWithButton : Button msg -> NavItem msg -> NavItem msg
navItemWithButton button item =
    { item | secondary = ButtonContent button }


navItemWithAnchoredOverlay : AnchoredOverlay msg -> NavItem msg -> NavItem msg
navItemWithAnchoredOverlay ao item =
    { item | secondary = AnchoredOverlayContent ao }


empty : Navigation msg
empty =
    WithoutSelected []



-- MODIFY


withItems : List (NavItem msg) -> NavItem msg -> List (NavItem msg) -> Navigation msg -> Navigation msg
withItems before selected_ after _ =
    WithSelected (Zipper.from before selected_ after)


withNoSelectedItems : List (NavItem msg) -> Navigation msg -> Navigation msg
withNoSelectedItems items _ =
    WithoutSelected items



-- MAP


mapNavItemSecondaryContent : (a -> msg) -> NavItemSecondaryContent a -> NavItemSecondaryContent msg
mapNavItemSecondaryContent f secondary =
    case secondary of
        NoContent ->
            NoContent

        TagContent t ->
            TagContent (Tag.map f t)

        ButtonContent b ->
            ButtonContent (Button.map f b)

        AnchoredOverlayContent ao ->
            AnchoredOverlayContent (AnchoredOverlay.map f ao)


mapNavItem : (a -> msg) -> NavItem a -> NavItem msg
mapNavItem toMsg navItemA =
    { icon = Maybe.map (Icon.map toMsg) navItemA.icon
    , label = navItemA.label
    , secondary = mapNavItemSecondaryContent toMsg navItemA.secondary
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



-- QUERY


selected : Navigation msg -> Maybe (NavItem msg)
selected nav =
    case nav of
        WithSelected z ->
            Just (Zipper.current z)

        WithoutSelected _ ->
            Nothing



-- VIEW


viewItem : Bool -> Bool -> NavItem msg -> Html msg
viewItem condensed isSelected { icon, label, secondary, nudge, tooltip, click } =
    let
        secondaryContent =
            if condensed then
                Nothing

            else
                case secondary of
                    TagContent tag ->
                        Just (Tag.view tag)

                    ButtonContent button ->
                        button
                            |> Button.stopPropagation
                            |> Button.view
                            |> Just

                    AnchoredOverlayContent ao ->
                        Just (AnchoredOverlay.view ao)

                    NoContent ->
                        Nothing

        icon_ =
            MaybeE.unwrap UI.nothing Icon.view icon

        withTooltip c =
            MaybeE.unwrap c (Tooltip.view c) tooltip
    in
    case secondaryContent of
        Just secondary_ ->
            div [ classList [ ( "nav-item", True ), ( "selected", isSelected ) ] ]
                [ span [ class "nav-item_content" ]
                    [ Click.view
                        [ class "nav-item_click-target" ]
                        [ withTooltip (span [ class "nav-item_inner-content" ] [ icon_, text label ]) ]
                        click
                    , div [ class "nav-item_secondary" ] [ secondary_ ]
                    , Nudge.view nudge
                    ]
                ]

        Nothing ->
            let
                content =
                    span [ class "nav-item_content" ]
                        [ MaybeE.unwrap UI.nothing Icon.view icon
                        , text label
                        , Nudge.view nudge
                        ]
            in
            Click.view
                [ classList
                    [ ( "nav-item", True )
                    , ( "nav-item_click-target", True )
                    , ( "selected", isSelected )
                    ]
                ]
                [ withTooltip content ]
                click


view : Navigation msg -> Html msg
view navigation =
    view_ False navigation


{-| like `view`, but discards any secondary nav item content
-}
viewCondensed : Navigation msg -> Html msg
viewCondensed navigation =
    view_ True navigation


view_ : Bool -> Navigation msg -> Html msg
view_ condensed navigation =
    case navigation of
        WithoutSelected items ->
            nav [ class "navigation" ] (List.map (viewItem condensed False) items)

        WithSelected items ->
            let
                before =
                    List.map (viewItem condensed False) (Zipper.before items)

                current =
                    viewItem condensed True (Zipper.current items)

                after =
                    List.map (viewItem condensed False) (Zipper.after items)
            in
            nav [ class "navigation" ] (before ++ (current :: after))
