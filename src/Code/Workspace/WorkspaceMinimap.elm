module Code.Workspace.WorkspaceMinimap exposing (viewWorkspaceMinimap)

import Code.Workspace.WorkspaceItem exposing (WorkspaceItem, viewMinimapEntry)
import Code.Workspace.WorkspaceItems exposing (WorkspaceItems(..))
import Html exposing (Html, div)
import Html.Attributes exposing (class, id)


viewWorkspaceMinimap : WorkspaceItems -> Html msg
viewWorkspaceMinimap workspaceItems =
    let
        header =
            Html.header []
                [ Html.text "MAP    "
                , Html.text "Close all"
                ]

        section =
            case workspaceItems of
                Empty ->
                    Html.text "empty"

                WorkspaceItems items ->
                    let
                        itemViews =
                            items
                                |> workspaceItemsToListWithFocus
                                |> List.indexedMap (\index ( focus, item ) -> viewWorkspaceMinimapItem item focus index)
                    in
                    itemViews
                        |> Html.tbody []
                        |> List.singleton
                        |> Html.table []
                        |> List.singleton
                        |> Html.section []
    in
    div
        []
        [ header
        , section
        ]


viewWorkspaceMinimapItem : WorkspaceItem -> Bool -> Int -> Html msg
viewWorkspaceMinimapItem item focused index =
    item
        |> viewMinimapEntry index focused
        |> List.singleton
        |> Html.td []
        |> List.singleton
        |> Html.tr [ class "workspace-minimap-entry" ]



-- mapWorkspaceItems :
--     (workspaceItem -> a)
--     ->
--         { before : List WorkspaceItem
--         , focus : WorkspaceItem
--         , after : List WorkspaceItem
--         }
--     ->
--         { before : List a
--         , focus : a
--         , after : List a
--         }
-- mapWorkspaceItems f items =
--     { before = List.map f items.before
--     , focus = f items.focus
--     , after = List.map f items.after
--     }


workspaceItemsToListWithFocus :
    { before : List a
    , focus : a
    , after : List a
    }
    -> List ( Bool, a )
workspaceItemsToListWithFocus items =
    List.map (\item -> ( False, item )) items.before
        ++ [ ( True, items.focus ) ]
        ++ List.map (\item -> ( False, item )) items.after
