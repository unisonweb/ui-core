{- Quite similar to Lib.Search, but supports multiple search requests being
   merged into 1 result

   TODO: Consider merging Lib.Search and Lib.MultiSearch? Presumably, the
   Lib.Search functionality could be covered entirely by some helper functions
   in Lib.MultiSearch

-}


module Lib.MultiSearch exposing
    ( MultiSearch(..)
    , SearchDebounce
    , debounce
    , debounce_
    , empty
    , fromList
    , fromResult
    , fromResult_
    , hasSubstantialQuery
    , isEmptyQuery
    , isEmptyResults
    , isSearching
    , length
    , mapSearchResults
    , multiSearch
    , queriesEquals
    , query
    , queryEquals
    , queryGreaterThan
    , reset
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

import Dict exposing (Dict)
import Http
import Lib.HttpApi exposing (HttpResult)
import Lib.SearchResults as SearchResults exposing (SearchResults)
import Lib.Util as Util
import Maybe.Extra as MaybeE
import RemoteData exposing (WebData)


type SearchDebounce
    = SearchDebounce Float


searchDebounce : SearchDebounce
searchDebounce =
    SearchDebounce 300


type alias SearchRequests a =
    Dict String (WebData (List a))


type MultiSearch a
    = NotAsked String
    | Searching
        { query : String
        , requests : SearchRequests a
        , previous : Maybe (SearchResults a)
        }
    | Success String (SearchResults a)
    | Failure
        { query : String
        , requests : SearchRequests a
        }



-- CREATE


empty : MultiSearch a
empty =
    multiSearch ""


multiSearch : String -> MultiSearch a
multiSearch query_ =
    NotAsked query_


fromList : String -> List a -> MultiSearch a
fromList q matches =
    Success q (SearchResults.fromList matches)



-- TRANSFORM


reset : MultiSearch a -> MultiSearch a
reset _ =
    empty


toSearching : String -> MultiSearch a -> MultiSearch a
toSearching key search_ =
    let
        requests =
            Dict.singleton key RemoteData.Loading
    in
    case search_ of
        NotAsked q ->
            Searching
                { query = q
                , requests = requests
                , previous = Nothing
                }

        Searching searching_ ->
            Searching
                { searching_
                    | requests = Dict.insert key RemoteData.Loading searching_.requests
                }

        Success q r ->
            Searching
                { query = q
                , requests = requests
                , previous = Just r
                }

        Failure failure_ ->
            Searching
                { query = failure_.query
                , requests = requests
                , previous = Nothing
                }


toSuccess : SearchResults a -> MultiSearch a -> MultiSearch a
toSuccess results search_ =
    Success (query search_) results


toFailure : String -> Http.Error -> MultiSearch a -> MultiSearch a
toFailure key error search_ =
    case search_ of
        Failure failure_ ->
            Failure { failure_ | requests = Dict.insert key (RemoteData.Failure error) failure_.requests }

        _ ->
            Failure { query = query search_, requests = Dict.singleton key (RemoteData.Failure error) }


withQuery : String -> MultiSearch a -> MultiSearch a
withQuery q search_ =
    case search_ of
        NotAsked _ ->
            NotAsked q

        Searching searching_ ->
            Searching { searching_ | query = q }

        Success _ r ->
            Success q r

        Failure failure_ ->
            Failure { failure_ | query = q }



-- HELPERS


searchResults : MultiSearch a -> Maybe (SearchResults a)
searchResults search_ =
    case search_ of
        Searching searching_ ->
            searching_.previous

        Success _ r ->
            Just r

        _ ->
            Nothing


mapSearchResults : (SearchResults a -> SearchResults a) -> MultiSearch a -> MultiSearch a
mapSearchResults f search_ =
    case search_ of
        Searching searching_ ->
            case searching_.previous of
                Just results ->
                    Searching { searching_ | previous = Just (f results) }

                Nothing ->
                    search_

        Success q r ->
            Success q (f r)

        _ ->
            search_


fromResult : String -> HttpResult (List a) -> MultiSearch a -> MultiSearch a
fromResult key result search_ =
    fromResult_ compare key result search_


fromResult_ : (String -> String -> Order) -> String -> HttpResult (List a) -> MultiSearch a -> MultiSearch a
fromResult_ sorter key result search_ =
    case ( result, search_ ) of
        ( Ok r, Searching searching_ ) ->
            let
                requests_ =
                    searching_.requests
                        |> Dict.insert key (RemoteData.Success r)

                finishedRequests : Maybe (List a)
                finishedRequests =
                    requests_
                        |> Dict.toList
                        |> List.sortWith (\( ka, _ ) ( kb, _ ) -> sorter ka kb)
                        |> List.map (Tuple.second >> RemoteData.toMaybe)
                        |> MaybeE.combine
                        |> Maybe.map List.concat
            in
            case finishedRequests of
                Just items ->
                    Success (query search_) (SearchResults.fromList items)

                Nothing ->
                    Searching { searching_ | requests = requests_ }

        ( Ok r, _ ) ->
            Success (query search_) (SearchResults.fromList r)

        ( Err e, Searching searching_ ) ->
            let
                requests_ =
                    searching_.requests
                        |> Dict.insert key (RemoteData.Failure e)
            in
            Failure { query = query search_, requests = requests_ }

        ( Err e, _ ) ->
            let
                requests_ =
                    Dict.singleton key (RemoteData.Failure e)
            in
            Failure { query = query search_, requests = requests_ }


queryEquals : String -> MultiSearch a -> Bool
queryEquals q s =
    q == query s


queriesEquals : MultiSearch a -> MultiSearch a -> Bool
queriesEquals a b =
    query a == query b


queryGreaterThan : Int -> MultiSearch a -> Bool
queryGreaterThan n s =
    String.length (query s) > n


hasSubstantialQuery : MultiSearch a -> Bool
hasSubstantialQuery s =
    queryGreaterThan 2 s


query : MultiSearch a -> String
query search_ =
    case search_ of
        NotAsked q ->
            q

        Searching s ->
            s.query

        Success q _ ->
            q

        Failure f ->
            f.query


isEmptyQuery : MultiSearch a -> Bool
isEmptyQuery =
    query >> String.isEmpty


length : MultiSearch a -> Maybe Int
length s =
    case s of
        NotAsked _ ->
            Nothing

        Searching s_ ->
            s_.requests
                |> Dict.toList
                |> List.map (Tuple.second >> RemoteData.map List.length >> RemoteData.withDefault 0)
                |> List.sum
                |> Just

        Success _ r ->
            Just (SearchResults.length r)

        Failure _ ->
            Nothing


isEmptyResults : MultiSearch a -> Maybe Bool
isEmptyResults s =
    case s of
        NotAsked _ ->
            Nothing

        Searching s_ ->
            s_.previous
                |> Maybe.map SearchResults.isEmpty

        Success _ r ->
            Just (SearchResults.isEmpty r)

        Failure _ ->
            Nothing


isSearching : MultiSearch a -> Bool
isSearching search_ =
    case search_ of
        Searching _ ->
            True

        _ ->
            False


searchResultsFocus : MultiSearch a -> Maybe a
searchResultsFocus s =
    case s of
        Success _ r ->
            SearchResults.focus r

        _ ->
            Nothing


searchResultsPrev : MultiSearch a -> MultiSearch a
searchResultsPrev s =
    case s of
        Success q r ->
            Success q (SearchResults.prev r)

        _ ->
            s


searchResultsCyclePrev : MultiSearch a -> MultiSearch a
searchResultsCyclePrev s =
    case s of
        Success q r ->
            Success q (SearchResults.cyclePrev r)

        _ ->
            s


searchResultsNext : MultiSearch a -> MultiSearch a
searchResultsNext s =
    case s of
        Success q r ->
            Success q (SearchResults.next r)

        _ ->
            s


searchResultsCycleNext : MultiSearch a -> MultiSearch a
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
