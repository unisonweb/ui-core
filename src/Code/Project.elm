module Code.Project exposing (..)

import Code.BranchRef as BranchRef exposing (BranchRef)
import Code.Project.ProjectRef as ProjectRef exposing (ProjectRef)
import Code.Project.ProjectSlug as ProjectSlug exposing (ProjectSlug)
import Code.Version as Version exposing (Version)
import Json.Decode as Decode exposing (bool, int, nullable, string)
import Json.Decode.Extra exposing (when)
import Json.Decode.Pipeline exposing (optional, required, requiredAt)
import Lib.UserHandle as UserHandle exposing (UserHandle)
import Maybe.Extra as MaybeE
import Set exposing (Set)
import UI.DateTime as DateTime exposing (DateTime)


type alias Project a =
    { a
        | ref : ProjectRef
        , visibility : ProjectVisibility
        , createdAt : DateTime
        , updatedAt : DateTime
    }


type IsFaved
    = Unknown
    | Faved
    | NotFaved
    | JustFaved


type ProjectVisibility
    = Public
    | Private


type alias ProjectListItem =
    Project
        { summary : Maybe String
        , tags : Set String
        }


type alias ProjectSummary =
    Project
        { summary : Maybe String
        , tags : Set String
        , numFavs : Int
        , numWeeklyDownloads : Int
        , isFaved : IsFaved
        }


type alias ProjectDetails =
    Project
        { summary : Maybe String
        , tags : Set String
        , numFavs : Int
        , numWeeklyDownloads : Int
        , isFaved : IsFaved
        , latestVersion : Maybe Version
        , defaultBranch : Maybe BranchRef
        }


ref : Project a -> ProjectRef
ref project =
    project.ref


handle : Project a -> UserHandle
handle p =
    ProjectRef.handle p.ref


defaultBrowsingBranch : ProjectDetails -> BranchRef
defaultBrowsingBranch p =
    p.latestVersion
        |> Maybe.map BranchRef.releaseBranchRef
        |> MaybeE.orElse p.defaultBranch
        |> Maybe.withDefault BranchRef.main_


slug : Project a -> ProjectSlug
slug p =
    ProjectRef.slug p.ref


equals : Project a -> Project b -> Bool
equals a b =
    ProjectRef.equals a.ref b.ref


isOwnedBy : UserHandle -> Project a -> Bool
isOwnedBy handle_ project =
    UserHandle.equals handle_ (handle project)


toggleFav : ProjectDetails -> ProjectDetails
toggleFav ({ numFavs } as project) =
    let
        ( isFaved_, numFavs_ ) =
            case project.isFaved of
                Faved ->
                    ( NotFaved, numFavs - 1 )

                JustFaved ->
                    ( NotFaved, numFavs - 1 )

                NotFaved ->
                    ( JustFaved, numFavs + 1 )

                Unknown ->
                    ( Unknown, numFavs )
    in
    { project | isFaved = isFaved_, numFavs = numFavs_ }


isFaved : ProjectDetails -> Bool
isFaved p =
    isFavedToBool p.isFaved


isFavedToBool : IsFaved -> Bool
isFavedToBool isFaved_ =
    isFaved_ == Faved || isFaved_ == JustFaved


isFavedFromBool : Bool -> IsFaved
isFavedFromBool b =
    if b then
        Faved

    else
        NotFaved


visibilityToString : ProjectVisibility -> String
visibilityToString pv =
    case pv of
        Public ->
            "public"

        Private ->
            "private"



-- DECODE


decodeVisibility : Decode.Decoder ProjectVisibility
decodeVisibility =
    Decode.oneOf
        [ when Decode.string ((==) "public") (Decode.succeed Public)
        , when Decode.string ((==) "private") (Decode.succeed Private)
        ]


decodeIsFaved : Decode.Decoder IsFaved
decodeIsFaved =
    Decode.map isFavedFromBool bool


decodeDetails : Decode.Decoder ProjectDetails
decodeDetails =
    let
        makeProjectDetails handle_ slug_ summary tags visibility numFavs numWeeklyDownloads isFaved_ latestVersion defaultBranch createdAt updatedAt =
            let
                ref_ =
                    ProjectRef.projectRef handle_ slug_
            in
            { ref = ref_
            , summary = summary
            , tags = Set.fromList tags
            , visibility = visibility
            , numFavs = numFavs
            , numWeeklyDownloads = numWeeklyDownloads
            , isFaved = isFaved_
            , latestVersion = latestVersion
            , defaultBranch = defaultBranch
            , createdAt = createdAt
            , updatedAt = updatedAt
            }
    in
    Decode.succeed makeProjectDetails
        |> requiredAt [ "owner", "handle" ] UserHandle.decode
        |> required "slug" ProjectSlug.decode
        |> required "summary" (nullable string)
        |> required "tags" (Decode.list string)
        |> required "visibility" decodeVisibility
        |> optional "numFavs" int 0
        |> optional "numWeeklyDownloads" int 0
        |> optional "isFaved" decodeIsFaved Unknown
        |> required "latestVersion" (nullable Version.decode)
        |> required "defaultBranch" (nullable BranchRef.decode)
        |> required "createdAt" DateTime.decode
        |> required "updatedAt" DateTime.decode


decodeListItem : Decode.Decoder ProjectListItem
decodeListItem =
    let
        makeProjectListItem handle_ slug_ visibility summary tags createdAt updatedAt =
            let
                ref_ =
                    ProjectRef.projectRef handle_ slug_
            in
            { ref = ref_
            , visibility = visibility
            , summary = summary
            , tags = Set.fromList tags
            , createdAt = createdAt
            , updatedAt = updatedAt
            }
    in
    Decode.succeed makeProjectListItem
        |> requiredAt [ "owner", "handle" ] UserHandle.decode
        |> required "slug" ProjectSlug.decode
        |> required "visibility" decodeVisibility
        |> required "summary" (nullable string)
        |> required "tags" (Decode.list string)
        |> required "createdAt" DateTime.decode
        |> required "updatedAt" DateTime.decode


decodeSummary : Decode.Decoder ProjectSummary
decodeSummary =
    let
        makeProjectSummary handle_ slug_ visibility summary tags numFavs numDownloads isFaved_ createdAt updatedAt =
            let
                ref_ =
                    ProjectRef.projectRef handle_ slug_
            in
            { ref = ref_
            , visibility = visibility
            , summary = summary
            , tags = Set.fromList tags
            , numFavs = numFavs
            , numWeeklyDownloads = numDownloads
            , isFaved = isFaved_
            , createdAt = createdAt
            , updatedAt = updatedAt
            }
    in
    Decode.succeed makeProjectSummary
        |> requiredAt [ "owner", "handle" ] UserHandle.decode
        |> required "slug" ProjectSlug.decode
        |> required "visibility" decodeVisibility
        |> required "summary" (nullable string)
        |> required "tags" (Decode.list string)
        |> required "numFavs" int
        |> optional "numWeeklyDownloads" int 0
        |> optional "isFaved" decodeIsFaved Unknown
        |> required "createdAt" DateTime.decode
        |> required "updatedAt" DateTime.decode
