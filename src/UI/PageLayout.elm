module UI.PageLayout exposing (..)

import Html exposing (Html, div, header)
import Html.Attributes exposing (class, classList)
import UI.PageContent as PageContent exposing (PageContent)
import UI.Sidebar as Sidebar exposing (Sidebar)


type PageHero msg
    = PageHero (Html msg)


type PageLayout msg
    = HeroLayout
        { hero : PageHero msg
        , content :
            PageContent msg
        }
    | SidebarEdgeToEdgeLayout
        { sidebar : Sidebar msg
        , sidebarToggled : Bool
        , content : PageContent msg
        }
    | SidebarLeftContentLayout
        { sidebar : Sidebar msg
        , sidebarToggled : Bool
        , content : PageContent msg
        }
    | CenteredLayout { content : PageContent msg }



-- VIEW


viewHero : PageHero msg -> Html msg
viewHero (PageHero content) =
    header [ class "page-hero" ] [ content ]


view : PageLayout msg -> Html msg
view page =
    case page of
        HeroLayout { hero, content } ->
            div [ class "page hero-layout" ]
                [ viewHero hero
                , PageContent.view content
                ]

        SidebarEdgeToEdgeLayout { sidebar, sidebarToggled, content } ->
            div
                [ class "page sidebar-edge-to-edge-layout"
                , classList [ ( "sidebar-toggled", sidebarToggled ) ]
                ]
                [ Sidebar.view sidebar
                , PageContent.view content
                ]

        SidebarLeftContentLayout { sidebar, sidebarToggled, content } ->
            div
                [ class "page sidebar-left-content-layout"
                , classList [ ( "sidebar-toggled", sidebarToggled ) ]
                ]
                [ Sidebar.view sidebar
                , PageContent.view content
                ]

        CenteredLayout { content } ->
            div [ class "page centered-layout" ]
                [ PageContent.view content
                ]
