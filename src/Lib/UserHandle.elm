module Lib.UserHandle exposing
    ( UserHandle
    , decode
    , equals
    , fromString
    , toRawString
    , toString
    )

import Json.Decode as Decode exposing (string)


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


decode : Decode.Decoder UserHandle
decode =
    let
        decodeUserHandle_ s =
            case fromString s of
                Just u ->
                    Decode.succeed u

                Nothing ->
                    Decode.fail "Could not parse as UserHandle"
    in
    Decode.andThen decodeUserHandle_ string
