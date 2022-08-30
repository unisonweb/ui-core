module Lib.Slug exposing
    ( Slug
    , decode
    , equals
    , fromString
    , isValidSlug
    , toString
    , unsafeFromString
    )

import Json.Decode as Decode exposing (string)
import Regex


type Slug
    = Slug String


fromString : String -> Maybe Slug
fromString raw =
    let
        validate s =
            if isValidSlug s then
                Just s

            else
                Nothing
    in
    raw
        |> validate
        |> Maybe.map Slug


{-| Don't use, meant for ease of testing
-}
unsafeFromString : String -> Slug
unsafeFromString raw =
    Slug raw


toString : Slug -> String
toString (Slug raw) =
    raw


equals : Slug -> Slug -> Bool
equals (Slug a) (Slug b) =
    a == b


{-| Modelled after the GitHub user handle requirements, since we're importing their handles.

Validates an un-prefixed string. So `@unison` would not be valid. We add and
remove `@` as a toString/fromString step instead

Requirements (via <https://github.com/shinnn/github-username-regex>):

  - May only contain alphanumeric characters or hyphens.
  - Can't have multiple consecutive hyphens.
  - Can't begin or end with a hyphen.
  - Maximum is 39 characters.

-}
isValidSlug : String -> Bool
isValidSlug raw =
    let
        re =
            Maybe.withDefault Regex.never <|
                Regex.fromString "^[a-z\\d](?:[a-z\\d]|-(?=[a-z\\d])){1,39}$"
    in
    Regex.contains re raw


decode : Decode.Decoder Slug
decode =
    let
        decode_ s =
            case fromString s of
                Just u ->
                    Decode.succeed u

                Nothing ->
                    Decode.fail "Could not parse as Slug"
    in
    Decode.andThen decode_ string
