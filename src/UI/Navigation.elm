module UI.Navigation exposing
    ( NavItem
    , Navigation
    , empty
    , view
    , withItems
    , withNoSelectedItems
    )

import Html exposing (Html, nav, text)
import Html.Attributes exposing (class, classList)
import List.Zipper as Zipper exposing (Zipper)
import UI
import UI.Click as Click exposing (Click)
import UI.Icon as Icon exposing (Icon)



{-

   Navigation
   ==========

   A very generic UI element that in and off itself holds little styling.
   It's intended to be used contextually and get the proper styling in that way

-}


type alias NavItem msg =
    { icon : Maybe (Icon msg), label : String, click : Click msg }


type Navigation msg
    = WithoutSelected (List (NavItem msg))
    | WithSelected (Zipper (NavItem msg))



-- CREATE


empty : Navigation msg
empty =
    WithoutSelected []


withItems : List (NavItem msg) -> NavItem msg -> List (NavItem msg) -> Navigation msg -> Navigation msg
withItems before selected after nav =
    case nav of
        WithoutSelected _ ->
            WithSelected (Zipper.from before selected after)

        WithSelected _ ->
            WithSelected (Zipper.from before selected after)


withNoSelectedItems : List (NavItem msg) -> Navigation msg -> Navigation msg
withNoSelectedItems items nav =
    case nav of
        WithoutSelected _ ->
            WithoutSelected items

        WithSelected _ ->
            WithoutSelected items


viewItem : Bool -> NavItem msg -> Html msg
viewItem isSelected { icon, label, click } =
    let
        content =
            case icon of
                Nothing ->
                    [ text label ]

                Just i ->
                    [ Icon.view i, text label ]
    in
    Click.view [ classList [ ( "nav-item", True ), ( "selected", isSelected ) ] ] content click


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
