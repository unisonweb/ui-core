module Code.Project.ProjectSlug exposing
    ( ProjectSlug
    , decode
    , equals
    , fromString
    , isValidProjectSlug
    , toNamespaceString
    , toString
    , unsafeFromString
    )

import Json.Decode as Decode exposing (string)
import Regex
import String.Extra exposing (camelize)


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


{-| namespaces and project slugs don't completely overlap in their validity.
convert slugs into namespaces, making sure to camelize any underscore or dash
separated words
-}
toNamespaceString : ProjectSlug -> String
toNamespaceString =
    toString >> camelize


equals : ProjectSlug -> ProjectSlug -> Bool
equals (ProjectSlug a) (ProjectSlug b) =
    a == b


{-| Requirements

  - May only contain alphanumeric characters, underscores, and hyphens.
  - No special symbols or spaces
  - no slashes
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
                Regex.fromString "^[\\w-]+$"
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
