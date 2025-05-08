module Code.Finder.FinderMatch exposing (..)

import Code.Definition.AbilityConstructor as AbilityConstructor exposing (AbilityConstructor(..), AbilityConstructorSummary)
import Code.Definition.DataConstructor as DataConstructor exposing (DataConstructor(..), DataConstructorSummary)
import Code.Definition.Reference exposing (Reference(..))
import Code.Definition.Term as Term exposing (Term(..), TermSummary)
import Code.Definition.Type as Type exposing (Type(..), TypeSummary)
import Code.FullyQualifiedName as FQN exposing (FQN)
import Code.Hash as Hash
import Code.HashQualified exposing (HashQualified(..))
import Json.Decode as Decode exposing (at, field, string)
import Json.Decode.Extra exposing (when)
import Lib.Decode.Helpers exposing (nonEmptyList, tag)
import List.Nonempty as NEL


type FinderItem
    = TermItem TermSummary
    | TypeItem TypeSummary
    | DataConstructorItem DataConstructorSummary
    | AbilityConstructorItem AbilityConstructorSummary


type MatchSegment
    = Gap String
    | Match String


type alias MatchSegments =
    NEL.Nonempty MatchSegment


type alias MatchPositions =
    NEL.Nonempty Int


type alias FinderMatch =
    { score : Int
    , matchSegments : MatchSegments
    , matchPositions : MatchPositions
    , item : FinderItem
    }



-- CREATE


finderMatch : Int -> MatchSegments -> FinderItem -> FinderMatch
finderMatch score matchSegments item =
    let
        matchPositions =
            matchSegmentsToMatchPositions matchSegments
    in
    FinderMatch score matchSegments matchPositions item



-- HELPERS


name : FinderMatch -> FQN
name fm =
    case fm.item of
        TypeItem (Type _ _ summary) ->
            summary.name

        TermItem (Term _ _ summary) ->
            summary.name

        DataConstructorItem (DataConstructor _ summary) ->
            summary.name

        AbilityConstructorItem (AbilityConstructor _ summary) ->
            summary.name


namespace : FinderMatch -> Maybe String
namespace fm =
    case fm.item of
        TypeItem (Type _ _ summary) ->
            summary.namespace

        TermItem (Term _ _ summary) ->
            summary.namespace

        DataConstructorItem (DataConstructor _ summary) ->
            summary.namespace

        AbilityConstructorItem (AbilityConstructor _ summary) ->
            summary.namespace


reference : FinderMatch -> Reference
reference fm =
    case fm.item of
        TypeItem (Type _ _ { fqn }) ->
            TypeReference (NameOnly fqn)

        TermItem (Term _ _ { fqn }) ->
            TermReference (NameOnly fqn)

        DataConstructorItem (DataConstructor _ { fqn }) ->
            DataConstructorReference (NameOnly fqn)

        AbilityConstructorItem (AbilityConstructor _ { fqn }) ->
            AbilityConstructorReference (NameOnly fqn)


matchSegmentsToMatchPositions : MatchSegments -> NEL.Nonempty Int
matchSegmentsToMatchPositions segments =
    let
        f s ( cur, is ) =
            case s of
                Gap str ->
                    ( cur + String.length str, is )

                Match str ->
                    let
                        matches =
                            str
                                |> String.toList
                                |> List.indexedMap (\i _ -> i + cur)
                    in
                    ( cur + String.length str, is ++ matches )

        ( _, positions ) =
            NEL.foldl f ( 0, [] ) segments
    in
    -- This `NEL.fromElement 0` is a random value to satisfy the Maybe. It
    -- is literally impossible (since there will always be a position for
    -- segments) and thats prolly a good indication that I'm not doing this
    -- right...
    Maybe.withDefault (NEL.fromElement 0) (NEL.fromList positions)



-- JSON DECODERS


decodeScore : Decode.Decoder Int
decodeScore =
    field "score" Decode.int


decodeTypeItem : Decode.Decoder FinderItem
decodeTypeItem =
    let
        makeSummary fqn name_ source =
            { fqn = fqn
            , name = name_
            , namespace = FQN.namespaceOf name_ fqn
            , source = source
            }
    in
    Decode.map TypeItem
        (Decode.map3 Type
            (at [ "namedType", "typeHash" ] Hash.decode)
            (Type.decodeTypeCategory [ "namedType", "typeTag" ])
            (Decode.map3 makeSummary
                (at [ "namedType", "typeName" ] FQN.decode)
                (field "bestFoundTypeName" FQN.decode)
                (Type.decodeTypeSource [ "typeDef", "tag" ] [ "typeDef", "contents" ])
            )
        )


decodeTermItem : Decode.Decoder FinderItem
decodeTermItem =
    let
        makeSummary fqn name_ signature =
            { fqn = fqn
            , name = name_
            , namespace = FQN.namespaceOf name_ fqn
            , signature = signature
            }
    in
    Decode.map TermItem
        (Decode.map3 Term
            (at [ "namedTerm", "termHash" ] Hash.decode)
            (Term.decodeTermCategory [ "namedTerm", "termTag" ])
            (Decode.map3 makeSummary
                (at [ "namedTerm", "termName" ] FQN.decode)
                (field "bestFoundTermName" FQN.decode)
                (Term.decodeSignature [ "namedTerm", "termType" ])
            )
        )


decodeAbilityConstructorItem : Decode.Decoder FinderItem
decodeAbilityConstructorItem =
    let
        makeSummary fqn name_ signature =
            { fqn = fqn
            , name = name_
            , namespace = FQN.namespaceOf name_ fqn
            , signature = signature
            }
    in
    Decode.map AbilityConstructorItem
        (Decode.map2 AbilityConstructor
            (at [ "namedTerm", "termHash" ] Hash.decode)
            (Decode.map3 makeSummary
                (at [ "namedTerm", "termName" ] FQN.decode)
                (field "bestFoundTermName" FQN.decode)
                (AbilityConstructor.decodeSignature [ "namedTerm", "termType" ])
            )
        )


decodeDataConstructorItem : Decode.Decoder FinderItem
decodeDataConstructorItem =
    let
        makeSummary fqn name_ signature =
            { fqn = fqn
            , name = name_
            , namespace = FQN.namespaceOf name_ fqn
            , signature = signature
            }
    in
    Decode.map DataConstructorItem
        (Decode.map2 DataConstructor
            (at [ "namedTerm", "termHash" ] Hash.decode)
            (Decode.map3 makeSummary
                (at [ "namedTerm", "termName" ] FQN.decode)
                (field "bestFoundTermName" FQN.decode)
                (DataConstructor.decodeSignature [ "namedTerm", "termType" ])
            )
        )


decodeItem : Decode.Decoder FinderItem
decodeItem =
    let
        termTypeByHash hash =
            if Hash.isAbilityConstructorHash hash then
                "AbilityConstructor"

            else if Hash.isDataConstructorHash hash then
                "DataConstructor"

            else
                "Term"

        decodeConstructorSuffix =
            Decode.map termTypeByHash (at [ "contents", "namedTerm", "termHash" ] Hash.decode)
    in
    Decode.oneOf
        [ when decodeConstructorSuffix ((==) "AbilityConstructor") (field "contents" decodeAbilityConstructorItem)
        , when decodeConstructorSuffix ((==) "DataConstructor") (field "contents" decodeDataConstructorItem)
        , when tag ((==) "FoundTermResult") (field "contents" decodeTermItem)
        , when tag ((==) "FoundTypeResult") (field "contents" decodeTypeItem)
        ]


decodeMatchSegments : Decode.Decoder (NEL.Nonempty MatchSegment)
decodeMatchSegments =
    let
        decodeMatchSegment =
            Decode.oneOf
                [ when (field "tag" string) ((==) "Gap") (Decode.map Gap (field "contents" string))
                , when (field "tag" string) ((==) "Match") (Decode.map Match (field "contents" string))
                ]
    in
    at [ "result", "segments" ] (nonEmptyList decodeMatchSegment)


decodeFinderMatch : Decode.Decoder FinderMatch
decodeFinderMatch =
    Decode.map3 finderMatch
        (Decode.index 0 decodeScore)
        (Decode.index 0 decodeMatchSegments)
        (Decode.index 1 decodeItem)


decodeMatches : Decode.Decoder (List FinderMatch)
decodeMatches =
    Decode.list decodeFinderMatch
