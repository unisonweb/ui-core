module Lib.Search exposing
    ( Search(..)
    , SearchDebounce
    , debounce
    , debounce_
    , empty
    , fromResult
    , query
    , queryEquals
    , reset
    , search
    , searchDebounce
    , searchResults
    , toFailure
    , toSearching
    , toSuccess
    , updateQuery
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


fromResult : HttpResult (List a) -> Search a -> Search a
fromResult result search_ =
    case result of
        Ok r ->
            Success (query search_) (SearchResults.fromList r)

        Err e ->
            Failure (query search_) e


queryEquals : Search a -> Search a -> Bool
queryEquals a b =
    query a == query b


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


updateQuery : Search a -> String -> Search a
updateQuery search_ q =
    case search_ of
        NotAsked _ ->
            NotAsked q

        Searching _ r ->
            Searching q r

        Success _ r ->
            Success q r

        Failure _ e ->
            Failure q e


debounce : msg -> Cmd msg
debounce performMsg =
    debounce_ performMsg searchDebounce


debounce_ : msg -> SearchDebounce -> Cmd msg
debounce_ performMsg (SearchDebounce ms) =
    Util.delayMsg ms performMsg
