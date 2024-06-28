module Code.Syntax.SyntaxSegment exposing (..)

import Code.FullyQualifiedName as FQN exposing (FQN)
import Code.Hash as Hash exposing (Hash)
import Json.Decode as Decode exposing (andThen, at, field)
import Json.Decode.Extra exposing (when)


type SyntaxSegment
    = SyntaxSegment SyntaxType String


type SeqOp
    = Cons
    | Snoc
    | Concat


type SyntaxType
    = NumericLiteral
    | TextLiteral
    | BytesLiteral
    | CharLiteral
    | BooleanLiteral
    | Blank
    | Var
    | TypeReference Hash (Maybe FQN)
    | TermReference Hash (Maybe FQN)
      -- +:|:+|++
    | Op SeqOp
    | DataConstructorReference Hash (Maybe FQN)
    | AbilityConstructorReference Hash (Maybe FQN)
    | AbilityBraces
      -- let|handle|in|where|match|with|cases|->|if|then|else|and|or
    | ControlKeyword
      -- forall|->
    | TypeOperator
    | BindingEquals
    | TypeAscriptionColon
      -- type|ability
    | DataTypeKeyword
    | DataTypeParams
    | Unit
      -- unique
    | DataTypeModifier
      -- `use Foo bar` is keyword, prefix, suffix
    | UseKeyword
    | UsePrefix
    | UseSuffix
      -- TODO: Should this be a HashQualified ?
    | HashQualifier String
      -- ! '
    | DelayForceChar
      -- ? , ` [ ] @ |
      -- Currently not all commas in the pretty-print output are marked up as DelimiterChar - we miss
      -- out characters emitted by Pretty.hs helpers like Pretty.commas.
    | DelimiterChar
    | Parenthesis
    | LinkKeyword -- `typeLink` and `termLink`
      -- [: :] @[]
    | DocDelimiter
      -- the 'include' in @[include], etc
    | DocKeyword



-- JSON DECODE


simpleSyntaxTypeFromString : String -> SyntaxType
simpleSyntaxTypeFromString rawType =
    case rawType of
        "NumericLiteral" ->
            NumericLiteral

        "TextLiteral" ->
            TextLiteral

        "BytesLiteral" ->
            BytesLiteral

        "CharLiteral" ->
            CharLiteral

        "BooleanLiteral" ->
            BooleanLiteral

        "Blank" ->
            Blank

        "Var" ->
            Var

        "AbilityBraces" ->
            AbilityBraces

        "ControlKeyword" ->
            ControlKeyword

        "TypeOperator" ->
            TypeOperator

        "BindingEquals" ->
            BindingEquals

        "TypeAscriptionColon" ->
            TypeAscriptionColon

        "DataTypeKeyword" ->
            DataTypeKeyword

        "DataTypeParams" ->
            DataTypeParams

        "Unit" ->
            Unit

        "DataTypeModifier" ->
            DataTypeModifier

        "UseKeyword" ->
            UseKeyword

        "UsePrefix" ->
            UsePrefix

        "UseSuffix" ->
            UseSuffix

        "DelayForceChar" ->
            DelayForceChar

        "DelimiterChar" ->
            DelimiterChar

        "Parenthesis" ->
            Parenthesis

        "LinkKeyword" ->
            LinkKeyword

        "DocDelimiter" ->
            DocDelimiter

        "DocKeyword" ->
            DocKeyword

        _ ->
            Blank


decodeOp : String -> Decode.Decoder SyntaxType
decodeOp annotationField =
    let
        decodeOpTag =
            at [ annotationField, "contents", "tag" ] Decode.string
    in
    Decode.map
        Op
        (Decode.oneOf
            [ when decodeOpTag ((==) "Cons") (Decode.succeed Cons)
            , when decodeOpTag ((==) "Snoc") (Decode.succeed Snoc)
            , when decodeOpTag ((==) "Concat") (Decode.succeed Concat)
            ]
        )


decodeTag : String -> Decode.Decoder String
decodeTag annotationField =
    Decode.oneOf
        [ at [ annotationField, "tag" ] Decode.string
        , Decode.succeed "Blank"
        ]


decode_ : { segmentField : String, annotationField : String } -> Decode.Decoder SyntaxSegment
decode_ { segmentField, annotationField } =
    let
        hashToReference hash fqn =
            if Hash.isDataConstructorHash hash then
                DataConstructorReference hash fqn

            else if Hash.isAbilityConstructorHash hash then
                AbilityConstructorReference hash fqn

            else
                TermReference hash fqn

        decodeReference =
            Decode.map2 hashToReference
                (at [ annotationField, "contents" ] Hash.decode)
                (Decode.maybe (field "segment" FQN.decode))

        decodeTypeReference =
            Decode.map2 TypeReference
                (at [ annotationField, "contents" ] Hash.decode)
                (Decode.maybe (field "segment" FQN.decode))

        decodeHashQualifier =
            Decode.map HashQualifier (at [ annotationField, "contents" ] Decode.string)

        decodeTag_ =
            decodeTag annotationField
    in
    Decode.map2 SyntaxSegment
        (Decode.oneOf
            [ when decodeTag_ ((==) "TermReference") decodeReference
            , when decodeTag_ ((==) "TypeReference") decodeTypeReference
            , when decodeTag_ ((==) "Op") (decodeOp annotationField)
            , when decodeTag_ ((==) "HashQualifier") decodeHashQualifier
            , decodeTag_ |> andThen (simpleSyntaxTypeFromString >> Decode.succeed)
            ]
        )
        (field segmentField Decode.string)


decode : Decode.Decoder SyntaxSegment
decode =
    decode_ { segmentField = "segment", annotationField = "annotation" }
