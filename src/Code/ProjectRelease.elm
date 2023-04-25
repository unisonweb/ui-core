module Code.ProjectRelease exposing (..)

import Code.Definition.Doc as Doc exposing (Doc)
import Code.Hash as Hash exposing (Hash)
import Code.Project.ProjectRef as ProjectRef exposing (ProjectRef)
import Code.ProjectVersion as ProjectVersion exposing (ProjectVersion)
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


type alias ProjectRelease =
    { version : ProjectVersion
    , causalHash : Hash
    , releaseNotes : Maybe Doc
    , projectRef : ProjectRef
    , createdAt : DateTime
    , createdBy : UserHandle
    , updatedAt : DateTime
    , status : ReleaseStatus
    }



-- HELPERS


isDraft : ProjectRelease -> Bool
isDraft pr =
    case pr.status of
        Draft ->
            True

        _ ->
            False


isPublished : ProjectRelease -> Bool
isPublished pr =
    case pr.status of
        Published _ ->
            True

        _ ->
            False


isUnpublished : ProjectRelease -> Bool
isUnpublished pr =
    case pr.status of
        Unpublished _ ->
            True

        _ ->
            False



-- DECODE


decode : Decode.Decoder ProjectRelease
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
    Decode.succeed ProjectRelease
        |> required "version" ProjectVersion.decode
        |> required "causalHash" Hash.decode
        |> required "releaseNotes" (nullable Doc.decode)
        |> required "projectRef" ProjectRef.decode
        |> required "createdAt" DateTime.decode
        |> required "createdBy" UserHandle.decode
        |> required "updatedAt" DateTime.decode
        |> required "status" decodeStatus
