module Code.Workspace.WorkspaceMinimap exposing (viewWorkspaceMinimap)

import Code.Definition.AbilityConstructor exposing (AbilityConstructor(..))
import Code.Definition.Category as Category exposing (Category)
import Code.Definition.DataConstructor exposing (DataConstructor(..))
import Code.Definition.Info exposing (Info)
import Code.Definition.Term exposing (Term(..))
import Code.Definition.Type as Type exposing (Type(..))
import Code.FullyQualifiedName as FQN
import Code.Workspace.WorkspaceItem exposing (Item(..), WorkspaceItem(..))
import Code.Workspace.WorkspaceItems exposing (WorkspaceItems(..))
import Html exposing (Html, div, h3)
import Html.Attributes exposing (class, classList)
import Lib.OperatingSystem as OperatingSystem
import UI.Icon as Icon
import UI.KeyboardShortcut as KeyboardShortcut exposing (KeyboardShortcut(..))
import UI.KeyboardShortcut.Key as Key


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


viewMinimapEntryKeyboardShortcut : KeyboardShortcut.Model -> Int -> Html msg
viewMinimapEntryKeyboardShortcut keyboardShortcut index =
    KeyboardShortcut.view keyboardShortcut (Chord (Key.fromString "J") (Key.fromString (String.fromInt index)))


viewMinimapEntry_ : Int -> Info -> Category -> Bool -> Html msg
viewMinimapEntry_ index info category focused =
    div [ class "workspace-minimap-entry", classList [ ( "focused", focused ) ] ]
        [ div [ class "category-icon" ] [ Icon.view (Category.icon category) ]
        , h3 [ class "name" ] [ FQN.view info.name ]
        , viewMinimapEntryKeyboardShortcut (KeyboardShortcut.init OperatingSystem.MacOS) index
        ]


viewMinimapEntry : Int -> Bool -> WorkspaceItem -> Html msg
viewMinimapEntry index focused item =
    case item of
        Success _ itemData ->
            case itemData.item of
                TermItem (Term _ category detail) ->
                    viewMinimapEntry_ index detail.info (Category.Term category) focused

                TypeItem (Type _ category detail) ->
                    viewMinimapEntry_ index detail.info (Category.Type category) focused

                DataConstructorItem (DataConstructor _ detail) ->
                    viewMinimapEntry_ index detail.info (Category.Type Type.DataType) focused

                AbilityConstructorItem (AbilityConstructor _ detail) ->
                    viewMinimapEntry_ index detail.info (Category.Type Type.AbilityType) focused

        Failure _ _ ->
            Html.text "Failure"

        Loading _ ->
            Html.text "Loading"


workspaceItemsToListWithFocus :
    { before : List a
    , focus : a
    , after : List a
    }
    -> List ( Bool, a )
workspaceItemsToListWithFocus items =
    List.map (\item -> ( False, item )) items.before
        ++ (( True, items.focus )
                :: List.map (\item -> ( False, item )) items.after
           )
