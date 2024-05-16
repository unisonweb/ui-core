module Code.BranchRef exposing (..)

import Code.Version as Version exposing (Version)
import Json.Decode as Decode
import Lib.UserHandle as UserHandle exposing (UserHandle)
import Lib.Util as Util
import Regex
import UI.Icon as Icon
import UI.Tag as Tag exposing (Tag)
import Url


type BranchSlug
    = BranchSlug String


type BranchRef
    = ProjectBranchRef BranchSlug
    | ContributorBranchRef UserHandle BranchSlug
    | ReleaseBranchRef Version
    | ReleaseDraftBranchRef Version


projectBranchRef : BranchSlug -> BranchRef
projectBranchRef slug_ =
    ProjectBranchRef slug_


contributorBranchRef : UserHandle -> BranchSlug -> BranchRef
contributorBranchRef handle_ slug_ =
    ContributorBranchRef handle_ slug_


releaseBranchRef : Version -> BranchRef
releaseBranchRef v =
    ReleaseBranchRef v


releaseDraftBranchRef : Version -> BranchRef
releaseDraftBranchRef v =
    ReleaseDraftBranchRef v


main_ : BranchRef
main_ =
    projectBranchRef (BranchSlug "main")


toString : BranchRef -> String
toString br =
    case br of
        ProjectBranchRef (BranchSlug slug_) ->
            slug_

        ContributorBranchRef h (BranchSlug slug_) ->
            UserHandle.toString h ++ "/" ++ slug_

        ReleaseBranchRef v ->
            "releases/" ++ Version.toString v

        ReleaseDraftBranchRef v ->
            "releases/drafts/" ++ Version.toString v


toApiUrlString : BranchRef -> String
toApiUrlString br =
    case br of
        ProjectBranchRef (BranchSlug slug_) ->
            slug_

        ContributorBranchRef h (BranchSlug slug_) ->
            -- Escape "/" as "%2F"
            UserHandle.toString h ++ "%2F" ++ slug_

        ReleaseDraftBranchRef v ->
            Url.percentEncode ("releases/drafts/" ++ Version.toString v)

        ReleaseBranchRef v ->
            Url.percentEncode ("releases/" ++ Version.toString v)


toUrlPath : BranchRef -> List String
toUrlPath br =
    case br of
        ProjectBranchRef slug_ ->
            [ branchSlugToString slug_ ]

        ContributorBranchRef h slug_ ->
            [ UserHandle.toString h, branchSlugToString slug_ ]

        ReleaseDraftBranchRef v ->
            [ "releases", "drafts", Version.toUrlString v ]

        ReleaseBranchRef v ->
            [ "releases", Version.toUrlString v ]


isProjectBranchRef : BranchRef -> Bool
isProjectBranchRef br =
    case br of
        ProjectBranchRef _ ->
            True

        _ ->
            False


isContributorBranchRef : BranchRef -> Bool
isContributorBranchRef br =
    case br of
        ContributorBranchRef _ _ ->
            True

        _ ->
            False


isReleaseBranchRef : BranchRef -> Bool
isReleaseBranchRef br =
    case br of
        ReleaseBranchRef _ ->
            True

        _ ->
            False


isReleaseDraftBranchRef : BranchRef -> Bool
isReleaseDraftBranchRef br =
    case br of
        ReleaseDraftBranchRef _ ->
            True

        _ ->
            False


{-| Branches can include a handle when being parsed.

valid examples are:

  - "mybranch", "myBranch", "mybr4nch"
  - "my-branch", "my\_branch", "-my---branch", "\_my-branch"
    (for some reason elm-format wont allow having underscores without a backslash infront)
  - "@owner/my-branch"
  - "releases/1.2.3" -- where 1.2.3 is semver format
  - "releases/drafts/1.2.3"

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
        [ "releases", "drafts", v ] ->
            Maybe.map ReleaseDraftBranchRef (Version.fromString v)

        [ "releases", v ] ->
            Maybe.map ReleaseBranchRef (Version.fromString v)

        [ h, s ] ->
            Maybe.map2
                (\h_ s_ -> ContributorBranchRef h_ s_)
                (UserHandle.fromString h)
                (branchSlugFromString s)

        [ s ] ->
            Maybe.map ProjectBranchRef (branchSlugFromString s)

        _ ->
            Nothing


branchSlugFromString : String -> Maybe BranchSlug
branchSlugFromString raw =
    if isValidBranchSlug raw then
        Just (BranchSlug raw)

    else
        Nothing


{-| ⚠️ Don't use outside of testing
-}
unsafeBranchSlugFromString : String -> BranchSlug
unsafeBranchSlugFromString raw =
    BranchSlug raw


branchSlugToString : BranchSlug -> String
branchSlugToString (BranchSlug s) =
    s


{-| ⚠️ Don't use outside of testing
-}
unsafeFromString : String -> BranchRef
unsafeFromString raw =
    let
        parts =
            String.split "/" raw
    in
    case parts of
        [ "releases", "drafts", v ] ->
            ReleaseDraftBranchRef (Version.unsafeFromString v)

        [ "releases", v ] ->
            ReleaseBranchRef (Version.unsafeFromString v)

        [ h, s ] ->
            ContributorBranchRef
                (UserHandle.unsafeFromString h)
                (unsafeBranchSlugFromString s)

        _ ->
            ProjectBranchRef (unsafeBranchSlugFromString raw)


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


equals : BranchRef -> BranchRef -> Bool
equals brA brB =
    case ( brA, brB ) of
        ( ProjectBranchRef (BranchSlug slugA), ProjectBranchRef (BranchSlug slugB) ) ->
            slugA == slugB

        ( ContributorBranchRef handleA (BranchSlug slugA), ContributorBranchRef handleB (BranchSlug slugB) ) ->
            UserHandle.equals handleA handleB && slugA == slugB

        ( ReleaseBranchRef versionA, ReleaseBranchRef versionB ) ->
            Version.equals versionA versionB

        ( ReleaseDraftBranchRef versionA, ReleaseDraftBranchRef versionB ) ->
            Version.equals versionA versionB

        _ ->
            False


version : BranchRef -> Maybe Version
version br =
    case br of
        ReleaseBranchRef v ->
            Just v

        ReleaseDraftBranchRef v ->
            Just v

        _ ->
            Nothing



-- VIEW


toTag : BranchRef -> Tag msg
toTag branchRef_ =
    let
        tag =
            case branchRef_ of
                ProjectBranchRef branchSlug ->
                    Tag.tag (branchSlugToString branchSlug)

                ContributorBranchRef handle_ branchSlug ->
                    Tag.tag (branchSlugToString branchSlug)
                        |> Tag.withLeftText (UserHandle.toString handle_ ++ "/")

                ReleaseBranchRef v ->
                    Tag.tag (Version.toString v)
                        |> Tag.withLeftText "releases/"

                ReleaseDraftBranchRef v ->
                    Tag.tag (Version.toString v)
                        |> Tag.withLeftText "releases/drafts/"
    in
    Tag.withIcon Icon.branch tag



-- DECODE


decode : Decode.Decoder BranchRef
decode =
    Decode.map fromString Decode.string
        |> Decode.andThen (Util.decodeFailInvalid "Invalid BranchRef")
