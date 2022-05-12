module Lib.UserHandle exposing
    ( UserHandle
    , equals
    , fromString
    , toRawString
    , toString
    )


type UserHandle
    = UserHandle String


{-| TODO: Validate
-}
fromString : String -> Maybe UserHandle
fromString raw =
    raw
        |> String.filter (\c -> c /= '@')
        |> UserHandle
        |> Just


toString : UserHandle -> String
toString (UserHandle raw) =
    "@" ++ raw


toRawString : UserHandle -> String
toRawString (UserHandle raw) =
    raw


equals : UserHandle -> UserHandle -> Bool
equals (UserHandle a) (UserHandle b) =
    a == b
