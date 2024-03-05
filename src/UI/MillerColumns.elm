{-

   Miller Columns: a browsing alternative to  tree views
   =====================================================

        ╭───────────┬──────────────┬────────────╮
        │   Nat    │   fromUtf8  │   impl    │
        │   Nat    │   fromUtf8  │   partial │
        │   Text   │   gt        │   partial │
        │   Text   │   gt        │   stream  │
        │   Unit   │              │            │
        │   Unit   │              │            │
        ╰───────────┴──────────────┴────────────╯

   Most commonly Miller Columns are found in the MacOS Finder.
   Read more: https://en.wikipedia.org/wiki/Miller_columns

   ## Data structures
   The core data structure (from a intuition standpoint) is a list of Columns.
   Each Column includes a list of Item, which in-turn can contain children
   in the form of another column.
   Selection in a Column is tracked with a Zipper and a Tree.
-}


module UI.MillerColumns exposing (..)

import Code.CodebaseTree exposing (Msg)
import Html exposing (Html, div, text)
import Html.Attributes exposing (class, classList)
import RemoteData exposing (RemoteData(..), WebData)
import UI.Click as Click


type alias Item a =
    { label : String
    , value : a
    }


type Selection a
    = Node { item : Item a, children : Column a }
    | Leaf (Item a)


type Column a
    = NoSelection (WebData (List (Item a)))
    | WithSelection
        (WebData
            { before : List (Item a)
            , selected : Selection a
            , after : List (Item a)
            }
        )


type alias MillerColumns a msg =
    { root : Column a
    , onSelectMsg : a -> msg
    }


millerColumns : (a -> msg) -> WebData (List (Item a)) -> MillerColumns a msg
millerColumns onSelectMsg items =
    { root = NoSelection items
    , onSelectMsg = onSelectMsg
    }


viewItem : Bool -> Item a -> Html msg
viewItem isSelected item =
    div [ class "item", classList [ ( "item_selected", isSelected ) ] ]
        [ text item.label ]


viewColumn : List (Html msg) -> Html msg
viewColumn items =
    div [ class "column" ] items


view : MillerColumns a msg -> Html msg
view millerColumns_ =
    let
        viewUnselectedItems items =
            List.map (viewItem False) items

        viewSelectedItem i =
            viewItem True i

        go col =
            case col of
                NoSelection items ->
                    [ viewColumn (viewUnselectedItems items) ]

                WithSelection items ->
                    let
                        before =
                            viewUnselectedItems items.before

                        after =
                            viewUnselectedItems items.after
                    in
                    case items.selected of
                        Node s ->
                            viewColumn
                                (before ++ viewSelectedItem s.item :: after)
                                :: go s.children

                        Leaf i ->
                            [ viewColumn
                                (before
                                    ++ Click.view [] [ viewSelectedItem i ] (Click.onClick (millerColumns_.onSelectMsg i.value))
                                    :: after
                                )
                            ]

        columns =
            go millerColumns_.root
    in
    div [ class "columns" ] columns
