module Lib.UserHandle exposing
    ( UserHandle
    , decode
    , equals
    , fromString
    , fromUnprefixedString
    , isValidHandle
    , toString
    , toUnprefixedString
    )

import Json.Decode as Decode exposing (string)
import Regex


type UserHandle
    = UserHandle String


fromString : String -> Maybe UserHandle
fromString raw =
    if String.startsWith "@" raw then
        fromString_ raw

    else
        Nothing


fromUnprefixedString : String -> Maybe UserHandle
fromUnprefixedString raw =
    if String.startsWith "@" raw then
        Nothing

    else
        fromString_ raw


fromString_ : String -> Maybe UserHandle
fromString_ raw =
    let
        validate s =
            if isValidHandle s then
                Just s

            else
                Nothing
    in
    raw
        |> String.filter (\c -> c /= '@')
        |> validate
        |> Maybe.map UserHandle


{-| Modelled after the GitHub user handle requirements, since we're importing their handles.

Validates an un-prefixed string. So `@unison` would not be valid. We add and
remove `@` as a toString/fromString step instead

Requirements (via <https://github.com/shinnn/github-username-regex>):

  - May only contain alphanumeric characters or hyphens.
  - Can't have multiple consecutive hyphens.
  - Can't begin or end with a hyphen.
  - Maximum is 39 characters.

-}
isValidHandle : String -> Bool
isValidHandle raw =
    let
        re =
            Maybe.withDefault Regex.never <|
                Regex.fromString "^[a-z\\d](?:[a-z\\d]|-(?=[a-z\\d])){1,39}$"
    in
    Regex.contains re raw


toString : UserHandle -> String
toString (UserHandle raw) =
    "@" ++ raw


toUnprefixedString : UserHandle -> String
toUnprefixedString (UserHandle raw) =
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
