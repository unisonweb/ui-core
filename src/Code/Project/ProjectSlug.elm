module Code.Project.ProjectSlug exposing
    ( ProjectSlug
    , decode
    , equals
    , fromString
    , isValidProjectSlug
    , toString
    , unsafeFromString
    )

import Json.Decode as Decode exposing (string)
import Regex


type ProjectSlug
    = ProjectSlug String


fromString : String -> Maybe ProjectSlug
fromString raw =
    let
        validate s =
            if isValidProjectSlug s then
                Just s

            else
                Nothing
    in
    raw
        |> validate
        |> Maybe.map ProjectSlug


{-| Don't use, meant for ease of testing
-}
unsafeFromString : String -> ProjectSlug
unsafeFromString raw =
    ProjectSlug raw


toString : ProjectSlug -> String
toString (ProjectSlug raw) =
    raw


equals : ProjectSlug -> ProjectSlug -> Bool
equals (ProjectSlug a) (ProjectSlug b) =
    a == b


{-| Modelled after the GitHub user handle requirements, since we're importing their handles.

Validates an un-prefixed string. So `@unison` would not be valid. We add and
remove `@` as a toString/fromString step instead

Requirements (via <https://github.com/shinnn/github-username-regex>):

  - May only contain alphanumeric characters or hyphens.
  - Can't have multiple consecutive hyphens.
  - Can't begin or end with a hyphen.
  - Maximum is 39 characters.

Additional requirements:

  - Can't be a reserved word, like "code" or "p" (those are used in URLs to mean other things)

-}
isValidProjectSlug : String -> Bool
isValidProjectSlug raw =
    let
        reserved =
            [ "code", "p" ]

        isReserved =
            List.member (String.toLower raw) reserved

        re =
            Maybe.withDefault Regex.never <|
                Regex.fromString "^[a-z\\d](?:[a-z\\d]|-(?=[a-z\\d])){1,39}$"
    in
    not isReserved && Regex.contains re raw


decode : Decode.Decoder ProjectSlug
decode =
    let
        decode_ s =
            case fromString s of
                Just u ->
                    Decode.succeed u

                Nothing ->
                    Decode.fail "Could not parse as ProjectSlug"
    in
    Decode.andThen decode_ string
