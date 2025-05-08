module Lib.String.Helpers exposing (..)

{-| A unicode aware string length
-}


unicodeLength : String -> Int
unicodeLength s =
    s |> String.toList |> List.length


pluralize : String -> String -> Int -> String
pluralize singular plural num =
    if num == 1 then
        singular

    else
        plural


possessive : String -> String
possessive s =
    if String.endsWith "s" s then
        s ++ "'"

    else
        s ++ "'s"
