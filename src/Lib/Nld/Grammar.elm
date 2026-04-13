module Lib.Nld.Grammar exposing (..)

import Json.Decode as Decode
import Lib.Decode.Helpers exposing (whenTagIs)
import Money exposing (Currency)


type TokenType
    = TokenCurrency Currency
    | TokenNat
    | TokenInt
    | TokenFloat
    | TokenBoolean
    | TokenDate
    | TokenDateTime
    | TokenTime


type alias TaggedGrammar meta =
    { meta : List meta
    , grammar : Grammar meta
    }


type Grammar meta
    = AnyToken
    | Literal String
    | MinimalToken (List ( Float, String ))
    | Repeat (TaggedGrammar meta)
    | Seq (List (TaggedGrammar meta))
    | Choice (List (TaggedGrammar meta))
    | Token TokenType


tagged : List meta -> Grammar meta -> TaggedGrammar meta
tagged meta g =
    { meta = meta, grammar = g }


decodeTokenType : Decode.Decoder TokenType
decodeTokenType =
    let
        decodeCurrency =
            Decode.map Money.fromString Decode.string
                |> Decode.andThen
                    (\maybeCurrency ->
                        case maybeCurrency of
                            Just currency ->
                                Decode.succeed currency

                            Nothing ->
                                Decode.fail "Invalid currency code"
                    )
    in
    Decode.oneOf
        [ whenTagIs "currency" (Decode.map TokenCurrency (Decode.field "value" decodeCurrency))
        , whenTagIs "nat" (Decode.succeed TokenNat)
        , whenTagIs "int" (Decode.succeed TokenInt)
        , whenTagIs "float" (Decode.succeed TokenFloat)
        , whenTagIs "boolean" (Decode.succeed TokenBoolean)
        , whenTagIs "date" (Decode.succeed TokenDate)
        , whenTagIs "dateTime" (Decode.succeed TokenDateTime)
        , whenTagIs "time" (Decode.succeed TokenTime)
        ]



-- The Unison wire format serialises TaggedGrammar as a flat JSON object whose
-- fields include "tag" (the Grammar constructor), optional "value" (the payload),
-- and "metadata" (the meta list), all at the same level:
--
--   { "tag": "seq", "value": [...], "metadata": [...] }
--
-- decodeTaggedGrammarWith therefore reads "metadata" and the Grammar from the
-- same object.


decodeTaggedGrammarWith : Decode.Decoder meta -> Decode.Decoder (TaggedGrammar meta)
decodeTaggedGrammarWith metaDec =
    Decode.map2 tagged
        (Decode.field "metadata" (Decode.list metaDec))
        (Decode.lazy (\_ -> decodeGrammarWith metaDec))


decodeGrammarWith : Decode.Decoder meta -> Decode.Decoder (Grammar meta)
decodeGrammarWith metaDec =
    let
        decodeTuple =
            Decode.map2 Tuple.pair
                (Decode.index 0 Decode.float)
                (Decode.index 1 Decode.string)

        recur =
            Decode.lazy (\_ -> decodeTaggedGrammarWith metaDec)
    in
    Decode.oneOf
        [ whenTagIs "anyToken" (Decode.succeed AnyToken)
        , whenTagIs "literal" (Decode.map Literal (Decode.field "value" Decode.string))
        , whenTagIs "minimalToken" (Decode.map MinimalToken (Decode.field "value" (Decode.list decodeTuple)))
        , whenTagIs "repeat" (Decode.map Repeat (Decode.field "value" recur))
        , whenTagIs "seq" (Decode.map Seq (Decode.field "value" (Decode.list recur)))
        , whenTagIs "choice" (Decode.map Choice (Decode.field "value" (Decode.list recur)))
        , whenTagIs "token" (Decode.map Token (Decode.field "value" decodeTokenType))
        ]
