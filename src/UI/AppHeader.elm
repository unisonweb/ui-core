module UI.AppHeader exposing (..)

import Html exposing (Html, a, div, header, section)
import Html.Attributes exposing (class, id)
import Html.Events exposing (onClick)
import UI
import UI.Click as Click exposing (Click)
import UI.Icon as Icon
import UI.Navigation as Navigation exposing (Navigation)
import UI.ViewMode as ViewMode exposing (ViewMode)


type AppTitle msg
    = AppTitle (Click msg) (Html msg)


type AppNav msg
    = NoAppNav
    | AppNav (Navigation msg)
    | AppNavDesktopOnly (Navigation msg)


type alias AppHeader msg =
    { menuToggle : Maybe msg
    , appTitle : AppTitle msg
    , navigation : AppNav msg
    , leftSide : List (Html msg)
    , rightSide : List (Html msg)
    , viewMode : ViewMode
    }


appHeader : AppTitle msg -> AppHeader msg
appHeader appTitle =
    { menuToggle = Nothing
    , appTitle = appTitle
    , navigation = NoAppNav
    , leftSide = []
    , rightSide = []
    , viewMode = ViewMode.Regular
    }


withNavigation : Navigation msg -> AppHeader msg -> AppHeader msg
withNavigation navigation appHeader_ =
    { appHeader_ | navigation = AppNav navigation }


withDesktopOnlyNavigation : Navigation msg -> AppHeader msg -> AppHeader msg
withDesktopOnlyNavigation navigation appHeader_ =
    { appHeader_ | navigation = AppNavDesktopOnly navigation }


withViewMode : ViewMode -> AppHeader msg -> AppHeader msg
withViewMode viewMode appHeader_ =
    { appHeader_ | viewMode = viewMode }


withMenuToggle : msg -> AppHeader msg -> AppHeader msg
withMenuToggle menuToggleMsg appHeader_ =
    withMenuToggle_ (Just menuToggleMsg) appHeader_


withMenuToggle_ : Maybe msg -> AppHeader msg -> AppHeader msg
withMenuToggle_ menuToggleMsg appHeader_ =
    { appHeader_ | menuToggle = menuToggleMsg }


withLeftSide : List (Html msg) -> AppHeader msg -> AppHeader msg
withLeftSide leftSide appHeader_ =
    { appHeader_ | leftSide = leftSide }


withRightSide : List (Html msg) -> AppHeader msg -> AppHeader msg
withRightSide rightSide appHeader_ =
    { appHeader_ | rightSide = rightSide }



-- VIEW


mapAppTitle : (a -> b) -> AppTitle a -> AppTitle b
mapAppTitle f (AppTitle click content) =
    AppTitle (Click.map f click) (Html.map f content)


mapAppNav : (a -> b) -> AppNav a -> AppNav b
mapAppNav f nav =
    case nav of
        NoAppNav ->
            NoAppNav

        AppNav nav_ ->
            AppNav (Navigation.map f nav_)

        AppNavDesktopOnly nav_ ->
            AppNavDesktopOnly (Navigation.map f nav_)


map : (a -> b) -> AppHeader a -> AppHeader b
map f appHeader_ =
    { menuToggle = Maybe.map f appHeader_.menuToggle
    , appTitle = mapAppTitle f appHeader_.appTitle
    , navigation = mapAppNav f appHeader_.navigation
    , leftSide = List.map (Html.map f) appHeader_.leftSide
    , rightSide = List.map (Html.map f) appHeader_.rightSide
    , viewMode = appHeader_.viewMode
    }



-- VIEW


viewAppTitle : AppTitle msg -> Html msg
viewAppTitle (AppTitle click content) =
    Click.view [ class "app-title" ] [ content ] click


view_ : ViewMode -> List (Html msg) -> Html msg
view_ viewMode content =
    header [ id "app-header", class (ViewMode.toCssClass viewMode) ] content


view : AppHeader msg -> Html msg
view appHeader_ =
    let
        menuToggle =
            case appHeader_.menuToggle of
                Nothing ->
                    UI.nothing

                Just toggle ->
                    a
                        [ class "menu-toggle", onClick toggle ]
                        [ Icon.view Icon.list ]

        appNav =
            case appHeader_.navigation of
                NoAppNav ->
                    UI.nothing

                AppNav nav ->
                    Navigation.view nav

                AppNavDesktopOnly nav ->
                    div [ class "min-sm" ] [ Navigation.view nav ]
    in
    view_
        appHeader_.viewMode
        [ section [ class "toggle-and-title" ]
            [ menuToggle
            , viewAppTitle appHeader_.appTitle
            ]
        , appNav
        , section [ class "left-side" ] appHeader_.leftSide
        , section [ class "right-side" ] appHeader_.rightSide
        ]
