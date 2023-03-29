module Code.Branch exposing (..)

import Code.BranchRef as BranchRef exposing (BranchRef)
import Code.Project.ProjectRef as ProjectRef exposing (ProjectRef)
import Code.Project.ProjectSlug as ProjectSlug
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (required, requiredAt)
import Lib.UserHandle as UserHandle
import UI.DateTime as DateTime exposing (DateTime)


type alias Branch b =
    { b
        | ref : BranchRef
        , projectRef : ProjectRef
        , createdAt : DateTime
        , updatedAt : DateTime
    }


type alias BranchSummary =
    Branch {}


decodeSummary : Decode.Decoder BranchSummary
decodeSummary =
    let
        makeBranch branchRef handle_ slug_ createdAt updatedAt =
            let
                projectRef =
                    ProjectRef.projectRef handle_ slug_
            in
            { ref = branchRef
            , projectRef = projectRef
            , createdAt = createdAt
            , updatedAt = updatedAt
            }
    in
    Decode.succeed makeBranch
        |> required "ref" BranchRef.decode
        |> requiredAt [ "project", "owner", "handle" ] UserHandle.decodeUnprefixed
        |> requiredAt [ "project", "slug" ] ProjectSlug.decode
        |> required "createdAt" DateTime.decode
        |> required "updatedAt" DateTime.decode
