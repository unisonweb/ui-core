module Code.BranchRef exposing (..)

import Json.Decode as Decode
import Lib.UserHandle as UserHandle exposing (UserHandle)
import Lib.Util as Util
import Maybe.Extra as MaybeE
import Regex
import UI.Icon as Icon
import UI.Tag as Tag exposing (Tag)


type BranchSlug
    = BranchSlug String


type BranchRef
    = BranchRef { handle : Maybe UserHandle, slug : BranchSlug }


branchRef : Maybe UserHandle -> BranchSlug -> BranchRef
branchRef handle_ slug_ =
    BranchRef { handle = handle_, slug = slug_ }


main_ : BranchRef
main_ =
    BranchRef { handle = Nothing, slug = BranchSlug "main" }


toString : BranchRef -> String
toString (BranchRef b) =
    let
        (BranchSlug slug_) =
            b.slug
    in
    case b.handle of
        Just h ->
            UserHandle.toString h ++ "/" ++ slug_

        Nothing ->
            slug_


toApiUrlString : BranchRef -> String
toApiUrlString (BranchRef b) =
    let
        (BranchSlug slug_) =
            b.slug
    in
    case b.handle of
        Just h ->
            -- Escape "/" as "%2F"
            UserHandle.toString h ++ "%2F" ++ slug_

        Nothing ->
            slug_


toUrlPath : BranchRef -> List String
toUrlPath (BranchRef b) =
    case b.handle of
        Just h ->
            [ UserHandle.toString h, branchSlugToString b.slug ]

        Nothing ->
            [ branchSlugToString b.slug ]


toParts : BranchRef -> ( Maybe UserHandle, BranchSlug )
toParts (BranchRef b) =
    ( b.handle, b.slug )


toStringParts : BranchRef -> ( Maybe String, String )
toStringParts (BranchRef b) =
    ( Maybe.map UserHandle.toString b.handle, branchSlugToString b.slug )


isContributorBranch : BranchRef -> Bool
isContributorBranch (BranchRef b) =
    MaybeE.isJust b.handle


handle : BranchRef -> Maybe UserHandle
handle (BranchRef b) =
    b.handle


slug : BranchRef -> BranchSlug
slug (BranchRef b) =
    b.slug


{-| Branches can include a handle when being parsed.

valid examples are:

  - "mybranch", "myBranch", "mybr4nch"
  - "my-branch", "my\_branch", "-my---branch", "\_my-branch"
    (for some reason elm-format wont allow having underscores without a backslash infront)
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
fromString : String -> Maybe BranchRef
fromString raw =
    let
        parts =
            String.split "/" raw
    in
    case parts of
        [ h, s ] ->
            Maybe.map2
                (\h_ s_ -> BranchRef { handle = Just h_, slug = s_ })
                (UserHandle.fromString h)
                (branchSlugFromString s)

        [ s ] ->
            Maybe.map
                (\s_ -> BranchRef { handle = Nothing, slug = s_ })
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
unsafeFromString : String -> BranchRef
unsafeFromString raw =
    let
        parts =
            raw
                |> String.replace "@" ""
                |> String.split "/"
    in
    case parts of
        [ h, s ] ->
            BranchRef
                { handle = Just (UserHandle.unsafeFromString h)
                , slug = BranchSlug s
                }

        _ ->
            BranchRef { handle = Nothing, slug = BranchSlug raw }



-- VIEW


toTag : BranchRef -> Tag msg
toTag branchRef_ =
    let
        tag =
            case toParts branchRef_ of
                ( Just handle_, branchSlug ) ->
                    Tag.tag (branchSlugToString branchSlug)
                        |> Tag.withLeftText (UserHandle.toString handle_ ++ "/")

                ( Nothing, branchSlug ) ->
                    Tag.tag (branchSlugToString branchSlug)
    in
    Tag.withIcon Icon.branch tag



-- DECODE


decode : Decode.Decoder BranchRef
decode =
    Decode.map fromString Decode.string
        |> Decode.andThen (Util.decodeFailInvalid "Invalid BranchRef")
