module Code.Branch exposing (..)

import Code.BranchRef as BranchRef exposing (BranchRef)
import Code.Hash as Hash exposing (Hash)
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (required)
import UI.DateTime as DateTime exposing (DateTime)


type alias Branch b =
    { b
        | ref : BranchRef
        , createdAt : DateTime
        , updatedAt : DateTime
        , causalHash : Hash
    }


type alias BranchSummary p =
    Branch { project : p }


decodeSummary : Decode.Decoder p -> Decode.Decoder (BranchSummary p)
decodeSummary projectDecoder =
    let
        makeBranch branchRef project createdAt updatedAt causalHash =
            { ref = branchRef
            , project = project
            , createdAt = createdAt
            , updatedAt = updatedAt
            , causalHash = causalHash
            }
    in
    Decode.succeed makeBranch
        |> required "branchRef" BranchRef.decode
        |> required "project" projectDecoder
        |> required "createdAt" DateTime.decode
        |> required "updatedAt" DateTime.decode
        |> required "causalHash" Hash.decode
