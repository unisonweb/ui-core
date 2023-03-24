module Code.Syntax.SyntaxSegment exposing (..)

import Code.FullyQualifiedName exposing (FQN)
import Code.Hash exposing (Hash)


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
