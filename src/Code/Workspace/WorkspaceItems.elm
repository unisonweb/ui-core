{-
   WorkspaceItems is the main data structure for working with definitions in
   the Workspace area. It supports holding Loading definitions and inserting
   definitions after another.

   It features a `focus` indicator and a before and after just like a Zipper.
   `focus` can be changed with `next` and `prev`.

   Invariants:
     It structurally can't hold the invariant that it should not contain
     duplicates, so this is instead enforced via the API; uniqueness is
     determined by Reference and Hash.
-}
-- TODO: All reference equality check should reach into definition for hash
-- equality when possible


module Code.Workspace.WorkspaceItems exposing (..)

import Code.Definition.Reference exposing (Reference)
import Code.FullyQualifiedName exposing (FQN)
import Code.Hash exposing (Hash)
import Code.Workspace.WorkspaceItem as WorkspaceItem exposing (WorkspaceItem)
import List
import List.Extra as ListE
import Maybe.Extra as MaybeE


{-| This technically allows multiple of the same definition across the 3 fields.
This is conceptionally not allowed and is enforced by the helper functions.
-}
type WorkspaceItems
    = Empty
    | WorkspaceItems
        { before : List WorkspaceItem
        , focus : WorkspaceItem
        , after : List WorkspaceItem
        }


init : Maybe WorkspaceItem -> WorkspaceItems
init focused =
    case focused of
        Nothing ->
            Empty

        Just i ->
            singleton i


fromItems :
    List WorkspaceItem
    -> WorkspaceItem
    -> List WorkspaceItem
    -> WorkspaceItems
fromItems before focus_ after =
    WorkspaceItems { before = before, focus = focus_, after = after }


empty : WorkspaceItems
empty =
    Empty


isEmpty : WorkspaceItems -> Bool
isEmpty workspaceItems =
    case workspaceItems of
        Empty ->
            True

        WorkspaceItems _ ->
            False


length : WorkspaceItems -> Int
length items =
    items
        |> toList
        |> List.length


singleton : WorkspaceItem -> WorkspaceItems
singleton item =
    WorkspaceItems { before = [], focus = item, after = [] }



-- MODIFY


appendWithFocus : WorkspaceItems -> WorkspaceItem -> WorkspaceItems
appendWithFocus items item =
    WorkspaceItems { before = toList items, focus = item, after = [] }


prependWithFocus : WorkspaceItems -> WorkspaceItem -> WorkspaceItems
prependWithFocus workspaceItems item =
    case workspaceItems of
        Empty ->
            singleton item

        WorkspaceItems items ->
            WorkspaceItems
                { before = []
                , focus = item
                , after =
                    items.before ++ (items.focus :: items.after)
                }


{-| Insert before a Hash. If the Hash is not in WorkspaceItems, insert with
focus. If the element to insert already exists in WorkspaceItems, move it to
after the provided Hash
-}
insertWithFocusBefore :
    WorkspaceItems
    -> Reference
    -> WorkspaceItem
    -> WorkspaceItems
insertWithFocusBefore items beforeRef toInsert =
    case items of
        Empty ->
            singleton toInsert

        WorkspaceItems _ ->
            if member items beforeRef then
                let
                    insertBefore item =
                        if WorkspaceItem.isSameReference item beforeRef then
                            [ toInsert, item ]

                        else
                            [ item ]

                    make ( before, afterInclusive ) =
                        WorkspaceItems
                            { before = before
                            , focus = toInsert
                            , after = List.drop 1 afterInclusive
                            }
                in
                items
                    |> toList
                    |> List.concatMap insertBefore
                    |> ListE.splitWhen (WorkspaceItem.isSameByReference toInsert)
                    |> Maybe.map make
                    |> Maybe.withDefault (singleton toInsert)

            else
                prependWithFocus items toInsert


{-| Insert after a Hash. If the Hash is not in WorkspaceItems, insert at the
end. If the element to insert already exists in WorkspaceItems, move it to
after the provided Hash
-}
insertWithFocusAfter :
    WorkspaceItems
    -> Reference
    -> WorkspaceItem
    -> WorkspaceItems
insertWithFocusAfter items afterRef toInsert =
    case items of
        Empty ->
            singleton toInsert

        WorkspaceItems _ ->
            if member items afterRef then
                let
                    insertAfter item =
                        if WorkspaceItem.isSameReference item afterRef then
                            [ item, toInsert ]

                        else
                            [ item ]

                    make ( before, afterInclusive ) =
                        WorkspaceItems
                            { before = before
                            , focus = toInsert
                            , after = List.drop 1 afterInclusive
                            }
                in
                items
                    |> toList
                    |> List.concatMap insertAfter
                    |> ListE.splitWhen (WorkspaceItem.isSameByReference toInsert)
                    |> Maybe.map make
                    |> Maybe.withDefault (singleton toInsert)

            else
                appendWithFocus items toInsert


replace : WorkspaceItems -> Reference -> WorkspaceItem -> WorkspaceItems
replace items ref newItem =
    let
        replaceMatching i =
            if WorkspaceItem.isSameReference i ref then
                newItem

            else
                i
    in
    map replaceMatching items


{-| Replace item if item with the same reference exist, or prepend as a new item|
-}
replaceOrPrependWithFocus : WorkspaceItems -> Reference -> WorkspaceItem -> WorkspaceItems
replaceOrPrependWithFocus items ref newItem =
    if member items ref then
        replace items ref newItem

    else
        prependWithFocus items newItem


remove : WorkspaceItems -> Reference -> WorkspaceItems
remove items ref =
    case items of
        Empty ->
            Empty

        WorkspaceItems data ->
            let
                without r =
                    ListE.filterNot (\i -> WorkspaceItem.isSameReference i r)
            in
            if WorkspaceItem.isSameReference data.focus ref then
                let
                    rightBeforeFocus =
                        ListE.last data.before

                    rightAfterFocus =
                        List.head data.after
                in
                case rightAfterFocus of
                    Just i ->
                        WorkspaceItems
                            { before = data.before
                            , focus = i
                            , after = without (WorkspaceItem.reference i) data.after
                            }

                    Nothing ->
                        case rightBeforeFocus of
                            Just i ->
                                WorkspaceItems
                                    { before = without (WorkspaceItem.reference i) data.before
                                    , focus = i
                                    , after = data.after
                                    }

                            Nothing ->
                                Empty

            else
                WorkspaceItems
                    { before = without ref data.before
                    , focus = data.focus
                    , after = without ref data.after
                    }



-- QUERY


{-| TODO: Support NameOnly better
-}
member : WorkspaceItems -> Reference -> Bool
member items ref =
    items |> references |> List.member ref


hashes : WorkspaceItems -> List Hash
hashes items =
    items
        |> toList
        |> List.map WorkspaceItem.hash
        |> MaybeE.values


references : WorkspaceItems -> List Reference
references items =
    items
        |> toList
        |> List.map WorkspaceItem.reference


fqns : WorkspaceItems -> List FQN
fqns items =
    concatMapToList (\i _ -> WorkspaceItem.allFqns i) items


head : WorkspaceItems -> Maybe WorkspaceItem
head items =
    items
        |> toList
        |> List.head


last : WorkspaceItems -> Maybe WorkspaceItem
last items =
    items
        |> toList
        |> ListE.last



-- Focus


focus : WorkspaceItems -> Maybe WorkspaceItem
focus items =
    case items of
        Empty ->
            Nothing

        WorkspaceItems data ->
            Just data.focus


focusedReference : WorkspaceItems -> Maybe Reference
focusedReference items =
    items
        |> focus
        |> Maybe.map WorkspaceItem.reference


focusOn : WorkspaceItems -> Reference -> WorkspaceItems
focusOn items ref =
    let
        fromSplits ( before, afterInclusive ) =
            case afterInclusive of
                [] ->
                    Nothing

                newFocus :: after ->
                    Just { before = before, focus = newFocus, after = after }
    in
    items
        |> toList
        |> ListE.splitWhen (\i -> WorkspaceItem.isSameReference i ref)
        |> Maybe.andThen fromSplits
        |> Maybe.map WorkspaceItems
        |> Maybe.withDefault items


isFocused : WorkspaceItems -> Reference -> Bool
isFocused workspaceItems ref =
    workspaceItems
        |> focus
        |> Maybe.map (\i -> WorkspaceItem.isSameReference i ref)
        |> Maybe.withDefault False


focusIndex : WorkspaceItems -> Maybe Int
focusIndex workspaceItems =
    case workspaceItems of
        Empty ->
            Nothing

        WorkspaceItems items ->
            items.before
                |> List.length
                |> Maybe.Just


{-| Moves the focused item up before the previous item, keeps focus |
-}
moveUp : WorkspaceItems -> WorkspaceItems
moveUp items =
    case items of
        Empty ->
            Empty

        WorkspaceItems data ->
            case ListE.unconsLast data.before of
                Nothing ->
                    items

                Just ( i, before ) ->
                    WorkspaceItems
                        { before = before
                        , focus = data.focus
                        , after = i :: data.after
                        }


{-| Moves the focused item down before the next item, keeps focus |
-}
moveDown : WorkspaceItems -> WorkspaceItems
moveDown items =
    case items of
        Empty ->
            Empty

        WorkspaceItems data ->
            case data.after of
                [] ->
                    items

                i :: after ->
                    WorkspaceItems
                        { before = data.before ++ [ i ]
                        , focus = data.focus
                        , after = after
                        }


next : WorkspaceItems -> WorkspaceItems
next items =
    case items of
        Empty ->
            Empty

        WorkspaceItems data ->
            case data.after of
                [] ->
                    items

                newFocus :: rest ->
                    WorkspaceItems
                        { before = data.before ++ [ data.focus ]
                        , focus = newFocus
                        , after = rest
                        }


prev : WorkspaceItems -> WorkspaceItems
prev items =
    case items of
        Empty ->
            Empty

        WorkspaceItems data ->
            case ListE.unconsLast data.before of
                Nothing ->
                    items

                Just ( newFocus, newBefore ) ->
                    WorkspaceItems
                        { before = newBefore
                        , focus = newFocus
                        , after = data.focus :: data.after
                        }



-- TRANFORM


updateData :
    (WorkspaceItem.ItemData -> WorkspaceItem.ItemData)
    -> Reference
    -> WorkspaceItems
    -> WorkspaceItems
updateData f ref wItems =
    let
        update_ workspaceItem =
            case workspaceItem of
                WorkspaceItem.Success refResponse d ->
                    if ref == refResponse then
                        WorkspaceItem.Success refResponse (f d)

                    else
                        workspaceItem

                _ ->
                    workspaceItem
    in
    map update_ wItems


map :
    (WorkspaceItem -> WorkspaceItem)
    -> WorkspaceItems
    -> WorkspaceItems
map f wItems =
    case wItems of
        Empty ->
            Empty

        WorkspaceItems data ->
            WorkspaceItems
                { before = List.map f data.before
                , focus = f data.focus
                , after = List.map f data.after
                }


find : (WorkspaceItem -> Bool) -> WorkspaceItems -> Maybe WorkspaceItem
find pred wItems =
    wItems
        |> toList
        |> ListE.find pred


all : (WorkspaceItem -> Bool) -> WorkspaceItems -> Bool
all pred wItems =
    wItems
        |> toList
        |> List.all pred


any : (WorkspaceItem -> Bool) -> WorkspaceItems -> Bool
any pred wItems =
    wItems
        |> toList
        |> List.any pred


mapToList : (WorkspaceItem -> Bool -> a) -> WorkspaceItems -> List a
mapToList f wItems =
    case wItems of
        Empty ->
            []

        WorkspaceItems data ->
            let
                before =
                    data.before
                        |> List.map (\i -> f i False)

                after =
                    data.after
                        |> List.map (\i -> f i False)
            in
            before ++ (f data.focus True :: after)


concatMapToList : (WorkspaceItem -> Bool -> List a) -> WorkspaceItems -> List a
concatMapToList f wItems =
    case wItems of
        Empty ->
            []

        WorkspaceItems data ->
            let
                before =
                    data.before
                        |> List.concatMap (\i -> f i False)

                after =
                    data.after
                        |> List.concatMap (\i -> f i False)
            in
            before ++ f data.focus True ++ after


{-| Converting the workspace items to a list, looses the focus indicator
-}
toList : WorkspaceItems -> List WorkspaceItem
toList wItems =
    case wItems of
        Empty ->
            []

        WorkspaceItems items ->
            items.before ++ (items.focus :: items.after)
