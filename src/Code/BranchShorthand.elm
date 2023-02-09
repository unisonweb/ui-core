module Code.BranchShorthand exposing (..)

import Lib.UserHandle as UserHandle exposing (UserHandle)
import Regex


type BranchSlug
    = BranchSlug String


type alias BranchShorthand =
    { owner : Maybe UserHandle, slug : BranchSlug }


toString : BranchShorthand -> String
toString b =
    let
        (BranchSlug slug) =
            b.slug
    in
    case b.owner of
        Just h ->
            UserHandle.toString h ++ "/" ++ slug

        Nothing ->
            slug


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
            Maybe.map2 (\h_ s_ -> BranchShorthand (Just h_) s_)
                (UserHandle.fromString h)
                (branchSlugFromString s)

        [ s ] ->
            Maybe.map (BranchShorthand Nothing) (branchSlugFromString s)

        _ ->
            Nothing


branchSlugFromString : String -> Maybe BranchSlug
branchSlugFromString raw =
    if isValidBranchSlug raw then
        Just (BranchSlug raw)

    else
        Nothing


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
            BranchShorthand (Just (UserHandle.unsafeFromString h)) (BranchSlug s)

        _ ->
            BranchShorthand Nothing (BranchSlug raw)
