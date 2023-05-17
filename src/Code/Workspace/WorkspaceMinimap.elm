module Code.Workspace.WorkspaceMinimap exposing (Msg(..), view)

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
import Html.Events exposing (onClick)
import Lib.OperatingSystem as OperatingSystem
import UI.Icon as Icon
import UI.KeyboardShortcut as KeyboardShortcut exposing (KeyboardShortcut(..))
import UI.KeyboardShortcut.Key as Key


type Msg
    = SelectItem WorkspaceItem
    | CloseAll


view : WorkspaceItems -> Html Msg
view workspaceItems =
    let
        header =
            viewHeader

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
        [ class "workspace-minimap-content" ]
        [ header
        , section
        ]


viewWorkspaceMinimapItem : WorkspaceItem -> Bool -> Int -> Html Msg
viewWorkspaceMinimapItem item focused index =
    item
        |> viewMinimapEntry index focused
        |> List.singleton
        |> Html.td []
        |> List.singleton
        |> Html.tr []


viewMinimapEntryKeyboardShortcut : KeyboardShortcut.Model -> Int -> Html Msg
viewMinimapEntryKeyboardShortcut keyboardShortcut index =
    KeyboardShortcut.view keyboardShortcut (Chord (Key.fromString "J") (Key.fromString (String.fromInt index)))


viewMinimapEntry_ : WorkspaceItem -> Int -> Info -> Category -> Bool -> Html Msg
viewMinimapEntry_ item index info category focused =
    div
        [ classList
            [ ( "workspace-minimap-entry", True )
            , ( "focused", focused )
            ]
        , onClick (SelectItem item)
        ]
        [ div [ class "workspace-minimap-entry-content" ]
            [ div [ class "category-icon" ] [ Icon.view (Category.icon category) ]
            , h3 [ class "name" ] [ FQN.view info.name ]
            ]
        , viewMinimapEntryKeyboardShortcut (KeyboardShortcut.init OperatingSystem.MacOS) index
        ]


viewMinimapEntry : Int -> Bool -> WorkspaceItem -> Html Msg
viewMinimapEntry index focused item =
    case item of
        Success _ itemData ->
            let
                ( info, category ) =
                    case itemData.item of
                        TermItem (Term _ category_ detail) ->
                            ( detail.info, Category.Term category_ )

                        TypeItem (Type _ category_ detail) ->
                            ( detail.info, Category.Type category_ )

                        DataConstructorItem (DataConstructor _ detail) ->
                            ( detail.info, Category.Type Type.DataType )

                        AbilityConstructorItem (AbilityConstructor _ detail) ->
                            ( detail.info, Category.Type Type.AbilityType )
            in
            viewMinimapEntry_ item index info category focused

        Failure _ _ ->
            Html.text "Failure"

        Loading _ ->
            Html.text "Loading"


viewHeader : Html Msg
viewHeader =
    Html.header [ class "workspace-minimap-header" ]
        [ Html.div [ class "workspace-minimap-title" ] [ Html.text "MAP" ]
        , Html.a [ class "close", onClick CloseAll ] [ Html.text "Close all" ]
        ]


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
