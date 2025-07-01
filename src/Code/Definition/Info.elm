module Code.Definition.Info exposing (..)

import Code.Definition.Reference as Reference exposing (Reference)
import Code.FullyQualifiedName as FQN exposing (FQN)
import List.Extra as ListE
import List.Nonempty as NEL



-- TODO: Without `otherNames` and if the `FQN` was added,
-- `Info` would be translatable to
-- `TermSummary`/`TypeSummary`.
-- Perhaps it should be `Naming` instead?
-- `otherNames` is a detail thing only.


type alias Info =
    { name : FQN
    , namespace : Maybe FQN
    , otherNames : List FQN
    }


makeInfo : Reference -> FQN -> NEL.Nonempty FQN -> Info
makeInfo ref suffixName allFqns_ =
    let
        ( namespace, otherNames ) =
            namespaceAndOtherNames ref suffixName allFqns_
    in
    Info suffixName namespace otherNames



-- Helpers


allFqns : Info -> List FQN
allFqns info =
    let
        reconstructed =
            info.namespace
                |> Maybe.map (\namespace -> FQN.extend namespace info.name)
                |> Maybe.withDefault info.name
    in
    ListE.uniqueBy FQN.toString (reconstructed :: info.otherNames)


namespaceAndOtherNames : Reference -> FQN -> NEL.Nonempty FQN -> ( Maybe FQN, List FQN )
namespaceAndOtherNames requestedRef suffixName fqns =
    let
        shortest =
            NEL.sortBy FQN.numSegments >> NEL.head

        shortestSuffixMatching =
            let
                defaultFqn =
                    shortest fqns
            in
            fqns
                |> NEL.filter (FQN.isSuffixOf suffixName) defaultFqn
                |> shortest

        ( namespace, fqnWithin ) =
            case Reference.fqn requestedRef of
                Just requestedName ->
                    if FQN.isSuffixOf suffixName requestedName then
                        let
                            toTake =
                                FQN.length requestedName - FQN.length suffixName
                        in
                        ( Just (FQN.take toTake requestedName), shortestSuffixMatching )

                    else
                        ( FQN.namespace shortestSuffixMatching, shortestSuffixMatching )

                Nothing ->
                    ( FQN.namespace shortestSuffixMatching, shortestSuffixMatching )

        fqnsWithout =
            fqns
                |> NEL.toList
                |> ListE.filterNot (FQN.equals fqnWithin)
                |> ListE.uniqueBy FQN.toString
    in
    ( namespace, fqnsWithout )
