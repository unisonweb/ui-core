module Code.Branch exposing (..)

import Code.BranchRef as BranchRef exposing (BranchRef)
import Code.Hash as Hash exposing (Hash)
import Code.Project as Project exposing (Project)
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (required)
import UI.DateTime as DateTime exposing (DateTime)


type alias Branch b p =
    { b
        | ref : BranchRef
        , project : Project p
        , createdAt : DateTime
        , updatedAt : DateTime
        , hash : Hash
    }


type alias BranchSummary =
    Branch {} { visibility : Project.ProjectVisibility }


decodeSummary : Decode.Decoder BranchSummary
decodeSummary =
    let
        makeBranch branchRef project createdAt updatedAt hash =
            { ref = branchRef
            , project = project
            , createdAt = createdAt
            , updatedAt = updatedAt
            , hash = hash
            }
    in
    Decode.succeed makeBranch
        |> required "branchRef" BranchRef.decode
        |> required "project" Project.decodeSummary
        |> required "createdAt" DateTime.decode
        |> required "updatedAt" DateTime.decode
        |> required "causalHash" Hash.decode
