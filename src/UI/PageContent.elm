module UI.PageContent exposing
    ( PageContent
    , PageTitle
    , empty
    , map
    , mapPageTitle
    , oneColumn
    , threeColumns
    , twoColumns
    , view
    , view_
    , withPageTitle
    )

import Html exposing (Html, aside, div, h1, header, p, section, text)
import Html.Attributes exposing (class, id)
import UI
import UI.Icon as Icon exposing (Icon)


type alias PageTitle msg =
    { icon : Maybe (Icon msg)
    , title : String
    , description : Maybe String
    }


type PageAside msg
    = NoAside
    | LeftAside (List (Html msg))
    | RightAside (List (Html msg))


type PageContent msg
    = PageContent
        { title : Maybe (PageTitle msg)
        , content : List (List (Html msg))
        , aside : PageAside msg
        }



-- CREATE


empty : PageContent msg
empty =
    PageContent
        { title = Nothing
        , content = []
        , aside = NoAside
        }


{-| Create a page content with a single column and no title
-}
oneColumn : List (Html msg) -> PageContent msg
oneColumn rows =
    PageContent
        { title = Nothing
        , content = [ rows ]
        , aside = NoAside
        }


{-| Create a page content with 2 columns and no title
-}
twoColumns : ( List (Html msg), List (Html msg) ) -> PageContent msg
twoColumns ( one, two ) =
    PageContent
        { title = Nothing
        , content = [ one, two ]
        , aside = NoAside
        }


{-| Create a page content with 3 columns and no title
-}
threeColumns : ( List (Html msg), List (Html msg), List (Html msg) ) -> PageContent msg
threeColumns ( one, two, three ) =
    PageContent
        { title = Nothing
        , content = [ one, two, three ]
        , aside = NoAside
        }



-- MODIFY


{-| Set a PageTitle
-}
withPageTitle : PageTitle msg -> PageContent msg -> PageContent msg
withPageTitle pageTitle (PageContent cfg) =
    PageContent { cfg | title = Just pageTitle }



-- MAP


map : (a -> msg) -> PageContent a -> PageContent msg
map toMsg (PageContent pageContentA) =
    PageContent
        { title = Maybe.map (mapPageTitle toMsg) pageContentA.title
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


mapPageTitle : (a -> msg) -> PageTitle a -> PageTitle msg
mapPageTitle toMsg pageTitleA =
    { icon = Maybe.map (Icon.map toMsg) pageTitleA.icon
    , title = pageTitleA.title
    , description = pageTitleA.description
    }



-- VIEW


viewPageTitle : PageTitle msg -> Html msg
viewPageTitle { icon, title, description } =
    let
        items =
            case ( icon, description ) of
                ( Nothing, Nothing ) ->
                    [ h1 [] [ text title ] ]

                ( Nothing, Just d ) ->
                    [ div [ class "text" ]
                        [ h1 [] [ text title ]
                        , p [ class "description" ] [ text d ]
                        ]
                    ]

                ( Just i, Nothing ) ->
                    [ div [ class "icon-badge" ] [ Icon.view i ]
                    , h1 [] [ text title ]
                    ]

                ( Just i, Just d ) ->
                    [ div [ class "icon-badge" ] [ Icon.view i ]
                    , div [ class "text" ]
                        [ h1 [] [ text title ]
                        , p [ class "description" ] [ text d ]
                        ]
                    ]
    in
    header [ class "page-title" ] items


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
                        [ viewColumns p.content
                        , aside [ class "page-aside page-aside_left" ] asideItems
                        ]

                RightAside asideItems ->
                    div [ class "with-page-aside" ]
                        [ viewColumns p.content
                        , aside [ class "page-aside page-aside_right" ] asideItems
                        ]

        pageContent =
            case p.title of
                Just h ->
                    [ viewPageTitle h, inner, footer ]

                Nothing ->
                    [ inner, footer ]
    in
    section [ id "page-content", class "page-content" ] pageContent
