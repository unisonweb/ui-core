module UI.PageLayout exposing (..)

import Html exposing (Html, div, header, span, text)
import Html.Attributes exposing (class, classList)
import Lib.OperatingSystem exposing (OperatingSystem)
import UI.Click as Click
import UI.CopyrightYear as CopyrightYear
import UI.PageContent as PageContent exposing (PageContent)
import UI.PageTitle as PageTitle exposing (PageTitle)
import UI.Sidebar as Sidebar exposing (Sidebar)
import UI.TabList as TabList exposing (TabList)


type PageHero msg
    = PageHero (Html msg)


type PageFooter msg
    = PageFooter (List (Html msg))


type BackgroundColor
    = DefaultBackground
    | SubduedBackground


type alias Layout a msg =
    { a
        | content : PageContent msg
        , footer : PageFooter msg
        , backgroundColor : BackgroundColor
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
    | CenteredNarrowLayout (Layout {} msg)
    | TabbedLayout (Layout { pageTitle : PageTitle msg, tabList : TabList msg } msg)
    | PresentationLayout (PageContent msg)


heroLayout : PageHero msg -> PageContent msg -> PageFooter msg -> PageLayout msg
heroLayout hero content footer =
    HeroLayout
        { hero = hero
        , content = content
        , footer = footer
        , backgroundColor = DefaultBackground
        }


sidebarEdgeToEdgeLayout : OperatingSystem -> Sidebar msg -> PageContent msg -> PageFooter msg -> PageLayout msg
sidebarEdgeToEdgeLayout os sidebar content footer =
    SidebarEdgeToEdgeLayout
        { sidebar = sidebar
        , sidebarToggled = False
        , content = content
        , footer = footer
        , backgroundColor = DefaultBackground
        , operatingSystem = os
        }


sidebarLeftContentLayout : OperatingSystem -> Sidebar msg -> PageContent msg -> PageFooter msg -> PageLayout msg
sidebarLeftContentLayout os sidebar content footer =
    SidebarLeftContentLayout
        { sidebar = sidebar
        , sidebarToggled = False
        , content = content
        , footer = footer
        , backgroundColor = DefaultBackground
        , operatingSystem = os
        }


centeredLayout : PageContent msg -> PageFooter msg -> PageLayout msg
centeredLayout content footer =
    CenteredLayout
        { content = content
        , footer = footer
        , backgroundColor = DefaultBackground
        }


centeredNarrowLayout : PageContent msg -> PageFooter msg -> PageLayout msg
centeredNarrowLayout content footer =
    CenteredNarrowLayout
        { content = content
        , footer = footer
        , backgroundColor = DefaultBackground
        }


tabbedLayout : PageTitle msg -> TabList msg -> PageContent msg -> PageFooter msg -> PageLayout msg
tabbedLayout pageTitle tabList content footer =
    TabbedLayout
        { pageTitle = pageTitle
        , tabList = tabList
        , content = content
        , footer = footer
        , backgroundColor = DefaultBackground
        }


presentationLayout : PageContent msg -> PageLayout msg
presentationLayout content =
    PresentationLayout content



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

        CenteredNarrowLayout l ->
            CenteredNarrowLayout (withContent_ l)

        TabbedLayout l ->
            TabbedLayout (withContent_ l)

        PresentationLayout _ ->
            PresentationLayout content


withBackgroundColor : BackgroundColor -> PageLayout msg -> PageLayout msg
withBackgroundColor bg pl =
    case pl of
        HeroLayout l ->
            HeroLayout { l | backgroundColor = bg }

        SidebarEdgeToEdgeLayout l ->
            SidebarEdgeToEdgeLayout { l | backgroundColor = bg }

        SidebarLeftContentLayout l ->
            SidebarLeftContentLayout { l | backgroundColor = bg }

        CenteredLayout l ->
            CenteredLayout { l | backgroundColor = bg }

        CenteredNarrowLayout l ->
            CenteredNarrowLayout { l | backgroundColor = bg }

        TabbedLayout _ ->
            pl

        PresentationLayout _ ->
            pl


withSubduedBackground : PageLayout msg -> PageLayout msg
withSubduedBackground pl =
    withBackgroundColor SubduedBackground pl


withSidebarToggle : Bool -> PageLayout msg -> PageLayout msg
withSidebarToggle sidebarToggled pl =
    case pl of
        SidebarEdgeToEdgeLayout l ->
            SidebarEdgeToEdgeLayout { l | sidebarToggled = sidebarToggled }

        SidebarLeftContentLayout l ->
            SidebarLeftContentLayout { l | sidebarToggled = sidebarToggled }

        _ ->
            pl



-- MAP


map : (a -> msg) -> PageLayout a -> PageLayout msg
map toMsg pageLayout =
    case pageLayout of
        HeroLayout layout ->
            HeroLayout
                { content = PageContent.map toMsg layout.content
                , footer = mapPageFooter toMsg layout.footer
                , hero = mapPageHero toMsg layout.hero
                , backgroundColor = layout.backgroundColor
                }

        SidebarEdgeToEdgeLayout layout ->
            SidebarEdgeToEdgeLayout
                { content = PageContent.map toMsg layout.content
                , footer = mapPageFooter toMsg layout.footer
                , sidebar = Sidebar.map toMsg layout.sidebar
                , sidebarToggled = layout.sidebarToggled
                , operatingSystem = layout.operatingSystem
                , backgroundColor = layout.backgroundColor
                }

        SidebarLeftContentLayout layout ->
            SidebarLeftContentLayout
                { content = PageContent.map toMsg layout.content
                , footer = mapPageFooter toMsg layout.footer
                , sidebar = Sidebar.map toMsg layout.sidebar
                , sidebarToggled = layout.sidebarToggled
                , operatingSystem = layout.operatingSystem
                , backgroundColor = layout.backgroundColor
                }

        CenteredLayout layout ->
            CenteredLayout
                { content = PageContent.map toMsg layout.content
                , footer = mapPageFooter toMsg layout.footer
                , backgroundColor = layout.backgroundColor
                }

        CenteredNarrowLayout layout ->
            CenteredNarrowLayout
                { content = PageContent.map toMsg layout.content
                , footer = mapPageFooter toMsg layout.footer
                , backgroundColor = layout.backgroundColor
                }

        TabbedLayout layout ->
            TabbedLayout
                { pageTitle = PageTitle.map toMsg layout.pageTitle
                , tabList = TabList.map toMsg layout.tabList
                , content = PageContent.map toMsg layout.content
                , footer = mapPageFooter toMsg layout.footer
                , backgroundColor = layout.backgroundColor
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
                [ CopyrightYear.view
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
    let
        bgClassName bg =
            case bg of
                DefaultBackground ->
                    class "page_background_default"

                SubduedBackground ->
                    class "page_background_subdued"
    in
    case page of
        HeroLayout { hero, content, footer, backgroundColor } ->
            div [ class "page hero-layout", bgClassName backgroundColor ]
                [ viewPageHero hero
                , PageContent.view_ (viewPageFooter footer) content
                ]

        SidebarEdgeToEdgeLayout { sidebar, sidebarToggled, operatingSystem, content, backgroundColor } ->
            div
                [ class "page sidebar-edge-to-edge-layout"
                , classList [ ( "sidebar-toggled", sidebarToggled ) ]
                , bgClassName backgroundColor
                ]
                [ Sidebar.view operatingSystem sidebar
                , PageContent.view content
                ]

        SidebarLeftContentLayout { sidebar, sidebarToggled, operatingSystem, content, footer, backgroundColor } ->
            div
                [ class "page sidebar-left-content-layout"
                , classList [ ( "sidebar-toggled", sidebarToggled ) ]
                , bgClassName backgroundColor
                ]
                [ Sidebar.view operatingSystem sidebar
                , PageContent.view_ (viewPageFooter footer) content
                ]

        CenteredLayout { content, footer, backgroundColor } ->
            div
                [ class "page centered-layout"
                , bgClassName backgroundColor
                ]
                [ PageContent.view_ (viewPageFooter footer) content
                ]

        CenteredNarrowLayout { content, footer, backgroundColor } ->
            div
                [ class "page centered-narrow-layout"
                , bgClassName backgroundColor
                ]
                [ PageContent.view_ (viewPageFooter footer) content
                ]

        TabbedLayout { pageTitle, tabList, content, footer, backgroundColor } ->
            div
                [ class "page tabbed-layout"
                , bgClassName backgroundColor
                ]
                -- This is using the .page-content class to narrow the width of
                -- the header and the TabList
                [ header [ class "tabbed-layout_header" ]
                    [ div
                        [ class "tabbed-layout_width" ]
                        [ PageTitle.view pageTitle ]
                    ]
                , div [ class "tabbed-layout_tab-list" ]
                    [ div
                        [ class "tabbed-layout_width" ]
                        [ TabList.view tabList ]
                    ]
                , PageContent.view_ (viewPageFooter footer) content
                ]

        PresentationLayout content ->
            div [ class "page presentation-layout" ]
                [ PageContent.view_ (viewPageFooter (PageFooter [])) content
                ]
