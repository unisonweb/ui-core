{-
   Tabs
   ====

   (i) It would be prudent for this module to wrap UI.Navigation, or use it in
       some way, but we want something a little more closed and Navigation
       works with NavItems which can't be wrapped (Higher Kinded Types would
       have helped solve that).
-}


module UI.TabList exposing
    ( Tab
    , TabList
    , map
    , tab
    , tabList
    , view
    , viewTab
    , withCount
    )

import Html exposing (Html, nav, span, text)
import Html.Attributes exposing (class)
import Lib.Aria exposing (role)
import List.Zipper as Zipper exposing (Zipper)
import UI
import UI.Click as Click exposing (Click)


type Tab msg
    = Tab
        { label : String
        , click : Click msg
        , count : Maybe Int
        }


type TabList msg
    = TabList (Zipper (Tab msg))



-- CREATE


tab : String -> Click msg -> Tab msg
tab label click =
    Tab { label = label, click = click, count = Nothing }


tabList : List (Tab msg) -> Tab msg -> List (Tab msg) -> TabList msg
tabList before selected_ after =
    TabList (Zipper.from before selected_ after)



-- MODIFY


withCount : Int -> Tab msg -> Tab msg
withCount n (Tab t) =
    Tab { t | count = Just n }



-- MAP


mapTab : (a -> b) -> Tab a -> Tab b
mapTab f (Tab a) =
    Tab { label = a.label, click = Click.map f a.click, count = a.count }


map : (a -> b) -> TabList a -> TabList b
map f (TabList a) =
    TabList (Zipper.map (mapTab f) a)



-- VIEW


viewTab : Bool -> Tab msg -> Html msg
viewTab isSelected (Tab tab_) =
    let
        attrs =
            [ class "tab", role "tab" ]

        count =
            case tab_.count of
                Just n ->
                    span [ class "count" ] [ text (String.fromInt n) ]

                Nothing ->
                    UI.nothing

        content =
            [ text tab_.label, count ]
    in
    if isSelected then
        span (class "tab_selected" :: attrs) content

    else
        Click.view attrs content tab_.click


view : TabList msg -> Html msg
view (TabList tabList_) =
    let
        before =
            List.map (viewTab False) (Zipper.before tabList_)

        selected =
            viewTab True (Zipper.current tabList_)

        after =
            List.map (viewTab False) (Zipper.after tabList_)
    in
    nav [ class "tab-list", role "tablist" ]
        (before ++ (selected :: after))
