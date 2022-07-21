module UI.AppHeader exposing (..)

import Html exposing (Html, a, header, section)
import Html.Attributes exposing (class, id)
import Html.Events exposing (onClick)
import Maybe.Extra as MaybeE
import UI
import UI.Click as Click exposing (Click)
import UI.Icon as Icon
import UI.Navigation as Navigation exposing (Navigation)
import UI.ViewMode as ViewMode exposing (ViewMode)


type AppTitle msg
    = AppTitle (Click msg) (Html msg)


type alias AppHeader msg =
    { menuToggle : Maybe msg
    , appTitle : AppTitle msg
    , navigation : Maybe (Navigation msg)
    , leftSide : List (Html msg)
    , rightSide : List (Html msg)
    , viewMode : ViewMode
    }


appHeader : AppTitle msg -> AppHeader msg
appHeader appTitle =
    { menuToggle = Nothing
    , appTitle = appTitle
    , navigation = Nothing
    , leftSide = []
    , rightSide = []
    , viewMode = ViewMode.Regular
    }


withNavigation : Navigation msg -> AppHeader msg -> AppHeader msg
withNavigation navigation appHeader_ =
    { appHeader_ | navigation = Just navigation }


withViewMode : ViewMode -> AppHeader msg -> AppHeader msg
withViewMode viewMode appHeader_ =
    { appHeader_ | viewMode = viewMode }



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
    in
    view_
        appHeader_.viewMode
        [ section [ class "toggle-and-title" ]
            [ menuToggle
            , viewAppTitle appHeader_.appTitle
            ]
        , MaybeE.unwrap UI.nothing Navigation.view appHeader_.navigation
        , section [ class "left-side" ] appHeader_.leftSide
        , section [ class "right-side" ] appHeader_.rightSide
        ]
