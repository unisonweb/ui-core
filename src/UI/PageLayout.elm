module UI.PageLayout exposing (..)

import Html exposing (Html, div, header, span, text)
import Html.Attributes exposing (class, classList)
import Lib.OperatingSystem exposing (OperatingSystem)
import UI.Click as Click
import UI.PageContent as PageContent exposing (PageContent)
import UI.Sidebar as Sidebar exposing (Sidebar)


type PageHero msg
    = PageHero (Html msg)


type PageFooter msg
    = PageFooter (List (Html msg))


type alias Layout a msg =
    { a
        | content : PageContent msg
        , footer : PageFooter msg
    }


type PageLayout msg
    = HeroLayout (Layout { hero : PageHero msg } msg)
    | SidebarEdgeToEdgeLayout
        (Layout
            { sidebar : Sidebar msg
            , sidebarToggled : Bool
            , operatingSystem : OperatingSystem
            }
            msg
        )
    | SidebarLeftContentLayout
        (Layout
            { sidebar : Sidebar msg
            , sidebarToggled : Bool
            , operatingSystem : OperatingSystem
            }
            msg
        )
    | CenteredLayout (Layout {} msg)
    | PresentationLayout (PageContent msg)



-- TRANSFORM


withContent : PageContent msg -> PageLayout msg -> PageLayout msg
withContent content pl =
    let
        withContent_ l =
            { l | content = content }
    in
    case pl of
        HeroLayout l ->
            HeroLayout (withContent_ l)

        SidebarEdgeToEdgeLayout l ->
            SidebarEdgeToEdgeLayout (withContent_ l)

        SidebarLeftContentLayout l ->
            SidebarLeftContentLayout (withContent_ l)

        CenteredLayout l ->
            CenteredLayout (withContent_ l)

        PresentationLayout _ ->
            PresentationLayout content



-- MAP


map : (a -> msg) -> PageLayout a -> PageLayout msg
map toMsg pageLayout =
    case pageLayout of
        HeroLayout layout ->
            HeroLayout
                { content = PageContent.map toMsg layout.content
                , footer = mapPageFooter toMsg layout.footer
                , hero = mapPageHero toMsg layout.hero
                }

        SidebarEdgeToEdgeLayout layout ->
            SidebarEdgeToEdgeLayout
                { content = PageContent.map toMsg layout.content
                , footer = mapPageFooter toMsg layout.footer
                , sidebar = Sidebar.map toMsg layout.sidebar
                , sidebarToggled = layout.sidebarToggled
                , operatingSystem = layout.operatingSystem
                }

        SidebarLeftContentLayout layout ->
            SidebarLeftContentLayout
                { content = PageContent.map toMsg layout.content
                , footer = mapPageFooter toMsg layout.footer
                , sidebar = Sidebar.map toMsg layout.sidebar
                , sidebarToggled = layout.sidebarToggled
                , operatingSystem = layout.operatingSystem
                }

        CenteredLayout layout ->
            CenteredLayout
                { content = PageContent.map toMsg layout.content
                , footer = mapPageFooter toMsg layout.footer
                }

        PresentationLayout content ->
            PresentationLayout (PageContent.map toMsg content)


mapPageFooter : (a -> msg) -> PageFooter a -> PageFooter msg
mapPageFooter toMsg (PageFooter items) =
    PageFooter (List.map (Html.map toMsg) items)


mapPageHero : (a -> msg) -> PageHero a -> PageHero msg
mapPageHero toMsg (PageHero hero) =
    PageHero (Html.map toMsg hero)



-- VIEW


viewPageHero : PageHero msg -> Html msg
viewPageHero (PageHero content) =
    header [ class "page-hero" ] [ content ]


viewPageFooter : PageFooter msg -> Html msg
viewPageFooter (PageFooter footerItems) =
    let
        copyright =
            span [ class "copyright" ]
                [ text "© 2021-2022 "
                , Click.externalHref "https://unison-lang.org/unison-computing/"
                    |> Click.view [] [ text "Unison Computing, PBC" ]
                ]

        sep =
            span [ class "separator" ] [ text "•" ]
    in
    case footerItems of
        [] ->
            Html.footer [ class "page-footer" ] [ copyright ]

        _ ->
            Html.footer [ class "page-footer" ]
                [ copyright, span [ class "page-footer_items" ] (sep :: List.intersperse sep footerItems) ]


view : PageLayout msg -> Html msg
view page =
    case page of
        HeroLayout { hero, content, footer } ->
            div [ class "page hero-layout" ]
                [ viewPageHero hero
                , PageContent.view_ (viewPageFooter footer) content
                ]

        SidebarEdgeToEdgeLayout { sidebar, sidebarToggled, operatingSystem, content } ->
            div
                [ class "page sidebar-edge-to-edge-layout"
                , classList [ ( "sidebar-toggled", sidebarToggled ) ]
                ]
                [ Sidebar.view operatingSystem sidebar
                , PageContent.view content
                ]

        SidebarLeftContentLayout { sidebar, sidebarToggled, operatingSystem, content, footer } ->
            div
                [ class "page sidebar-left-content-layout"
                , classList [ ( "sidebar-toggled", sidebarToggled ) ]
                ]
                [ Sidebar.view operatingSystem sidebar
                , PageContent.view_ (viewPageFooter footer) content
                ]

        CenteredLayout { content, footer } ->
            div [ class "page centered-layout" ]
                [ PageContent.view_ (viewPageFooter footer) content
                ]

        PresentationLayout content ->
            div [ class "page presentation-layout" ]
                [ PageContent.view_ (viewPageFooter (PageFooter [])) content
                ]
