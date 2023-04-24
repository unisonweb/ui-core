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


type ReleaseStatus
    = Draft
    | Published { publishedAt : DateTime, publishedBy : UserHandle }
    | Unpublished { unpublishedAt : DateTime, unpublishedBy : UserHandle }


type alias Release =
    { version : ProjectVersion
    , causalHash : Hash
    , releaseNotes : Maybe Doc
    , projectRef : ProjectRef
    , createdAt : DateTime
    , createdBy : UserHandle
    , updatedAt : DateTime
    , status : ReleaseStatus
    }



-- DECODE


decode : Decode.Decoder Release
decode =
    let
        published at by =
            Published { publishedAt = at, publishedBy = by }

        unpublished at by =
            Unpublished { unpublishedAt = at, unpublishedBy = by }

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
        |> required "version" ProjectVersion.decode
        |> required "causalHash" Hash.decode
        |> required "releaseNotes" (nullable Doc.decode)
        |> required "projectRef" ProjectRef.decode
        |> required "createdAt" DateTime.decode
        |> required "createdBy" UserHandle.decode
        |> required "updatedAt" DateTime.decode
        |> required "status" decodeStatus
