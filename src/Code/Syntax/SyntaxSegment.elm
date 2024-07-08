module Code.Syntax.SyntaxSegment exposing (..)

import Code.Definition.Reference as Reference
import Code.FullyQualifiedName as FQN exposing (FQN)
import Code.Hash as Hash exposing (Hash)
import Code.HashQualified as HQ
import Code.Syntax.Linked exposing (Linked(..))
import Html exposing (Html, span, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onMouseEnter, onMouseLeave)
import Json.Decode as Decode exposing (andThen, at, field)
import Json.Decode.Extra exposing (when)
import List.Nonempty as NEL
import UI.Click as Click
import UI.Tooltip as Tooltip


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



-- VIEW


syntaxTypeToClassName : SyntaxType -> String
syntaxTypeToClassName sType =
    case sType of
        NumericLiteral ->
            "numeric-literal"

        TextLiteral ->
            "text-literal"

        BytesLiteral ->
            "bytes-literal"

        CharLiteral ->
            "char-literal"

        BooleanLiteral ->
            "boolean-literal"

        Blank ->
            "blank"

        Var ->
            "var"

        TypeReference _ _ ->
            "type-reference"

        TermReference _ _ ->
            "term-reference"

        DataConstructorReference _ _ ->
            "data-constructor-reference"

        AbilityConstructorReference _ _ ->
            "ability-constructor-reference"

        Op seqOp ->
            case seqOp of
                Cons ->
                    "op cons"

                Snoc ->
                    "op snoc"

                Concat ->
                    "op concat"

        AbilityBraces ->
            "ability-braces"

        ControlKeyword ->
            "control-keyword"

        TypeOperator ->
            "type-operator"

        BindingEquals ->
            "binding-equals"

        TypeAscriptionColon ->
            "type-ascription-colon"

        DataTypeKeyword ->
            "data-type-keyword"

        DataTypeParams ->
            "data-type-params"

        Unit ->
            "unit"

        DataTypeModifier ->
            "data-type-modifier"

        UseKeyword ->
            "use-keyword"

        UsePrefix ->
            "use-prefix"

        UseSuffix ->
            "use-suffix"

        HashQualifier _ ->
            "hash-qualifier"

        DelayForceChar ->
            "delay-force-char"

        DelimiterChar ->
            "delimeter-char"

        Parenthesis ->
            "parenthesis"

        LinkKeyword ->
            "link-keyword"

        DocDelimiter ->
            "doc-delimeter"

        DocKeyword ->
            "doc-keyword"


viewFQN : FQN -> Html msg
viewFQN fqn =
    fqn
        |> FQN.segments
        |> NEL.map (\s -> span [ class "segment" ] [ text s ])
        |> NEL.toList
        |> List.intersperse (span [ class "sep" ] [ text "." ])
        |> span [ class "fqn" ]


view : Linked msg -> SyntaxSegment -> Html msg
view linked ((SyntaxSegment sType sText) as segment) =
    let
        ref =
            case sType of
                TypeReference h fqn ->
                    case fqn of
                        Just n ->
                            Just (Reference.TypeReference (HQ.HashQualified n h))

                        Nothing ->
                            Just (Reference.TypeReference (HQ.HashOnly h))

                TermReference h fqn ->
                    case fqn of
                        Just n ->
                            Just (Reference.TermReference (HQ.HashQualified n h))

                        Nothing ->
                            Just (Reference.TermReference (HQ.HashOnly h))

                AbilityConstructorReference h fqn ->
                    case fqn of
                        Just n ->
                            Just (Reference.AbilityConstructorReference (HQ.HashQualified n h))

                        Nothing ->
                            Just (Reference.AbilityConstructorReference (HQ.HashOnly h))

                DataConstructorReference h fqn ->
                    case fqn of
                        Just n ->
                            Just (Reference.DataConstructorReference (HQ.HashQualified n h))

                        Nothing ->
                            Just (Reference.DataConstructorReference (HQ.HashOnly h))

                _ ->
                    Nothing

        isFQN =
            let
                isFQN_ =
                    String.contains "." sText
            in
            case sType of
                TypeReference _ _ ->
                    isFQN_

                TermReference _ _ ->
                    isFQN_

                HashQualifier _ ->
                    isFQN_

                DataConstructorReference _ _ ->
                    isFQN_

                AbilityConstructorReference _ _ ->
                    isFQN_

                _ ->
                    False

        className =
            syntaxTypeToClassName sType

        content =
            if String.contains "->" sText then
                span [ class "arrow" ] [ text sText ]

            else if isFQN then
                viewFQN (FQN.fromString sText)

            else
                text sText
    in
    case ( linked, ref ) of
        ( Linked click, Just r ) ->
            Click.view
                [ class className ]
                [ content ]
                (click r)

        ( LinkedWithTooltip l, Just r ) ->
            let
                content_ =
                    case l.tooltip.toTooltip r of
                        Just t ->
                            Tooltip.view content t

                        Nothing ->
                            content
            in
            Click.view
                [ class className
                , onMouseEnter (l.tooltip.toHoverStart r)
                , onMouseLeave (l.tooltip.toHoverEnd r)
                ]
                [ content_ ]
                (l.toClick r)

        _ ->
            case helpForSegment segment of
                Just help ->
                    let
                        tooltip =
                            Tooltip.rich help
                                |> Tooltip.tooltip
                                |> Tooltip.withArrow Tooltip.Start
                                |> Tooltip.withPosition Tooltip.Below
                    in
                    Tooltip.view
                        (span
                            [ class className ]
                            [ content ]
                        )
                        tooltip

                _ ->
                    span
                        [ class className ]
                        [ content ]


helpForSegment : SyntaxSegment -> Maybe (Html msg)
helpForSegment _ =
    Nothing



-- DECODE


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
