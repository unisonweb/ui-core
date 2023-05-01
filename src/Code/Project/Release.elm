module Code.Project.Release exposing (..)

import Code.BranchRef as BranchRef exposing (BranchRef)
import Code.Definition.Doc as Doc exposing (Doc)
import Code.Hash as Hash exposing (Hash)
import Code.Project.ProjectRef as ProjectRef exposing (ProjectRef)
import Code.Version as Version exposing (Version)
import Json.Decode as Decode exposing (field, nullable, string)
import Json.Decode.Extra exposing (when)
import Json.Decode.Pipeline exposing (required)
import Lib.UserHandle as UserHandle exposing (UserHandle)
import UI.DateTime as DateTime exposing (DateTime)


type alias StatusMeta =
    { at : DateTime, by : UserHandle }


type ReleaseStatus
    = Draft
    | Published StatusMeta
    | Unpublished StatusMeta


type alias Release =
    { version : Version
    , causalHashUnsquashed : Hash
    , causalHashSquashed : Hash
    , releaseNotes : Maybe Doc
    , projectRef : ProjectRef
    , createdAt : DateTime
    , createdBy : UserHandle
    , updatedAt : DateTime
    , status : ReleaseStatus
    }



-- HELPERS


isDraft : Release -> Bool
isDraft r =
    case r.status of
        Draft ->
            True

        _ ->
            False


isPublished : Release -> Bool
isPublished r =
    case r.status of
        Published _ ->
            True

        _ ->
            False


isUnpublished : Release -> Bool
isUnpublished r =
    case r.status of
        Unpublished _ ->
            True

        _ ->
            False


branchRef : Release -> BranchRef
branchRef r =
    BranchRef.releaseBranchRef r.version



-- DECODE


decode : Decode.Decoder Release
decode =
    let
        published at by =
            Published { at = at, by = by }

        unpublished at by =
            Unpublished { at = at, by = by }

        decodeStatus =
            Decode.oneOf
                [ when (field "status" string)
                    ((==) "draft")
                    (Decode.succeed Draft)
                , when (field "status" string)
                    ((==) "published")
                    (Decode.map2 published
                        (field "publishedAt" DateTime.decode)
                        (field "publishedBy" UserHandle.decode)
                    )
                , when (field "status" string)
                    ((==) "deprecated")
                    (Decode.map2 unpublished
                        (field "deprecatedAt" DateTime.decode)
                        (field "deprecatedBy" UserHandle.decode)
                    )
                ]
    in
    Decode.succeed Release
        |> required "version" Version.decode
        |> required "causalHashUnsquashed" Hash.decode
        |> required "causalHashSquashed" Hash.decode
        |> required "releaseNotes" (nullable Doc.decode)
        |> required "projectRef" ProjectRef.decode
        |> required "createdAt" DateTime.decode
        |> required "createdBy" UserHandle.decode
        |> required "updatedAt" DateTime.decode
        |> required "status" decodeStatus
