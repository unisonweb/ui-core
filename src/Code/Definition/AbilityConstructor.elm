module Code.Definition.AbilityConstructor exposing
    ( AbilityConstructor(..)
    , AbilityConstructorDetail
    , AbilityConstructorListing
    , AbilityConstructorSource(..)
    , AbilityConstructorSummary
    , decodeSignature
    , decodeSource
    , rawSource
    )

import Code.Definition.Info exposing (Info)
import Code.Definition.Term as Term exposing (TermSignature)
import Code.Definition.Type as Type exposing (TypeSource)
import Code.FullyQualifiedName exposing (FQN)
import Code.Hash exposing (Hash)
import Code.Syntax as Syntax exposing (Syntax)
import Json.Decode as Decode


type AbilityConstructorSource
    = Source Syntax
    | Builtin


type AbilityConstructor a
    = AbilityConstructor Hash a


type alias AbilityConstructorDetail =
    AbilityConstructor { info : Info, source : TypeSource, signature : TermSignature }


type alias AbilityConstructorSummary =
    AbilityConstructor
        { fqn : FQN
        , name : FQN
        , namespace : Maybe String
        , signature : TermSignature
        }


type alias AbilityConstructorListing =
    AbilityConstructor FQN



-- HELPERS


rawSource : AbilityConstructorDetail -> Maybe String
rawSource (AbilityConstructor _ { source }) =
    case source of
        Type.Source stx ->
            Just (Syntax.toString stx)

        Type.Builtin ->
            Nothing



-- JSON DECODERS


decodeSource : List String -> List String -> Decode.Decoder TypeSource
decodeSource =
    Type.decodeTypeSource


decodeSignature : List String -> Decode.Decoder TermSignature
decodeSignature =
    Term.decodeSignature
