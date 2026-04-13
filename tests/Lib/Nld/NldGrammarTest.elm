module Lib.Nld.NldGrammarTest exposing (suite)

import Expect
import Json.Decode as Decode
import Lib.Nld.Grammar as NldGrammar exposing (Grammar(..), TaggedGrammar, TokenType(..))
import Test exposing (Test, describe, test)


{-| Decode a Grammar with no meta (metadata field is ignored / decoded as ()).
-}
decodeGrammar : String -> Result Decode.Error (Grammar ())
decodeGrammar json =
    Decode.decodeString (NldGrammar.decodeGrammarWith (Decode.succeed ())) json


{-| Wrap a grammar in a TaggedGrammar with no meta for use in expected values.
-}
tg : Grammar () -> TaggedGrammar ()
tg g =
    NldGrammar.tagged [] g


suite : Test
suite =
    describe "Nld.NldGrammar"
        [ describe "decode"
            [ test "decodes anyToken" <|
                \_ ->
                    Expect.equal (Ok AnyToken)
                        (decodeGrammar """{"tag":"anyToken","metadata":[]}""")
            , test "decodes literal" <|
                \_ ->
                    Expect.equal (Ok (Literal "hello"))
                        (decodeGrammar """{"tag":"literal","value":"hello","metadata":[]}""")
            , test "decodes literal with empty string" <|
                \_ ->
                    Expect.equal (Ok (Literal ""))
                        (decodeGrammar """{"tag":"literal","value":"","metadata":[]}""")
            , test "decodes literal nested inside seq" <|
                \_ ->
                    Expect.equal
                        (Ok (Seq [ tg (Literal "add"), tg (Token TokenNat) ]))
                        (decodeGrammar """{"tag":"seq","metadata":[],"value":[{"tag":"literal","value":"add","metadata":[]},{"tag":"token","value":{"tag":"nat"},"metadata":[]}]}""")
            , test "decodes minimalToken with weighted list" <|
                \_ ->
                    Expect.equal (Ok (MinimalToken [ ( 1.0, "foo" ), ( 2.0, "bar" ) ]))
                        (decodeGrammar """{"tag":"minimalToken","value":[[1.0,"foo"],[2.0,"bar"]],"metadata":[]}""")
            , test "decodes minimalToken with empty list" <|
                \_ ->
                    Expect.equal (Ok (MinimalToken []))
                        (decodeGrammar """{"tag":"minimalToken","value":[],"metadata":[]}""")
            , test "decodes repeat wrapping anyToken" <|
                \_ ->
                    Expect.equal (Ok (Repeat (tg AnyToken)))
                        (decodeGrammar """{"tag":"repeat","value":{"tag":"anyToken","metadata":[]},"metadata":[]}""")
            , test "decodes seq of two anyTokens" <|
                \_ ->
                    Expect.equal (Ok (Seq [ tg AnyToken, tg AnyToken ]))
                        (decodeGrammar """{"tag":"seq","value":[{"tag":"anyToken","metadata":[]},{"tag":"anyToken","metadata":[]}],"metadata":[]}""")
            , test "decodes empty seq" <|
                \_ ->
                    Expect.equal (Ok (Seq []))
                        (decodeGrammar """{"tag":"seq","value":[],"metadata":[]}""")
            , test "decodes choice of two grammars" <|
                \_ ->
                    Expect.equal (Ok (Choice [ tg AnyToken, tg (Repeat (tg AnyToken)) ]))
                        (decodeGrammar """{"tag":"choice","value":[{"tag":"anyToken","metadata":[]},{"tag":"repeat","value":{"tag":"anyToken","metadata":[]},"metadata":[]}],"metadata":[]}""")
            , test "decodes token nat" <|
                \_ ->
                    Expect.equal (Ok (Token TokenNat))
                        (decodeGrammar """{"tag":"token","value":{"tag":"nat"},"metadata":[]}""")
            , test "decodes token int" <|
                \_ ->
                    Expect.equal (Ok (Token TokenInt))
                        (decodeGrammar """{"tag":"token","value":{"tag":"int"},"metadata":[]}""")
            , test "decodes token float" <|
                \_ ->
                    Expect.equal (Ok (Token TokenFloat))
                        (decodeGrammar """{"tag":"token","value":{"tag":"float"},"metadata":[]}""")
            , test "decodes token boolean" <|
                \_ ->
                    Expect.equal (Ok (Token TokenBoolean))
                        (decodeGrammar """{"tag":"token","value":{"tag":"boolean"},"metadata":[]}""")
            , test "decodes token date" <|
                \_ ->
                    Expect.equal (Ok (Token TokenDate))
                        (decodeGrammar """{"tag":"token","value":{"tag":"date"},"metadata":[]}""")
            , test "decodes token dateTime" <|
                \_ ->
                    Expect.equal (Ok (Token TokenDateTime))
                        (decodeGrammar """{"tag":"token","value":{"tag":"dateTime"},"metadata":[]}""")
            , test "decodes token time" <|
                \_ ->
                    Expect.equal (Ok (Token TokenTime))
                        (decodeGrammar """{"tag":"token","value":{"tag":"time"},"metadata":[]}""")
            , test "decodes nested seq inside repeat" <|
                \_ ->
                    Expect.equal (Ok (Repeat (tg (Seq [ tg AnyToken, tg (Token TokenNat) ]))))
                        (decodeGrammar """{"tag":"repeat","value":{"tag":"seq","metadata":[],"value":[{"tag":"anyToken","metadata":[]},{"tag":"token","value":{"tag":"nat"},"metadata":[]}]},"metadata":[]}""")
            , test "fails on unknown tag" <|
                \_ ->
                    case decodeGrammar """{"tag":"unknown","metadata":[]}""" of
                        Err _ ->
                            Expect.pass

                        Ok _ ->
                            Expect.fail "Expected decode failure for unknown tag"
            ]
        ]
