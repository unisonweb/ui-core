module UI.Form.SearchSelect exposing (..)

import Html exposing (Html, div, node, text)
import Html.Attributes exposing (class)
import Html.Events
import Json.Decode as Json
import Lib.Search as Search exposing (Search)
import Lib.SearchResults as SearchResults
import UI
import UI.Form.TextField as TextField
import UI.Icon as Icon
import UI.KeyboardShortcut.Key as Key
import UI.KeyboardShortcut.KeyboardEvent as KeyboardEvent


type alias QueryCompletion msg =
    { search : Search String
    , acceptMsg : String -> msg
    }


type SheetPosition
    = Above
    | Below


type alias SearchSelect a msg =
    { search : Search a
    , updateSearchMsg : Search a -> msg
    , selectMatchMsg : a -> msg
    , placeholder : Maybe String
    , emptyState : Maybe (Html msg)
    , autofocus : Bool
    , queryCompletion : Maybe (QueryCompletion msg)
    , sheetPosition : SheetPosition
    , maxResults : Maybe Int
    }



-- CREATE


empty : (Search a -> msg) -> (a -> msg) -> SearchSelect a msg
empty updateSearchMsg selectMatchMsg =
    searchSelect_ Search.empty updateSearchMsg selectMatchMsg Nothing


searchSelect : Search a -> (Search a -> msg) -> (a -> msg) -> SearchSelect a msg
searchSelect search onInput selectMatchMsg =
    searchSelect_ search onInput selectMatchMsg Nothing


searchSelect_ : Search a -> (Search a -> msg) -> (a -> msg) -> Maybe String -> SearchSelect a msg
searchSelect_ search updateSearchMsg selectMatchMsg placeholder =
    { search = search
    , updateSearchMsg = updateSearchMsg
    , selectMatchMsg = selectMatchMsg
    , placeholder = placeholder
    , autofocus = False
    , emptyState = Nothing
    , queryCompletion = Nothing
    , sheetPosition = Below
    , maxResults = Nothing
    }



-- MODIFY


withSearch : Search a -> SearchSelect a msg -> SearchSelect a msg
withSearch s select =
    { select | search = s }


withEmptyState : Html msg -> SearchSelect a msg -> SearchSelect a msg
withEmptyState emptyState select =
    { select | emptyState = Just emptyState }


withPlaceholder : String -> SearchSelect a msg -> SearchSelect a msg
withPlaceholder placeholder select =
    { select | placeholder = Just placeholder }


withAutofocus : SearchSelect a msg -> SearchSelect a msg
withAutofocus select =
    { select | autofocus = True }


withQueryCompletion : QueryCompletion msg -> SearchSelect a msg -> SearchSelect a msg
withQueryCompletion queryCompletion select =
    { select | queryCompletion = Just queryCompletion }


withSheetAbove : SearchSelect a msg -> SearchSelect a msg
withSheetAbove select =
    { select | sheetPosition = Above }


withMaxResults : Int -> SearchSelect a msg -> SearchSelect a msg
withMaxResults n select =
    { select | maxResults = Just n }


when : Bool -> (SearchSelect a msg -> SearchSelect a msg) -> SearchSelect a msg -> SearchSelect a msg
when condition f select =
    whenElse condition f identity select


whenMaybe : Maybe m -> (m -> SearchSelect a msg -> SearchSelect a msg) -> SearchSelect a msg -> SearchSelect a msg
whenMaybe maybe f select =
    case maybe of
        Just a ->
            f a select

        Nothing ->
            select


whenElse :
    Bool
    -> (SearchSelect a msg -> SearchSelect a msg)
    -> (SearchSelect a msg -> SearchSelect a msg)
    -> SearchSelect a msg
    -> SearchSelect a msg
whenElse condition f g select =
    if condition then
        f select

    else
        g select


whenNot : Bool -> (SearchSelect a msg -> SearchSelect a msg) -> SearchSelect a msg -> SearchSelect a msg
whenNot condition f select =
    when (not condition) f select



-- MAP


mapQueryCompletion : (msgA -> msgB) -> QueryCompletion msgA -> QueryCompletion msgB
mapQueryCompletion f comp =
    { search = comp.search
    , acceptMsg = comp.acceptMsg >> f
    }


map : (msgA -> msgB) -> SearchSelect a msgA -> SearchSelect a msgB
map f s =
    { search = s.search
    , updateSearchMsg = s.updateSearchMsg >> f
    , selectMatchMsg = s.selectMatchMsg >> f
    , placeholder = s.placeholder
    , autofocus = False
    , emptyState = Nothing
    , queryCompletion =
        Maybe.map (mapQueryCompletion f) s.queryCompletion
    , sheetPosition = s.sheetPosition
    , maxResults = s.maxResults
    }



-- VIEW


viewSheet : SheetPosition -> Maybe Int -> (a -> Bool -> Html msg) -> Html msg -> Search a -> Html msg
viewSheet position maxResults viewMatch emptyState search =
    let
        viewSheet_ r =
            let
                limited =
                    case maxResults of
                        Just n ->
                            SearchResults.take n r

                        Nothing ->
                            r
            in
            if SearchResults.isEmpty limited then
                div [ class "search-select_sheet" ] [ emptyState ]

            else
                let
                    matches =
                        SearchResults.mapToList viewMatch limited

                    orderedMatches =
                        case position of
                            Above ->
                                List.reverse matches

                            Below ->
                                matches
                in
                div [ class "search-select_sheet" ] orderedMatches
    in
    if Search.isNotAsked search then
        UI.nothing

    else
        Search.searchResults search
            |> Maybe.map viewSheet_
            |> Maybe.withDefault UI.nothing


viewDefaultEmptyState : Html msg
viewDefaultEmptyState =
    div [ class "search-select_sheet_empty-state" ] [ text "No matching results." ]


type alias Events msg =
    { inputMsg : String -> msg
    , clearMsg : msg
    , keyMsg :
        Json.Decoder
            { message : msg
            , stopPropagation : Bool
            , preventDefault : Bool
            }
    }


toEvents : SearchSelect a msg -> Events msg
toEvents select =
    let
        searchForCycling =
            case select.maxResults of
                Just n ->
                    Search.searchResultsTake n select.search

                Nothing ->
                    select.search

        keyMsg =
            let
                handle key =
                    case key of
                        Key.Enter ->
                            case Search.searchResultsFocus searchForCycling of
                                Just a ->
                                    Json.succeed
                                        { message = select.selectMatchMsg a
                                        , preventDefault = False
                                        , stopPropagation = False
                                        }

                                Nothing ->
                                    Json.fail "No search result focus"

                        Key.Tab ->
                            case select.queryCompletion of
                                Just { search, acceptMsg } ->
                                    Json.succeed
                                        { message = acceptMsg (Search.query search)
                                        , preventDefault = True
                                        , stopPropagation = False
                                        }

                                Nothing ->
                                    Json.fail "No query completion configuration"

                        Key.ArrowUp ->
                            let
                                cycled =
                                    case select.sheetPosition of
                                        Above ->
                                            Search.searchResultsCycleNext searchForCycling

                                        Below ->
                                            Search.searchResultsCyclePrev searchForCycling
                            in
                            Json.succeed
                                { message = select.updateSearchMsg cycled
                                , preventDefault = False
                                , stopPropagation = False
                                }

                        Key.ArrowDown ->
                            let
                                cycled =
                                    case select.sheetPosition of
                                        Above ->
                                            Search.searchResultsCyclePrev searchForCycling

                                        Below ->
                                            Search.searchResultsCycleNext searchForCycling
                            in
                            Json.succeed
                                { message = select.updateSearchMsg cycled
                                , preventDefault = False
                                , stopPropagation = False
                                }

                        _ ->
                            Json.fail "unhandled key"
            in
            Json.andThen handle KeyboardEvent.decodeKey
    in
    { inputMsg =
        \value ->
            select.search
                |> Search.withQuery value
                |> select.updateSearchMsg
    , clearMsg =
        select.search
            |> Search.reset
            |> select.updateSearchMsg
    , keyMsg = keyMsg
    }


view : (a -> Bool -> Html msg) -> SearchSelect a msg -> Html msg
view viewMatch select =
    let
        events =
            toEvents select

        ghostText_ =
            select.queryCompletion
                |> Maybe.andThen (\qc -> Search.searchResultsFocus qc.search)

        textField =
            TextField.field_ events.inputMsg
                Nothing
                select.placeholder
                (Search.query select.search)
                |> TextField.withIconOrWorking Icon.search (Search.isSearching select.search)
                |> TextField.withClear events.clearMsg
                |> TextField.when select.autofocus TextField.withAutofocus
                |> TextField.whenMaybe ghostText_ TextField.withGhostText
                |> TextField.view

        emptyState =
            Maybe.withDefault viewDefaultEmptyState select.emptyState

        searchSheet =
            viewSheet select.sheetPosition select.maxResults viewMatch emptyState select.search

        ( positionClass, innerChildren ) =
            case select.sheetPosition of
                Above ->
                    ( "search-select sheet-above", [ searchSheet, textField ] )

                Below ->
                    ( "search-select sheet-below", [ textField, searchSheet ] )
    in
    node "search"
        [ class positionClass, Html.Events.custom "keydown" events.keyMsg ]
        [ div [ class "search-select_inner" ]
            innerChildren
        ]
