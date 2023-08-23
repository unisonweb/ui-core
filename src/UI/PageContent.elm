module UI.PageContent exposing
    ( PageContent
    , empty
    , map
    , oneColumn
    , threeColumns
    , twoColumns
    , view
    , view_
    , withLeftAside
    , withPageTitle
    , withRightAside
    , withTabList
    )

import Html exposing (Html, aside, div, section)
import Html.Attributes exposing (class, id)
import UI
import UI.PageTitle as PageTitle exposing (PageTitle)
import UI.TabList as TabList exposing (TabList)


type PageAside msg
    = NoAside
    | LeftAside (List (Html msg))
    | RightAside (List (Html msg))


type PageContent msg
    = PageContent
        { title : Maybe (PageTitle msg)
        , tabList : Maybe (TabList msg)
        , content : List (List (Html msg))
        , aside : PageAside msg
        }



-- CREATE


empty : PageContent msg
empty =
    PageContent
        { title = Nothing
        , tabList = Nothing
        , content = []
        , aside = NoAside
        }


{-| Create a page content with a single column and no title
-}
oneColumn : List (Html msg) -> PageContent msg
oneColumn rows =
    PageContent
        { title = Nothing
        , tabList = Nothing
        , content = [ rows ]
        , aside = NoAside
        }


{-| Create a page content with 2 columns and no title
-}
twoColumns : ( List (Html msg), List (Html msg) ) -> PageContent msg
twoColumns ( one, two ) =
    PageContent
        { title = Nothing
        , tabList = Nothing
        , content = [ one, two ]
        , aside = NoAside
        }


{-| Create a page content with 3 columns and no title
-}
threeColumns : ( List (Html msg), List (Html msg), List (Html msg) ) -> PageContent msg
threeColumns ( one, two, three ) =
    PageContent
        { title = Nothing
        , tabList = Nothing
        , content = [ one, two, three ]
        , aside = NoAside
        }



-- MODIFY


withPageTitle : PageTitle msg -> PageContent msg -> PageContent msg
withPageTitle pageTitle (PageContent cfg) =
    PageContent { cfg | title = Just pageTitle }


withLeftAside : List (Html msg) -> PageContent msg -> PageContent msg
withLeftAside asideContent (PageContent cfg) =
    PageContent { cfg | aside = LeftAside asideContent }


withRightAside : List (Html msg) -> PageContent msg -> PageContent msg
withRightAside asideContent (PageContent cfg) =
    PageContent { cfg | aside = LeftAside asideContent }


withTabList : TabList msg -> PageContent msg -> PageContent msg
withTabList tabList (PageContent cfg) =
    PageContent { cfg | tabList = Just tabList }



-- MAP


map : (a -> msg) -> PageContent a -> PageContent msg
map toMsg (PageContent pageContentA) =
    PageContent
        { title = Maybe.map (PageTitle.map toMsg) pageContentA.title
        , tabList = Maybe.map (TabList.map toMsg) pageContentA.tabList
        , content = List.map (List.map (Html.map toMsg)) pageContentA.content
        , aside = mapPageAside toMsg pageContentA.aside
        }


mapPageAside : (a -> msg) -> PageAside a -> PageAside msg
mapPageAside toMsg pageAside =
    case pageAside of
        NoAside ->
            NoAside

        LeftAside content ->
            LeftAside (List.map (Html.map toMsg) content)

        RightAside content ->
            RightAside (List.map (Html.map toMsg) content)



-- VIEW


viewColumn : List (Html msg) -> Html msg
viewColumn column =
    section [ class "column" ] column


viewColumns : List (List (Html msg)) -> Html msg
viewColumns columns =
    section [ class "columns" ] (List.map viewColumn columns)


view : PageContent msg -> Html msg
view pageContent =
    view_ UI.nothing pageContent


view_ : Html msg -> PageContent msg -> Html msg
view_ footer (PageContent p) =
    let
        inner =
            case p.aside of
                NoAside ->
                    viewColumns p.content

                LeftAside asideItems ->
                    div [ class "with-page-aside" ]
                        [ aside [ class "page-aside page-aside_left" ] asideItems
                        , viewColumns p.content
                        ]

                RightAside asideItems ->
                    div [ class "with-page-aside" ]
                        [ viewColumns p.content
                        , aside [ class "page-aside page-aside_right" ] asideItems
                        ]

        tabList =
            case p.tabList of
                Just tl ->
                    TabList.view tl

                _ ->
                    UI.nothing

        pageContent =
            case p.title of
                Just t ->
                    [ PageTitle.view t, tabList, inner, footer ]

                Nothing ->
                    [ tabList, inner, footer ]
    in
    section [ id "page-content", class "page-content" ] pageContent
