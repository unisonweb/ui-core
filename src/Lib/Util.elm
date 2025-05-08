module Lib.Util exposing (..)

import Http
import Process
import Task
import Url exposing (Url)



-- Various utility functions and helpers


delayMsg : Float -> msg -> Cmd msg
delayMsg delay msg =
    Task.perform (\_ -> msg) (Process.sleep delay)


pipeMaybe : (b -> a -> a) -> Maybe b -> a -> a
pipeMaybe f may a =
    case may of
        Just b ->
            f b a

        Nothing ->
            a


pipeIf : (a -> a) -> Bool -> a -> a
pipeIf f cond a =
    if cond then
        f a

    else
        a


httpErrorToString : Http.Error -> String
httpErrorToString err =
    case err of
        Http.Timeout ->
            "Timeout exceeded"

        Http.NetworkError ->
            "Network error"

        Http.BadStatus status ->
            "Bad status: " ++ String.fromInt status

        Http.BadBody text ->
            "Unexpected response from api: " ++ text

        Http.BadUrl url ->
            "Malformed url: " ++ url


ascending : (a -> a -> Order) -> a -> a -> Order
ascending comp a b =
    case comp a b of
        LT ->
            LT

        EQ ->
            EQ

        GT ->
            GT


descending : (a -> a -> Order) -> a -> a -> Order
descending comp a b =
    case comp a b of
        LT ->
            GT

        EQ ->
            EQ

        GT ->
            LT


sortByWith : (x -> a) -> (a -> a -> Order) -> List x -> List x
sortByWith get compare_ list =
    List.sortWith (\x1 x2 -> compare_ (get x1) (get x2)) list
