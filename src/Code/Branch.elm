module Code.Branch exposing (..)

import Code.BranchRef exposing (BranchRef)
import Code.Project.ProjectRef exposing (ProjectRef)
import UI.DateTime exposing (DateTime)


type alias Branch b =
    { b
        | ref : BranchRef
        , projectRef : ProjectRef
        , createdAt : DateTime
        , updatedAt : DateTime
    }
