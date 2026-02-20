module Lib.Search exposing
    ( Search(..)
    , SearchDebounce
    , debounce
    , debounce_
    , empty
    , fromList
    , fromResult
    , hasSubstantialQuery
    , isEmptyQuery
    , isEmptyResults
    , isNotAsked
    , isSearching
    , length
    , queriesEquals
    , query
    , queryEquals
    , queryGreaterThan
    , reset
    , search
    , searchDebounce
    , searchResults
    , searchResultsCycleNext
    , searchResultsCyclePrev
    , searchResultsFocus
    , searchResultsNext
    , searchResultsPrev
    , toFailure
    , toSearching
    , toSuccess
    , withQuery
    )

import Http
import Lib.HttpApi exposing (HttpResult)
import Lib.SearchResults as SearchResults exposing (SearchResults)
import Lib.Util as Util


type SearchDebounce
    = SearchDebounce Float


searchDebounce : SearchDebounce
searchDebounce =
    SearchDebounce 300


type Search a
    = NotAsked String
    | Searching String (Maybe (SearchResults a))
    | Success String (SearchResults a)
    | Failure String Http.Error



-- CREATE


empty : Search a
empty =
    search ""


search : String -> Search a
search query_ =
    NotAsked query_


fromList : String -> List a -> Search a
fromList q matches =
    Success q (SearchResults.fromList matches)



-- TRANSFORM


reset : Search a -> Search a
reset _ =
    empty


toSearching : Search a -> Search a
toSearching search_ =
    case search_ of
        NotAsked q ->
            Searching q Nothing

        Searching q r ->
            Searching q r

        Success q r ->
            Searching q (Just r)

        Failure q _ ->
            Searching q Nothing


toSuccess : SearchResults a -> Search a -> Search a
toSuccess results search_ =
    Success (query search_) results


toFailure : Http.Error -> Search a -> Search a
toFailure error search_ =
    Failure (query search_) error


withQuery : String -> Search a -> Search a
withQuery q search_ =
    case search_ of
        NotAsked _ ->
            NotAsked q

        Searching _ r ->
            Searching q r

        Success _ r ->
            Success q r

        Failure _ e ->
            Failure q e



-- HELPERS


searchResults : Search a -> Maybe (SearchResults a)
searchResults search_ =
    case search_ of
        Searching _ r ->
            r

        Success _ r ->
            Just r

        _ ->
            Nothing


fromResult : Search a -> HttpResult (List a) -> Search a
fromResult search_ result =
    case result of
        Ok r ->
            Success (query search_) (SearchResults.fromList r)

        Err e ->
            Failure (query search_) e


queryEquals : String -> Search a -> Bool
queryEquals q s =
    q == query s


queriesEquals : Search a -> Search a -> Bool
queriesEquals a b =
    query a == query b


queryGreaterThan : Int -> Search a -> Bool
queryGreaterThan n s =
    String.length (query s) > n


hasSubstantialQuery : Search a -> Bool
hasSubstantialQuery s =
    queryGreaterThan 2 s


query : Search a -> String
query search_ =
    case search_ of
        NotAsked q ->
            q

        Searching q _ ->
            q

        Success q _ ->
            q

        Failure q _ ->
            q


isNotAsked : Search a -> Bool
isNotAsked s =
    case s of
        NotAsked _ ->
            True

        _ ->
            False


isEmptyQuery : Search a -> Bool
isEmptyQuery =
    query >> String.isEmpty


length : Search a -> Maybe Int
length s =
    case s of
        NotAsked _ ->
            Nothing

        Searching _ (Just r) ->
            Just (SearchResults.length r)

        Searching _ Nothing ->
            Nothing

        Success _ r ->
            Just (SearchResults.length r)

        Failure _ _ ->
            Nothing


isEmptyResults : Search a -> Maybe Bool
isEmptyResults s =
    case s of
        NotAsked _ ->
            Nothing

        Searching _ (Just r) ->
            Just (SearchResults.isEmpty r)

        Searching _ Nothing ->
            Nothing

        Success _ r ->
            Just (SearchResults.isEmpty r)

        Failure _ _ ->
            Nothing


isSearching : Search a -> Bool
isSearching search_ =
    case search_ of
        Searching _ _ ->
            True

        _ ->
            False


searchResultsFocus : Search a -> Maybe a
searchResultsFocus s =
    case s of
        Success _ r ->
            SearchResults.focus r

        _ ->
            Nothing


searchResultsPrev : Search a -> Search a
searchResultsPrev s =
    case s of
        Success q r ->
            Success q (SearchResults.prev r)

        _ ->
            s


searchResultsCyclePrev : Search a -> Search a
searchResultsCyclePrev s =
    case s of
        Success q r ->
            Success q (SearchResults.cyclePrev r)

        _ ->
            s


searchResultsNext : Search a -> Search a
searchResultsNext s =
    case s of
        Success q r ->
            Success q (SearchResults.next r)

        _ ->
            s


searchResultsCycleNext : Search a -> Search a
searchResultsCycleNext s =
    case s of
        Success q r ->
            Success q (SearchResults.cycleNext r)

        _ ->
            s


debounce : msg -> Cmd msg
debounce performMsg =
    debounce_ performMsg searchDebounce


debounce_ : msg -> SearchDebounce -> Cmd msg
debounce_ performMsg (SearchDebounce ms) =
    Util.delayMsg ms performMsg
