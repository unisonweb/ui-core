module Code.BranchShorthand exposing (..)

import Lib.UserHandle as UserHandle exposing (UserHandle)
import Regex


type BranchSlug
    = BranchSlug String


type BranchShorthand
    = BranchShorthand { handle : Maybe UserHandle, slug : BranchSlug }


branchShorthand : Maybe UserHandle -> BranchSlug -> BranchShorthand
branchShorthand handle_ slug_ =
    BranchShorthand { handle = handle_, slug = slug_ }


main_ : BranchShorthand
main_ =
    BranchShorthand { handle = Nothing, slug = BranchSlug "main" }


toString : BranchShorthand -> String
toString (BranchShorthand b) =
    let
        (BranchSlug slug_) =
            b.slug
    in
    case b.handle of
        Just h ->
            UserHandle.toString h ++ "/" ++ slug_

        Nothing ->
            slug_


toUrlPath : BranchShorthand -> List String
toUrlPath (BranchShorthand b) =
    case b.handle of
        Just h ->
            [ UserHandle.toString h, branchSlugToString b.slug ]

        Nothing ->
            [ branchSlugToString b.slug ]


toParts : BranchShorthand -> ( Maybe UserHandle, BranchSlug )
toParts (BranchShorthand b) =
    ( b.handle, b.slug )


handle : BranchShorthand -> Maybe UserHandle
handle (BranchShorthand b) =
    b.handle


slug : BranchShorthand -> BranchSlug
slug (BranchShorthand b) =
    b.slug


{-| Branches can include a handle when being parsed.

valid examples are:

  - "mybranch", "myBranch", "mybr4nch"
  - "my-branch", "my\_branch", "-my---branch", "\_my-branch"
  - "@owner/my-branch"

invalid examples

  - "my/branch"
  - "my@branch"
  - "@owner/my/branch"
  - "@owner@my/branch"
  - "@owner@my/branch"
  - "my branch"
  - "mybr%@#nch"

-}
fromString : String -> Maybe BranchShorthand
fromString raw =
    let
        parts =
            String.split "/" raw
    in
    case parts of
        [ h, s ] ->
            Maybe.map2
                (\h_ s_ -> BranchShorthand { handle = Just h_, slug = s_ })
                (UserHandle.fromString h)
                (branchSlugFromString s)

        [ s ] ->
            Maybe.map
                (\s_ -> BranchShorthand { handle = Nothing, slug = s_ })
                (branchSlugFromString s)

        _ ->
            Nothing


branchSlugFromString : String -> Maybe BranchSlug
branchSlugFromString raw =
    if isValidBranchSlug raw then
        Just (BranchSlug raw)

    else
        Nothing


branchSlugToString : BranchSlug -> String
branchSlugToString (BranchSlug s) =
    s


{-| Requirements

  - May only contain alphanumeric characters, underscores, and hyphens.
  - No special symbols or spaces
  - no slashes

-}
isValidBranchSlug : String -> Bool
isValidBranchSlug raw =
    let
        re =
            Maybe.withDefault Regex.never <|
                Regex.fromString "^[\\w-]+$"
    in
    Regex.contains re raw


{-| Don't use outside of testing
-}
unsafeFromString : String -> BranchShorthand
unsafeFromString raw =
    let
        parts =
            raw
                |> String.replace "@" ""
                |> String.split "/"
    in
    case parts of
        [ h, s ] ->
            BranchShorthand
                { handle = Just (UserHandle.unsafeFromString h)
                , slug = BranchSlug s
                }

        _ ->
            BranchShorthand { handle = Nothing, slug = BranchSlug raw }
