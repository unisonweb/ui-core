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
                    |> Click.view [] [ text "Unison Computing, a public benefit corp" ]
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
