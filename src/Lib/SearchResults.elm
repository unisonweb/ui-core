module Lib.SearchResults exposing
    ( Matches
    , SearchResults(..)
    , cycleNext
    , cyclePrev
    , empty
    , focus
    , focusOn
    , from
    , fromList
    , getAt
    , isEmpty
    , length
    , map
    , mapMatchesToList
    , mapToList
    , matchesToList
    , next
    , prev
    , toList
    , toMaybe
    )

import List.Extra as ListE
import List.Zipper as Zipper exposing (Zipper)
import Maybe.Extra exposing (unwrap)



-- SEARCH RESULT


type SearchResults a
    = Empty
    | SearchResults (Matches a)


empty : SearchResults a
empty =
    Empty


isEmpty : SearchResults a -> Bool
isEmpty results =
    case results of
        Empty ->
            True

        SearchResults _ ->
            False


fromList : List a -> SearchResults a
fromList data =
    unwrap Empty (Matches >> SearchResults) (Zipper.fromList data)


from : List a -> a -> List a -> SearchResults a
from before focus_ after =
    SearchResults (Matches (Zipper.from before focus_ after))


length : SearchResults a -> Int
length results =
    case results of
        Empty ->
            0

        SearchResults (Matches data) ->
            data
                |> Zipper.toList
                |> List.length


getAt : Int -> SearchResults a -> Maybe a
getAt index results =
    results |> toList |> ListE.getAt index


map : (Matches a -> Matches a) -> SearchResults a -> SearchResults a
map f results =
    case results of
        Empty ->
            Empty

        SearchResults matches ->
            SearchResults (f matches)


mapToList : (a -> Bool -> b) -> SearchResults a -> List b
mapToList f results =
    case results of
        Empty ->
            []

        SearchResults matches ->
            mapMatchesToList f matches


toMaybe : SearchResults a -> Maybe (Matches a)
toMaybe results =
    case results of
        Empty ->
            Nothing

        SearchResults matches ->
            Just matches


toList : SearchResults a -> List a
toList results =
    case results of
        Empty ->
            []

        SearchResults matches ->
            matchesToList matches


next : SearchResults a -> SearchResults a
next =
    map nextMatch


cycleNext : SearchResults a -> SearchResults a
cycleNext =
    map cycleNextMatch


prev : SearchResults a -> SearchResults a
prev =
    map prevMatch


cyclePrev : SearchResults a -> SearchResults a
cyclePrev =
    map cyclePrevMatch


focusOn : (a -> Bool) -> SearchResults a -> SearchResults a
focusOn pred results =
    case results of
        Empty ->
            Empty

        SearchResults matches ->
            SearchResults (focusOnMatch pred matches)


focus : SearchResults a -> Maybe a
focus results =
    case results of
        Empty ->
            Nothing

        SearchResults m ->
            Just (focusMatch m)



-- MATCHES


type Matches a
    = Matches (Zipper a)


nextMatch : Matches a -> Matches a
nextMatch ((Matches data) as matches) =
    unwrap matches Matches (Zipper.next data)


{-| like `nextMatch`, but cycles back around to the start
-}
cycleNextMatch : Matches a -> Matches a
cycleNextMatch (Matches data) =
    Zipper.next data
        |> Maybe.withDefault (Zipper.first data)
        |> Matches


prevMatch : Matches a -> Matches a
prevMatch ((Matches data) as matches) =
    unwrap matches Matches (Zipper.previous data)


{-| like `prevMatch`, but cycles back around to the end
-}
cyclePrevMatch : Matches a -> Matches a
cyclePrevMatch (Matches data) =
    Zipper.previous data
        |> Maybe.withDefault (Zipper.last data)
        |> Matches


focusMatch : Matches a -> a
focusMatch (Matches data) =
    Zipper.current data


focusOnMatch : (a -> Bool) -> Matches a -> Matches a
focusOnMatch pred ((Matches data) as matches) =
    unwrap matches Matches (Zipper.findFirst pred data)


{-| TODO: Should this be List.Nonempty ? |
-}
matchesToList : Matches a -> List a
matchesToList (Matches data) =
    Zipper.toList data


mapMatchesToList : (a -> Bool -> b) -> Matches a -> List b
mapMatchesToList f (Matches data) =
    let
        before =
            data
                |> Zipper.before
                |> List.map (\a -> f a False)

        focus_ =
            f (Zipper.current data) True

        after =
            data
                |> Zipper.after
                |> List.map (\a -> f a False)
    in
    before ++ (focus_ :: after)
