module UI.PageHeader exposing (..)

import Html exposing (Html, div, header)
import Html.Attributes exposing (class, classList)
import UI
import UI.AnchoredOverlay as AnchoredOverlay
import UI.Button as Button
import UI.Click as Click exposing (Click)
import UI.Icon as Icon
import UI.Navigation as Nav exposing (Navigation)
import UI.ViewMode as ViewMode exposing (ViewMode)


type alias PageContext msg =
    { isActive : Bool
    , content : Html msg
    , click : Maybe (Click msg)
    }


type alias NavigationConfig msg =
    { navigation : Navigation msg
    , mobileNavToggleMsg : msg
    , mobileNavIsOpen : Bool
    }


type PageHeaderNav msg
    = NoNav
    | PageHeaderNav (NavigationConfig msg)


type alias PageHeader msg =
    { context : PageContext msg
    , navigation : PageHeaderNav msg
    , rightSide : List (Html msg)
    , viewMode : ViewMode
    }



-- CREATE


pageHeader : PageContext msg -> PageHeader msg
pageHeader ctx =
    { context = ctx
    , navigation = NoNav
    , rightSide = []
    , viewMode = ViewMode.Regular
    }


empty : PageHeader msg
empty =
    let
        context =
            { isActive = False
            , click = Nothing
            , content = UI.nothing
            }
    in
    pageHeader context



-- MODIFY


withNavigation : NavigationConfig msg -> PageHeader msg -> PageHeader msg
withNavigation navigation pageHeader_ =
    { pageHeader_ | navigation = PageHeaderNav navigation }


withViewMode : ViewMode -> PageHeader msg -> PageHeader msg
withViewMode viewMode pageHeader_ =
    { pageHeader_ | viewMode = viewMode }


withRightSide : List (Html msg) -> PageHeader msg -> PageHeader msg
withRightSide rightSide pageHeader_ =
    { pageHeader_ | rightSide = rightSide }



-- MAP


mapPageContext : (a -> msg) -> PageContext a -> PageContext msg
mapPageContext toMsg contextA =
    { isActive = contextA.isActive
    , content = Html.map toMsg contextA.content
    , click = Maybe.map (Click.map toMsg) contextA.click
    }


mapPageHeaderNav : (a -> msg) -> PageHeaderNav a -> PageHeaderNav msg
mapPageHeaderNav toMsg pageNav =
    case pageNav of
        NoNav ->
            NoNav

        PageHeaderNav cfg ->
            PageHeaderNav
                { navigation = Nav.map toMsg cfg.navigation
                , mobileNavToggleMsg = toMsg cfg.mobileNavToggleMsg
                , mobileNavIsOpen = cfg.mobileNavIsOpen
                }


map : (a -> msg) -> PageHeader a -> PageHeader msg
map toMsg headerA =
    { context = mapPageContext toMsg headerA.context
    , navigation = mapPageHeaderNav toMsg headerA.navigation
    , rightSide = List.map (Html.map toMsg) headerA.rightSide
    , viewMode = headerA.viewMode
    }



-- VIEW


viewPageContext : PageContext msg -> Html msg
viewPageContext { click, isActive, content } =
    let
        attrs =
            [ classList [ ( "page-header_page-context", True ), ( "page-header_page-context_is-active", isActive ) ]
            ]
    in
    case click of
        Nothing ->
            div attrs [ content ]

        Just c ->
            Click.view attrs [ content ] c


viewMobileNav : NavigationConfig msg -> Html msg
viewMobileNav cfg =
    let
        button =
            Button.icon cfg.mobileNavToggleMsg Icon.dots
                |> Button.subdued
                |> Button.withIsActive cfg.mobileNavIsOpen
                |> Button.view

        anchoredOverlay_ =
            AnchoredOverlay.anchoredOverlay
                cfg.mobileNavToggleMsg
                button

        sheet =
            AnchoredOverlay.customSheet (Nav.view cfg.navigation)

        anchoredOverlay =
            if cfg.mobileNavIsOpen then
                anchoredOverlay_
                    |> AnchoredOverlay.withSheet sheet

            else
                anchoredOverlay_
    in
    div [ class "max-md mobile-nav" ]
        [ anchoredOverlay
            |> AnchoredOverlay.view
        ]


viewRightSide : Html msg -> List (Html msg) -> Html msg
viewRightSide mobileNav items =
    case items of
        [] ->
            div [ class "page-header_right-side" ]
                [ mobileNav
                ]

        items_ ->
            div [ class "page-header_right-side" ]
                [ div [ class "min-md" ] items_
                , mobileNav
                ]


view : PageHeader msg -> Html msg
view pageHeader_ =
    let
        ( nav, mobileNav ) =
            case pageHeader_.navigation of
                PageHeaderNav n ->
                    let
                        selectedItem =
                            case Nav.selected n.navigation of
                                Just navItem ->
                                    div [ class "max-md" ]
                                        [ Nav.empty
                                            |> Nav.withItems [] navItem []
                                            |> Nav.view
                                        ]

                                Nothing ->
                                    UI.nothing
                    in
                    ( div [ class "page-header_navigation" ]
                        [ div [ class "min-md" ] [ Nav.view n.navigation ]
                        , selectedItem
                        ]
                    , viewMobileNav n
                    )

                NoNav ->
                    ( UI.nothing, UI.nothing )
    in
    header
        [ class "page-header"
        , class (ViewMode.toCssClass pageHeader_.viewMode)
        ]
        [ viewPageContext pageHeader_.context
        , nav
        , viewRightSide mobileNav pageHeader_.rightSide
        ]
