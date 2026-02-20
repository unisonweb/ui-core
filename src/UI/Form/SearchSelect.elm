module UI.Form.SearchSelect exposing (..)

import Html exposing (Html, div, node, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onInput)
import Json.Decode as Json
import Lib.Search as Search exposing (Search)
import Lib.SearchResults as SearchResults
import UI
import UI.Click as Click
import UI.Form.TextField as TextField
import UI.Icon as Icon
import UI.KeyboardShortcut.Key as Key
import UI.KeyboardShortcut.KeyboardEvent as KeyboardEvent


type alias SearchSelect a msg =
    { search : Search a
    , updateSearchMsg : Search a -> msg
    , selectMatchMsg : a -> msg
    , placeholder : Maybe String
    , emptyState : Maybe (Html msg)
    , autofocus : Bool
    , value : String
    }



-- CREATE


empty : (Search a -> msg) -> (a -> msg) -> String -> SearchSelect a msg
empty updateSearchMsg selectMatchMsg value =
    searchSelect_ Search.empty updateSearchMsg selectMatchMsg Nothing value


searchSelect : Search a -> (Search a -> msg) -> (a -> msg) -> String -> SearchSelect a msg
searchSelect search onInput selectMatchMsg value =
    searchSelect_ search onInput selectMatchMsg Nothing value


searchSelect_ : Search a -> (Search a -> msg) -> (a -> msg) -> Maybe String -> String -> SearchSelect a msg
searchSelect_ search updateSearchMsg selectMatchMsg placeholder value =
    { search = search
    , updateSearchMsg = updateSearchMsg
    , selectMatchMsg = selectMatchMsg
    , placeholder = placeholder
    , autofocus = False
    , value = value
    , emptyState = Nothing
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


when : Bool -> (SearchSelect a msg -> SearchSelect a msg) -> SearchSelect a msg -> SearchSelect a msg
when condition f select =
    whenElse condition f identity select


whenMaybe : Maybe a -> (a -> SearchSelect a msg -> SearchSelect a msg) -> SearchSelect a msg -> SearchSelect a msg
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


map : (msgA -> msgB) -> SearchSelect a msgA -> SearchSelect a msgB
map f s =
    { search = s.search
    , updateSearchMsg = s.updateSearchMsg >> f
    , selectMatchMsg = s.selectMatchMsg >> f
    , placeholder = s.placeholder
    , autofocus = False
    , value = s.value
    , emptyState = Nothing
    }



-- VIEW


viewSheet : (a -> Bool -> Html msg) -> Html msg -> Search a -> Html msg
viewSheet viewMatch emptyState search =
    let
        viewSheet_ r =
            if SearchResults.isEmpty r then
                div [ class "search-select_sheet" ] [ emptyState ]

            else
                div [ class "search-select_sheet" ]
                    (SearchResults.mapToList viewMatch r)
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


type alias Events a msg =
    { matchClickMsg : a -> msg
    , inputMsg : String -> msg
    , clearMsg : msg
    , keyMsg :
        Json.Decoder
            { message : msg
            , stopPropagation : Bool
            , preventDefault : Bool
            }
    }


toEvents : SearchSelect a msg -> Events a msg
toEvents select =
    let
        keyMsg =
            let
                handle key =
                    case key of
                        Key.Enter ->
                            case Search.searchResultsFocus select.search of
                                Just a ->
                                    Json.succeed
                                        { message = select.selectMatchMsg a
                                        , preventDefault = False
                                        , stopPropagation = False
                                        }

                                Nothing ->
                                    Json.fail "No search result focus"

                        Key.ArrowUp ->
                            Json.succeed
                                { message = select.updateSearchMsg (Search.searchResultsCyclePrev select.search)
                                , preventDefault = False
                                , stopPropagation = False
                                }

                        Key.ArrowDown ->
                            Json.succeed
                                { message = select.updateSearchMsg (Search.searchResultsCycleNext select.search)
                                , preventDefault = False
                                , stopPropagation = False
                                }

                        _ ->
                            Json.fail "unhandled key"
            in
            Json.andThen handle KeyboardEvent.decodeKey
    in
    { matchClickMsg = select.selectMatchMsg
    , inputMsg =
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

        textField =
            TextField.field_ events.inputMsg
                Nothing
                select.placeholder
                (Search.query select.search)
                |> TextField.withIconOrWorking Icon.search (Search.isSearching select.search)
                |> TextField.withClear events.clearMsg
                |> TextField.when select.autofocus TextField.withAutofocus
                |> TextField.view

        emptyState =
            Maybe.withDefault viewDefaultEmptyState select.emptyState

        searchSheet =
            viewSheet viewMatch emptyState select.search
    in
    node "search"
        [ Html.Events.custom "keydown" events.keyMsg ]
        [ textField
        , searchSheet
        ]
