module Code.Syntax.SyntaxSegment exposing (..)

import Code.Definition.Reference as Reference
import Code.FullyQualifiedName as FQN exposing (FQN)
import Code.Hash as Hash exposing (Hash)
import Code.HashQualified as HQ
import Code.Syntax.SyntaxConfig exposing (SyntaxConfig)
import Code.Syntax.SyntaxSegmentHelp as SyntaxSegmentHelp
import Html exposing (Html, span, text)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onMouseEnter, onMouseLeave)
import Json.Decode as Decode exposing (at, field)
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
      -- ' ()
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


toString : SyntaxSegment -> String
toString (SyntaxSegment _ seg) =
    seg



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


view : SyntaxConfig msg -> SyntaxSegment -> Html msg
view syntaxConfig ((SyntaxSegment sType sText) as segment) =
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

        content view_ =
            if String.contains "->" sText then
                view_ (span [ class "arrow" ] [ text sText ])

            else if isFQN then
                view_ (viewFQN (FQN.fromString sText))

            else if sType == TextLiteral then
                -- Spaces matter in a text literal, so we don't try and trim it
                -- (though this results in the front including some extra spaces
                -- in the hover effect).
                view_ (text sText)

            else if sText /= " " && (String.startsWith " " sText || String.endsWith " " sText) then
                -- If the text is not the empty string and is either prefixed
                -- or suffixed with a space, we want that to not be part of a
                -- hover background, so it gets separate to another dom node.
                -- This results in cleaner looking hovers and tooltip
                -- positionings
                let
                    f c ( start, middle, end ) =
                        let
                            s =
                                String.fromChar c
                        in
                        if c == ' ' || c == '\n' then
                            if String.isEmpty middle then
                                ( start ++ s, middle, end )

                            else
                                ( start, middle, end ++ s )

                        else
                            ( start, middle ++ s, end )

                    viewText ( start, middle, end ) =
                        span [] [ text start, view_ (text middle), text end ]
                in
                sText
                    |> String.toList
                    |> List.foldl f ( "", "", "" )
                    |> viewText

            else
                view_ (text sText)
    in
    case ref of
        Just r ->
            let
                toAttrsAndContent c =
                    case syntaxConfig.dependencyTooltip of
                        Just tooltip ->
                            let
                                content_ =
                                    case tooltip.toTooltip r of
                                        Just t ->
                                            Tooltip.view c t

                                        Nothing ->
                                            c
                            in
                            ( [ class className
                              , onMouseEnter (tooltip.toHoverStart r)
                              , onMouseLeave (tooltip.toHoverEnd r)
                              ]
                            , [ content_ ]
                            )

                        _ ->
                            ( [ class className ], [ c ] )
            in
            case syntaxConfig.toClick of
                Just toClick ->
                    let
                        f c =
                            let
                                ( attrs, content_ ) =
                                    toAttrsAndContent c
                            in
                            Click.view attrs content_ (toClick r)
                    in
                    content f

                Nothing ->
                    let
                        f c =
                            let
                                ( attrs, content_ ) =
                                    toAttrsAndContent c
                            in
                            span attrs content_
                    in
                    content f

        _ ->
            content
                (\c ->
                    case ( syntaxConfig.showSyntaxHelpTooltip, helpForSegment segment ) of
                        ( True, Just help ) ->
                            let
                                tooltip =
                                    Tooltip.rich help
                                        |> Tooltip.tooltip
                                        |> Tooltip.withArrow Tooltip.Start
                                        |> Tooltip.withPosition Tooltip.Below
                            in
                            Tooltip.view
                                (span
                                    [ class "syntax-help"
                                    , class className
                                    , classList
                                        [ ( "single-letter"
                                          , String.length (String.trim sText) == 1
                                          )
                                        ]
                                    ]
                                    [ c ]
                                )
                                tooltip

                        _ ->
                            span
                                [ class className ]
                                [ c ]
                )


helpForSegment : SyntaxSegment -> Maybe (Html msg)
helpForSegment (SyntaxSegment syntaxType segmentText) =
    let
        segmentText_ =
            String.trim segmentText
    in
    case syntaxType of
        ControlKeyword ->
            case segmentText_ of
                "handle" ->
                    Just SyntaxSegmentHelp.handleWith

                "where" ->
                    Just SyntaxSegmentHelp.abilityWhere

                "match" ->
                    Just SyntaxSegmentHelp.matchWith

                "with" ->
                    -- We don't know if its match...with or handle...with
                    Nothing

                "cases" ->
                    Just SyntaxSegmentHelp.cases

                "if" ->
                    Just SyntaxSegmentHelp.ifElse

                "then" ->
                    Just SyntaxSegmentHelp.ifElse

                "else" ->
                    Just SyntaxSegmentHelp.ifElse

                "do" ->
                    Just SyntaxSegmentHelp.doKeyword

                _ ->
                    Nothing

        DelayForceChar ->
            case segmentText_ of
                "'" ->
                    Just SyntaxSegmentHelp.delayed

                "()" ->
                    Just SyntaxSegmentHelp.forceParens

                _ ->
                    Nothing

        UseKeyword ->
            Just SyntaxSegmentHelp.use

        UsePrefix ->
            Just SyntaxSegmentHelp.use

        UseSuffix ->
            Just SyntaxSegmentHelp.use

        NumericLiteral ->
            Just SyntaxSegmentHelp.numericLiteral

        TextLiteral ->
            if String.startsWith "\"\"\"" segmentText_ then
                Just SyntaxSegmentHelp.textLiteralMultiline

            else
                Just SyntaxSegmentHelp.textLiteral

        BytesLiteral ->
            Just SyntaxSegmentHelp.bytesLiteral

        CharLiteral ->
            Just SyntaxSegmentHelp.charLiteral

        Op Cons ->
            Just SyntaxSegmentHelp.cons

        Op Snoc ->
            Just SyntaxSegmentHelp.snoc

        Op Concat ->
            Just SyntaxSegmentHelp.concat

        Unit ->
            Just SyntaxSegmentHelp.unit

        DataTypeModifier ->
            case segmentText_ of
                "unique" ->
                    Just SyntaxSegmentHelp.uniqueKeyword

                "structural" ->
                    Just SyntaxSegmentHelp.structuralKeyword

                _ ->
                    Nothing

        AbilityBraces ->
            Just SyntaxSegmentHelp.abilityBraces

        TypeOperator ->
            case segmentText_ of
                "forall" ->
                    Just SyntaxSegmentHelp.typeForall

                "∀" ->
                    Just SyntaxSegmentHelp.typeForall

                _ ->
                    Nothing

        TypeAscriptionColon ->
            Just SyntaxSegmentHelp.typeAscriptionColon

        DataTypeKeyword ->
            case segmentText_ of
                "type" ->
                    Just SyntaxSegmentHelp.typeKeyword

                "ability" ->
                    Just SyntaxSegmentHelp.abilityWhere

                _ ->
                    Nothing

        DataTypeParams ->
            Just SyntaxSegmentHelp.typeParams

        DelimiterChar ->
            case segmentText_ of
                "@" ->
                    Just SyntaxSegmentHelp.asPattern

                "termLink" ->
                    Just SyntaxSegmentHelp.termLink

                _ ->
                    Nothing

        LinkKeyword ->
            case segmentText_ of
                "typeLink" ->
                    Just SyntaxSegmentHelp.typeLink

                "termLink" ->
                    Just SyntaxSegmentHelp.termLink

                _ ->
                    Nothing

        _ ->
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
            , Decode.map simpleSyntaxTypeFromString decodeTag_
            ]
        )
        (field segmentField Decode.string)


decode : Decode.Decoder SyntaxSegment
decode =
    decode_ { segmentField = "segment", annotationField = "annotation" }
