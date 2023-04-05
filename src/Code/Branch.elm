module Code.Branch exposing (..)

import Code.BranchRef as BranchRef exposing (BranchRef)
import Code.Project as Project exposing (Project)
import Code.Project.ProjectRef as ProjectRef
import Code.Project.ProjectSlug as ProjectSlug
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (required, requiredAt)
import Lib.UserHandle as UserHandle
import UI.DateTime as DateTime exposing (DateTime)


type alias Branch b p =
    { b
        | ref : BranchRef
        , project : Project p
        , createdAt : DateTime
        , updatedAt : DateTime
    }


type alias BranchSummary =
    Branch {} { visibility : Project.ProjectVisibility }


decodeSummary : Decode.Decoder BranchSummary
decodeSummary =
    let
        makeBranch branchRef handle_ slug_ visibility createdAt updatedAt =
            let
                projectRef =
                    ProjectRef.projectRef handle_ slug_
            in
            { ref = branchRef
            , project = { ref = projectRef, visibility = visibility }
            , createdAt = createdAt
            , updatedAt = updatedAt
            }
    in
    Decode.succeed makeBranch
        |> required "ref" BranchRef.decode
        |> requiredAt [ "project", "owner" ] UserHandle.decode
        |> requiredAt [ "project", "slug" ] ProjectSlug.decode
        |> requiredAt [ "project", "visibility" ] Project.decodeVisibility
        |> required "createdAt" DateTime.decode
        |> required "updatedAt" DateTime.decode
