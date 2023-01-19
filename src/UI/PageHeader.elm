module UI.PageHeader exposing (..)

import Html exposing (Html, div, header)
import Html.Attributes exposing (class, classList)
import Maybe.Extra as MaybeE
import UI
import UI.Click as Click exposing (Click)
import UI.Navigation as Nav exposing (Navigation)
import UI.ViewMode as ViewMode exposing (ViewMode)


type alias PageContext msg =
    { isActive : Bool
    , content : Html msg
    , click : Maybe (Click msg)
    }


type alias PageHeader msg =
    { context : PageContext msg
    , navigation : Maybe (Navigation msg)
    , rightSide : List (Html msg)
    , viewMode : ViewMode
    }



-- CREATE


pageHeader : PageContext msg -> PageHeader msg
pageHeader ctx =
    { context = ctx
    , navigation = Nothing
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


withNavigation : Navigation msg -> PageHeader msg -> PageHeader msg
withNavigation navigation pageHeader_ =
    { pageHeader_ | navigation = Just navigation }


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


map : (a -> msg) -> PageHeader a -> PageHeader msg
map toMsg headerA =
    { context = mapPageContext toMsg headerA.context
    , navigation = Maybe.map (Nav.map toMsg) headerA.navigation
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


viewRightSide : List (Html msg) -> Html msg
viewRightSide items =
    case items of
        [] ->
            UI.nothing

        items_ ->
            div [ class "page-header_right-side" ] items_


view : PageHeader msg -> Html msg
view pageHeader_ =
    header
        [ class "page-header"
        , class (ViewMode.toCssClass pageHeader_.viewMode)
        ]
        [ viewPageContext pageHeader_.context
        , MaybeE.unwrap UI.nothing Nav.view pageHeader_.navigation
        , viewRightSide pageHeader_.rightSide
        ]
