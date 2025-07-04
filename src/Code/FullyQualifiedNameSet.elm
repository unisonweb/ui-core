module Code.FullyQualifiedNameSet exposing
    ( FQNSet
    , empty
    , fromList
    , fromReference
    , fromReferenceList
    , insert
    , isPrefixOfAny
    , isSuffixOfAny
    , member
    , remove
    , singleton
    , size
    , toList
    , toggle
    )

import Code.Definition.Reference as Reference exposing (Reference)
import Code.FullyQualifiedName as FQN exposing (FQN)
import Maybe.Extra as MaybeE
import Set exposing (Set)
import Set.Extra



-- FQNSet - A Set wrapper for FQN


type FQNSet
    = FQNSet (Set String)


size : FQNSet -> Int
size (FQNSet set) =
    Set.size set


empty : FQNSet
empty =
    FQNSet Set.empty


singleton : FQN -> FQNSet
singleton fqn =
    FQNSet (fqn |> FQN.toString |> Set.singleton)


insert : FQN -> FQNSet -> FQNSet
insert fqn (FQNSet set) =
    FQNSet (Set.insert (FQN.toString fqn) set)


remove : FQN -> FQNSet -> FQNSet
remove fqn (FQNSet set) =
    FQNSet (Set.remove (FQN.toString fqn) set)


member : FQN -> FQNSet -> Bool
member fqn (FQNSet set) =
    Set.member (FQN.toString fqn) set


fromList : List FQN -> FQNSet
fromList fqns =
    FQNSet (fqns |> List.map FQN.toString |> Set.fromList)


fromReference : Reference -> FQNSet
fromReference ref =
    Reference.fqn ref
        |> Maybe.map singleton
        |> Maybe.withDefault empty


fromReferenceList : List Reference -> FQNSet
fromReferenceList refs =
    refs
        |> List.map Reference.fqn
        |> MaybeE.values
        |> fromList


toList : FQNSet -> List FQN
toList (FQNSet set) =
    set
        |> Set.toList
        |> List.map FQN.fromString


isPrefixOfAny : FQNSet -> FQN -> Bool
isPrefixOfAny (FQNSet set) prefixFqn =
    set
        |> Set.toList
        |> List.map FQN.fromString
        |> List.any
            (\item ->
                FQN.isPrefixOf prefixFqn item && not (FQN.equals item prefixFqn)
            )


isSuffixOfAny : FQNSet -> FQN -> Bool
isSuffixOfAny (FQNSet set) suffixFqn =
    set
        |> Set.toList
        |> List.map FQN.fromString
        |> List.any
            (\item ->
                FQN.isSuffixOf suffixFqn item && not (FQN.equals item suffixFqn)
            )


toggle : FQN -> FQNSet -> FQNSet
toggle fqn (FQNSet set) =
    FQNSet (Set.Extra.toggle (FQN.toString fqn) set)
