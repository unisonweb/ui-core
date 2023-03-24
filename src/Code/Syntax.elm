module Code.Syntax exposing
    ( Linked(..)
    , LinkedWithTooltipConfig
    , Syntax
    , ToClick
    , TooltipConfig
    , Width(..)
    , decode
    , decodeSingleton
    , foldl
    , linkedWithTooltipConfig
    , numLines
    , reference
    , view
    )

import Code.Definition.Reference as Reference exposing (Reference)
import Code.FullyQualifiedName as FQN exposing (FQN)
import Code.Hash as Hash
import Code.HashQualified as HQ
import Code.Syntax.SyntaxHelp as SyntaxHelp
import Code.Syntax.SyntaxSegment exposing (..)
import Html exposing (Html, span, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onMouseEnter, onMouseLeave)
import Json.Decode as Decode exposing (andThen, at, field)
import Json.Decode.Extra exposing (when)
import Lib.Util as Util
import List.Nonempty as NEL
import UI.Click as Click exposing (Click)
import UI.Tooltip as Tooltip exposing (Tooltip)


type Width
    = Width Int


type Syntax
    = Syntax (NEL.Nonempty SyntaxSegment)


type alias TooltipConfig msg =
    { toHoverStart : Reference -> msg
    , toHoverEnd : Reference -> msg
    , toTooltip : Reference -> Maybe (Tooltip msg)
    }


type alias ToClick msg =
    Reference -> Click msg


type alias LinkedWithTooltipConfig msg =
    { toClick : ToClick msg
    , tooltip : TooltipConfig msg
    }


type Linked msg
    = Linked (ToClick msg)
    | LinkedWithTooltip (LinkedWithTooltipConfig msg)
    | NotLinked



-- HELPERS


linkedWithTooltipConfig :
    ToClick msg
    -> TooltipConfig msg
    -> LinkedWithTooltipConfig msg
linkedWithTooltipConfig toClick tooltipConfig =
    { toClick = toClick, tooltip = tooltipConfig }


{-| TODO: Parse Syntax into a list of lines and this function can be removed
-}
numLines : Syntax -> Int
numLines (Syntax segments) =
    let
        count (SyntaxSegment _ segment) acc =
            if String.contains "\n" segment then
                acc + 1

            else
                acc
    in
    NEL.foldl count 1 segments


reference : SyntaxSegment -> Maybe Reference
reference (SyntaxSegment syntaxType _) =
    case syntaxType of
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


foldl : (SyntaxSegment -> b -> b) -> b -> Syntax -> b
foldl f init (Syntax segments) =
    NEL.foldl f init segments



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


viewSegment : Linked msg -> SyntaxSegment -> Html msg
viewSegment linked ((SyntaxSegment sType sText) as segment) =
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
            case SyntaxHelp.get segment of
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


view : Linked msg -> Syntax -> Html msg
view linked (Syntax segments) =
    let
        renderedSegments =
            segments
                |> NEL.map (viewSegment linked)
                |> NEL.toList
    in
    span [ class "syntax" ] renderedSegments



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


decodeOp : Decode.Decoder SyntaxType
decodeOp =
    let
        decodeOpTag =
            at [ "annotation", "contents", "tag" ] Decode.string
    in
    Decode.map
        Op
        (Decode.oneOf
            [ when decodeOpTag ((==) "Cons") (Decode.succeed Cons)
            , when decodeOpTag ((==) "Snoc") (Decode.succeed Snoc)
            , when decodeOpTag ((==) "Concat") (Decode.succeed Concat)
            ]
        )


decodeTag : Decode.Decoder String
decodeTag =
    Decode.oneOf
        [ at [ "annotation", "tag" ] Decode.string
        , Decode.succeed "Blank"
        ]


decodeSyntaxSegment : Decode.Decoder SyntaxSegment
decodeSyntaxSegment =
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
                (at [ "annotation", "contents" ] Hash.decode)
                (Decode.maybe (field "segment" FQN.decode))

        decodeTypeReference =
            Decode.map2 TypeReference
                (at [ "annotation", "contents" ] Hash.decode)
                (Decode.maybe (field "segment" FQN.decode))

        decodeHashQualifier =
            Decode.map HashQualifier (at [ "annotation", "contents" ] Decode.string)
    in
    Decode.map2 SyntaxSegment
        (Decode.oneOf
            [ when decodeTag ((==) "TermReference") decodeReference
            , when decodeTag ((==) "TypeReference") decodeTypeReference
            , when decodeTag ((==) "Op") decodeOp
            , when decodeTag ((==) "HashQualifier") decodeHashQualifier
            , decodeTag |> andThen (simpleSyntaxTypeFromString >> Decode.succeed)
            ]
        )
        (field "segment" Decode.string)


decodeSingleton : Decode.Decoder Syntax
decodeSingleton =
    Decode.map Syntax (Decode.map NEL.fromElement decodeSyntaxSegment)


decode : Decode.Decoder Syntax
decode =
    Util.decodeNonEmptyList decodeSyntaxSegment |> andThen (Syntax >> Decode.succeed)
