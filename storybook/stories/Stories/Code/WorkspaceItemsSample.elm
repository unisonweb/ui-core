module Stories.Code.WorkspaceItemsSample exposing (..)

import Code.Workspace.WorkspaceItems exposing (WorkspaceItems, fromItems)
import Json.Decode
import Stories.Code.WorkspaceItemSample exposing (decodeSampleWorkspaceItem, decodeSampleWorkspaceItemList)


makeWorkspaceItems : Result Json.Decode.Error WorkspaceItems
makeWorkspaceItems =
    decodeSampleWorkspaceItemList
        |> Result.andThen
            (\workspaceItems ->
                decodeSampleWorkspaceItem
                    |> Result.andThen
                        (\singleItem ->
                            Ok <| fromItems workspaceItems singleItem workspaceItems
                        )
            )
