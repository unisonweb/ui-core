module Lib.Milliseconds exposing (..)


oneSecond : Int
oneSecond =
    1000


oneMinute : Int
oneMinute =
    60 * oneSecond


oneHour : Int
oneHour =
    60 * oneMinute


oneDay : Int
oneDay =
    hours 24


seconds : Int -> Int
seconds n =
    n * oneSecond


minutes : Int -> Int
minutes n =
    n * oneMinute


hours : Int -> Int
hours n =
    n * oneHour


days : Int -> Int
days n =
    n * oneDay
