module UI.PageLayout exposing (..)

import Html exposing (Html, div, h1, header, p, section, text)
import Html.Attributes exposing (class, classList)
import UI.Icon as Icon exposing (Icon)
import UI.Sidebar as Sidebar


type PageHero msg
    = PageHero (Html msg)


type alias PageHeading msg =
    { icon : Maybe (Icon msg)
    , heading : String
    , description : Maybe String
    }


type PageContent msg
    = PageContent
        { heading : Maybe (PageHeading msg)
        , content : List (Html msg)
        }


type PageLayout msg
    = HeroLayout
        { hero : PageHero msg
        , content :
            PageContent msg
        }
    | SidebarLayout
        { sidebar : List (Html msg)
        , sidebarToggled : Bool
        , content : PageContent msg
        }
    | CenteredLayout { content : PageContent msg }
    | EdgeToEdgeLayout { content : PageContent msg }



-- VIEW


viewHero : PageHero msg -> Html msg
viewHero (PageHero content) =
    header [ class "page-hero" ] [ content ]


viewHeading : PageHeading msg -> Html msg
viewHeading { icon, heading, description } =
    let
        items =
            case ( icon, description ) of
                ( Nothing, Nothing ) ->
                    [ h1 [] [ text heading ] ]

                ( Nothing, Just d ) ->
                    [ div [ class "text" ]
                        [ h1 [] [ text heading ]
                        , p [ class "description" ] [ text d ]
                        ]
                    ]

                ( Just i, Nothing ) ->
                    [ Icon.view i
                    , h1 [] [ text heading ]
                    ]

                ( Just i, Just d ) ->
                    [ Icon.view i
                    , div [ class "text" ]
                        [ h1 [] [ text heading ]
                        , p [ class "description" ] [ text d ]
                        ]
                    ]
    in
    header [ class "page-heading" ] items


viewContent : PageContent msg -> Html msg
viewContent (PageContent { heading, content }) =
    let
        items =
            case heading of
                Just h ->
                    viewHeading h :: content

                Nothing ->
                    content
    in
    section [ class "page-content" ] items


view : PageLayout msg -> Html msg
view page =
    case page of
        HeroLayout { hero, content } ->
            div [ class "page hero-layout" ]
                [ viewHero hero
                , viewContent content
                ]

        SidebarLayout { sidebar, sidebarToggled, content } ->
            div
                [ class "page sidebar-layout"
                , classList [ ( "sidebar-toggled", sidebarToggled ) ]
                ]
                [ Sidebar.view sidebar
                , viewContent content
                ]

        CenteredLayout { content } ->
            div [ class "page centered-layout" ]
                [ viewContent content
                ]

        EdgeToEdgeLayout { content } ->
            div [ class "page edge-to-edge-layout" ]
                [ viewContent content
                ]
