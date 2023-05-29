module Code.Workspace.WorkspaceMinimap exposing (Minimap, view)

import Code.Definition.AbilityConstructor exposing (AbilityConstructor(..))
import Code.Definition.Category as Category exposing (Category)
import Code.Definition.DataConstructor exposing (DataConstructor(..))
import Code.Definition.Term exposing (Term(..))
import Code.Definition.Type as Type exposing (Type(..))
import Code.FullyQualifiedName as FQN
import Code.Workspace.WorkspaceItem exposing (Item(..), WorkspaceItem(..))
import Code.Workspace.WorkspaceItems exposing (WorkspaceItems, mapToList)
import Html exposing (Html, div, h3, header, text)
import Html.Attributes exposing (class, classList, hidden)
import Html.Events exposing (onClick)
import UI.Click as Click
import UI.Icon as Icon
import UI.KeyboardShortcut as KeyboardShortcut exposing (KeyboardShortcut(..))
import UI.KeyboardShortcut.Key as Key


type alias Minimap msg =
    { keyboardShortcut : KeyboardShortcut.Model
    , workspaceItems : WorkspaceItems
    , selectItemMsg : WorkspaceItem -> msg
    , closeAllMsg : msg
    }


view : Minimap msg -> Html msg
view model =
    let
        header =
            viewHeader model.closeAllMsg

        section =
            model.workspaceItems
                |> mapToList Tuple.pair
                |> List.indexedMap (viewEntry model.selectItemMsg model.keyboardShortcut)
                |> Html.section []
    in
    div
        [ class "workspace-minimap-content" ]
        [ header
        , section
        ]


viewHeader : msg -> Html msg
viewHeader closeAllMsg =
    header
        [ class "workspace-minimap-header" ]
        [ div
            [ class "workspace-minimap-title" ]
            [ text "MAP" ]
        , Click.view
            [ class "close" ]
            [ text "Close all" ]
            (Click.onClick closeAllMsg)
        ]


viewEntry : (WorkspaceItem -> msg) -> KeyboardShortcut.Model -> Int -> ( WorkspaceItem, Bool ) -> Html msg
viewEntry selectItem keyboardShortcut index ( item, focused ) =
    let
        content =
            case item of
                Loading _ ->
                    [ div
                        [ class "name" ]
                        [ text "Loading" ]
                    ]

                Failure _ _ ->
                    [ div
                        [ class "name" ]
                        [ text "Failure" ]
                    ]

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
                    [ viewEntryContent category info.name
                    , div
                        [ hidden True ]
                        -- currently hidden as feature is not supported yet
                        [ viewEntryKeyboardShortcut keyboardShortcut index ]
                    ]
    in
    div
        [ classList
            [ ( "workspace-minimap-entry", True )
            , ( "focused", focused )
            ]
        , onClick (selectItem item)
        ]
        content


viewEntryContent : Category -> FQN.FQN -> Html msg
viewEntryContent category name =
    div
        [ class "workspace-minimap-entry-content" ]
        [ div
            [ class "category-icon" ]
            [ Icon.view (Category.icon category) ]
        , h3
            [ class "name" ]
            [ FQN.view name ]
        ]


viewEntryKeyboardShortcut : KeyboardShortcut.Model -> Int -> Html msg
viewEntryKeyboardShortcut model index =
    KeyboardShortcut.view model (Chord (Key.fromString "J") (Key.fromString (String.fromInt index)))
