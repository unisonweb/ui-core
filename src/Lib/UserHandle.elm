module Lib.UserHandle exposing
    ( UserHandle
    , decode
    , decodeUnprefixed
    , equals
    , fromSlug
    , fromString
    , fromUnprefixedString
    , isValidHandle
    , toString
    , toUnprefixedString
    , unsafeFromString
    )

import Json.Decode as Decode exposing (string)
import Lib.Slug as Slug exposing (Slug)


type UserHandle
    = UserHandle Slug


fromSlug : Slug -> UserHandle
fromSlug slug =
    UserHandle slug


fromString : String -> Maybe UserHandle
fromString raw =
    if String.startsWith "@" raw then
        raw
            |> String.dropLeft 1
            |> Slug.fromString
            |> Maybe.map UserHandle

    else
        Nothing


{-| Don't use, meant for ease of testing
-}
unsafeFromString : String -> UserHandle
unsafeFromString raw =
    raw |> Slug.unsafeFromString |> UserHandle


fromUnprefixedString : String -> Maybe UserHandle
fromUnprefixedString raw =
    if String.startsWith "@" raw then
        Nothing

    else
        raw |> Slug.fromString |> Maybe.map UserHandle


{-| Validates an un-prefixed string. So `@unison` would not be valid. We add and
remove `@` as a toString/fromString step instead
-}
isValidHandle : String -> Bool
isValidHandle unprefixed =
    if String.contains "@" unprefixed then
        False

    else
        Slug.isValidSlug unprefixed


toString : UserHandle -> String
toString (UserHandle slug) =
    "@" ++ Slug.toString slug


toUnprefixedString : UserHandle -> String
toUnprefixedString (UserHandle slug) =
    Slug.toString slug


equals : UserHandle -> UserHandle -> Bool
equals (UserHandle a) (UserHandle b) =
    a == b



-- DECODE


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


decodeUnprefixed : Decode.Decoder UserHandle
decodeUnprefixed =
    let
        decodeUserHandle_ s =
            case fromUnprefixedString s of
                Just u ->
                    Decode.succeed u

                Nothing ->
                    Decode.fail "Could not parse as UserHandle"
    in
    Decode.andThen decodeUserHandle_ string
