module Lib.Nld.NldTest exposing (suite)

import Expect
import Lib.Nld as Nld exposing (..)
import Lib.Nld.Grammar as NldGrammar
import Set
import Test exposing (Test, describe, test)


{-| Convenience alias for creating a TaggedGrammar with no metadata.
-}
tg : NldGrammar.Grammar () -> NldGrammar.TaggedGrammar ()
tg g =
    NldGrammar.tagged [] g


{-| Extract just the token strings from a (meta, tokens) suggestion result.
-}
resultTokens : ( List meta, List String ) -> List String
resultTokens ( _, ts ) =
    ts


{-| A bookshop command grammar supporting:

  - search books [<query terms>]
  - order status
  - order history
  - order summary
  - order details
  - cancel order <orderId>
  - add to cart <title>
  - view cart
  - checkout

-}
bookshopGrammar : Nld () ( List (), List String )
bookshopGrammar =
    fromGrammar
        (tg
            (NldGrammar.Choice
                [ tg
                    (NldGrammar.Seq
                        [ tg (NldGrammar.MinimalToken [ ( 0.0, "search" ) ])
                        , tg (NldGrammar.MinimalToken [ ( 0.0, "books" ) ])
                        , tg (NldGrammar.Repeat (tg NldGrammar.AnyToken))
                        ]
                    )
                , tg
                    (NldGrammar.Seq
                        [ tg (NldGrammar.MinimalToken [ ( 0.0, "order" ) ])
                        , tg (NldGrammar.MinimalToken [ ( 0.0, "status" ) ])
                        ]
                    )
                , tg
                    (NldGrammar.Seq
                        [ tg (NldGrammar.MinimalToken [ ( 0.0, "order" ) ])
                        , tg (NldGrammar.MinimalToken [ ( 0.0, "history" ) ])
                        ]
                    )
                , tg
                    (NldGrammar.Seq
                        [ tg (NldGrammar.MinimalToken [ ( 0.0, "order" ) ])
                        , tg (NldGrammar.MinimalToken [ ( 0.0, "summary" ) ])
                        ]
                    )
                , tg
                    (NldGrammar.Seq
                        [ tg (NldGrammar.MinimalToken [ ( 0.0, "order" ) ])
                        , tg (NldGrammar.MinimalToken [ ( 0.0, "details" ) ])
                        ]
                    )
                , tg
                    (NldGrammar.Seq
                        [ tg (NldGrammar.MinimalToken [ ( 0.0, "cancel" ) ])
                        , tg (NldGrammar.MinimalToken [ ( 0.0, "order" ) ])
                        , tg (NldGrammar.Token NldGrammar.TokenNat)
                        ]
                    )
                , tg
                    (NldGrammar.Seq
                        [ tg (NldGrammar.MinimalToken [ ( 0.0, "add" ) ])
                        , tg (NldGrammar.MinimalToken [ ( 0.0, "to" ) ])
                        , tg (NldGrammar.MinimalToken [ ( 0.0, "cart" ) ])
                        , tg NldGrammar.AnyToken
                        ]
                    )
                , tg
                    (NldGrammar.Seq
                        [ tg (NldGrammar.MinimalToken [ ( 0.0, "view" ) ])
                        , tg (NldGrammar.MinimalToken [ ( 0.0, "cart" ) ])
                        ]
                    )
                , tg (NldGrammar.MinimalToken [ ( 0.0, "checkout" ) ])
                ]
            )
        )


suggestionsTest : Test
suggestionsTest =
    describe "Nld.suggestions"
        [ test "Recursively expands the input tokens until there's enough results" <|
            \_ ->
                -- "search" alone is incomplete; suggestions expands it by appending "books"
                -- (the next wanted token), producing a complete "search books" match
                Expect.equal [ [ "search", "books" ] ]
                    (Nld.suggestions 1 bookshopGrammar [ "search" ] |> List.map resultTokens)
        , test "expands partial view command to view cart" <|
            \_ ->
                Expect.equal [ [ "view", "cart" ] ]
                    (Nld.suggestions 1 bookshopGrammar [ "view" ] |> List.map resultTokens)
        , test "returns complete single-token command directly" <|
            \_ ->
                Expect.equal [ [ "checkout" ] ]
                    (Nld.suggestions 1 bookshopGrammar [ "checkout" ] |> List.map resultTokens)
        , test "returns complete order status command" <|
            \_ ->
                Expect.equal [ [ "order", "status" ] ]
                    (Nld.suggestions 1 bookshopGrammar [ "order", "status" ] |> List.map resultTokens)
        , test "returns complete cancel order command with order ID" <|
            \_ ->
                Expect.equal [ [ "cancel", "order", "42" ] ]
                    (Nld.suggestions 1 bookshopGrammar [ "cancel", "order", "42" ] |> List.map resultTokens)
        , test "returns complete add to cart command with book title" <|
            \_ ->
                Expect.equal [ [ "add", "to", "cart", "Dune" ] ]
                    (Nld.suggestions 1 bookshopGrammar [ "add", "to", "cart", "Dune" ] |> List.map resultTokens)
        , test "search with query terms matched via repeat" <|
            \_ ->
                -- Repeat collects "Dune" as an extra token; longer match wins
                Expect.equal [ [ "search", "books", "Dune" ] ]
                    (Nld.suggestions 1 bookshopGrammar [ "search", "books", "Dune" ] |> List.map resultTokens)
        , test "given 'order', expands to all 4 order subcommands" <|
            \_ ->
                Nld.suggestions 4 bookshopGrammar [ "order" ]
                    |> List.map resultTokens
                    |> List.sort
                    |> Expect.equal
                        [ [ "order", "details" ]
                        , [ "order", "history" ]
                        , [ "order", "status" ]
                        , [ "order", "summary" ]
                        ]
        , test "limit is respected: 2 of 4 order subcommands returned" <|
            \_ ->
                let
                    result =
                        Nld.suggestions 2 bookshopGrammar [ "order" ]
                            |> List.map resultTokens
                            |> List.sort

                    validSubcommands =
                        [ [ "order", "details" ]
                        , [ "order", "history" ]
                        , [ "order", "status" ]
                        , [ "order", "summary" ]
                        ]
                in
                Expect.equal True
                    (List.length result == 2 && List.all (\r -> List.member r validSubcommands) result)
        , test "returns empty when completion is blocked by an unexpandable AnyToken" <|
            \_ ->
                -- "add to cart" is otherwise valid but the final slot needs
                -- AnyToken which has no wanted set, so no suggestion can be generated
                Expect.equal []
                    (Nld.suggestions 1 bookshopGrammar [ "add", "to", "cart" ] |> List.map resultTokens)
        , test "limit > 1 still finds single-completion branches (regression for suggestions 10)" <|
            \_ ->
                -- With limit=10, the expansion path finds "search books" but then tries
                -- to find 9 more results. Since there are none, it must fall back to the
                -- already-found completion rather than returning empty.
                Expect.equal [ [ "search", "books" ] ]
                    (Nld.suggestions 10 bookshopGrammar [ "search" ] |> List.map resultTokens)
        , test "limit > 1 still finds single-completion branch for view cart" <|
            \_ ->
                Expect.equal [ [ "view", "cart" ] ]
                    (Nld.suggestions 10 bookshopGrammar [ "view" ] |> List.map resultTokens)
        ]


queryCompletionTest : Test
queryCompletionTest =
    describe "Nld.queryCompletion"
        [ test "completes partial last word with full query" <|
            \_ ->
                Expect.equal "order status"
                    (queryCompletion bookshopGrammar "order st")
        , test "completes to an alternative matching continuation" <|
            \_ ->
                Expect.equal "order history"
                    (queryCompletion bookshopGrammar "order hist")
        , test "completes when partial last word is an exact match" <|
            \_ ->
                Expect.equal "add to cart"
                    (queryCompletion bookshopGrammar "add to cart")
        , test "completes a single partial word with no preceding tokens" <|
            \_ ->
                Expect.equal "order"
                    (queryCompletion bookshopGrammar "ord")
        , test "returns query unchanged when partial word matches nothing" <|
            \_ ->
                Expect.equal "order xyz"
                    (queryCompletion bookshopGrammar "order xyz")
        , test "returns query unchanged on empty string" <|
            \_ ->
                Expect.equal ""
                    (queryCompletion bookshopGrammar "")
        , test "returns query unchanged when query ends with a space (no partial word)" <|
            \_ ->
                Expect.equal "order "
                    (queryCompletion bookshopGrammar "order ")
        ]


suggestionsForQueryTest : Test
suggestionsForQueryTest =
    describe "Nld.suggestionsForQuery"
        [ test "partial word expands before suggestion lookup" <|
            \_ ->
                Nld.suggestionsForQuery 4 bookshopGrammar "ord"
                    |> List.map resultTokens
                    |> List.sort
                    |> Expect.equal
                        [ [ "order", "details" ]
                        , [ "order", "history" ]
                        , [ "order", "status" ]
                        , [ "order", "summary" ]
                        ]
        , test "full word works the same as suggestions on token list" <|
            \_ ->
                Expect.equal
                    (Nld.suggestionsForQuery 4 bookshopGrammar "order" |> List.map resultTokens)
                    (Nld.suggestions 4 bookshopGrammar [ "order" ] |> List.map resultTokens)
        , test "partial multi-word query completes last word then suggests" <|
            \_ ->
                Expect.equal [ [ "order", "status" ] ]
                    (Nld.suggestionsForQuery 1 bookshopGrammar "order st" |> List.map resultTokens)
        , test "empty query returns no suggestions" <|
            \_ ->
                Expect.equal []
                    (Nld.suggestionsForQuery 10 bookshopGrammar "" |> List.map resultTokens)
        ]


suite : Test
suite =
    describe "Nld"
        [ suggestionsTest
        , suggestionsForQueryTest
        , queryCompletionTest
        , describe "wanted"
            [ test "Done parser wants nothing" <|
                \_ ->
                    Expect.equal Set.empty (wanted (pure 42))
            , test "word parser wants its token" <|
                \_ ->
                    Expect.equal (Set.singleton "foo") (wanted (word "foo"))
            , test "tokenMatching wants nothing (predicate-based)" <|
                \_ ->
                    Expect.equal Set.empty (wanted (tokenMatching (always True)))
            , test "minimalToken wants all listed tokens" <|
                \_ ->
                    Expect.equal
                        (Set.fromList [ "asc", "desc" ])
                        (wanted (minimalToken [ ( 1.0, "asc" ), ( 0.5, "desc" ) ]))
            ]
        , describe "pure"
            [ test "succeeds with value regardless of input" <|
                \_ ->
                    Expect.equal [ ( 0.0, 42 ) ] (run (pure 42) [])
            , test "succeeds even with unrelated tokens" <|
                \_ ->
                    Expect.equal [ ( 0.0, "hello" ) ] (run (pure "hello") [ "foo", "bar" ])
            ]
        , describe "word"
            [ test "matches an exact token at weight 0" <|
                \_ ->
                    Expect.equal [ ( 0.0, "foo" ) ] (run (word "foo") [ "foo" ])
            , test "returns empty when token is absent" <|
                \_ ->
                    Expect.equal [] (run (word "foo") [ "bar" ])
            , test "returns empty on empty input" <|
                \_ ->
                    Expect.equal [] (run (word "foo") [])
            , test "later position means higher weight" <|
                \_ ->
                    -- "foo" at position 1 incurs a gap cost of 1
                    Expect.equal [ ( 1.0, "foo" ) ] (run (word "foo") [ "bar", "foo" ])
            , test "prefers earlier occurrence when token appears multiple times" <|
                \_ ->
                    case run (word "a") [ "a", "b", "a" ] of
                        ( w1, _ ) :: ( w2, _ ) :: _ ->
                            Expect.lessThan w2 w1

                        _ ->
                            Expect.fail "Expected two results"
            ]
        , describe "nat"
            [ test "matches an integer token" <|
                \_ ->
                    Expect.equal [ ( 0.0, 42 ) ] (run nat [ "42" ])
            , test "does not match a non-numeric token" <|
                \_ ->
                    Expect.equal [] (run nat [ "abc" ])
            , test "does not match a float token" <|
                \_ ->
                    Expect.equal [] (run nat [ "3.14" ])
            , test "matches integer among mixed tokens" <|
                \_ ->
                    case run nat [ "hello", "7" ] of
                        [ ( _, 7 ) ] ->
                            Expect.pass

                        _ ->
                            Expect.fail "Expected exactly one result: 7"
            ]
        , describe "tokenMatching"
            [ test "matches tokens satisfying the predicate" <|
                \_ ->
                    let
                        p =
                            tokenMatching (\t -> String.length t == 3)
                    in
                    Expect.equal [ ( 0.0, "foo" ) ] (run p [ "foo" ])
            , test "rejects tokens that do not satisfy the predicate" <|
                \_ ->
                    let
                        p =
                            tokenMatching (\t -> String.length t == 3)
                    in
                    Expect.equal [] (run p [ "ab" ])
            ]
        , describe "minimalToken"
            [ test "matches the lower-base-weight token first" <|
                \_ ->
                    -- "bar" has base weight 0.5, "foo" has 1.0; both at position 0 and 1 resp.
                    -- "bar" at pos 1: 0.5 + gapCost(0,1) = 0.5 + 1.0 = 1.5
                    -- "foo" at pos 0: 1.0 + gapCost(0,0) = 1.0 + 0.0 = 1.0
                    let
                        parser =
                            minimalToken [ ( 1.0, "foo" ), ( 0.5, "bar" ) ]

                        results =
                            run parser [ "foo", "bar" ]
                    in
                    case results of
                        ( _, first ) :: _ ->
                            Expect.equal "foo" first

                        [] ->
                            Expect.fail "Expected at least one result"
            , test "returns no result when none of the tokens are present" <|
                \_ ->
                    Expect.equal [] (run (minimalToken [ ( 1.0, "foo" ) ]) [ "bar" ])
            ]
        , describe "map"
            [ test "transforms the result value" <|
                \_ ->
                    Expect.equal [ ( 0.0, 3 ) ] (run (map String.length (word "foo")) [ "foo" ])
            , test "preserves weight" <|
                \_ ->
                    Expect.equal [ ( 1.0, "FOO" ) ] (run (map String.toUpper (word "foo")) [ "bar", "foo" ])
            ]
        , describe "map2"
            [ test "combines two word parsers in order" <|
                \_ ->
                    let
                        parser =
                            map2 Tuple.pair (word "a") (word "b")

                        results =
                            run parser [ "a", "b" ]
                    in
                    case results of
                        ( _, ( "a", "b" ) ) :: _ ->
                            Expect.pass

                        _ ->
                            Expect.fail "Expected (\"a\", \"b\") as top result"
            , test "returns empty when either token is missing" <|
                \_ ->
                    Expect.equal []
                        (run (map2 Tuple.pair (word "a") (word "b")) [ "a" ])
            , test "combines pure with word" <|
                \_ ->
                    let
                        results =
                            run (map2 Tuple.pair (pure "x") (word "y")) [ "y" ]
                    in
                    case results of
                        ( _, ( "x", "y" ) ) :: _ ->
                            Expect.pass

                        _ ->
                            Expect.fail "Expected (\"x\", \"y\")"
            ]
        , describe "choice"
            [ test "empty choice never matches" <|
                \_ ->
                    Expect.equal [] (run (choice []) [ "foo" ])
            , test "single-element choice behaves like the original parser" <|
                \_ ->
                    Expect.equal (run (word "foo") [ "foo" ])
                        (run (choice [ word "foo" ]) [ "foo" ])
            , test "returns results from all matching alternatives" <|
                \_ ->
                    let
                        results =
                            run (choice [ word "a", word "b" ]) [ "a", "b" ]

                        values =
                            List.map Tuple.second results
                    in
                    Expect.all
                        [ \vs -> Expect.equal True (List.member "a" vs)
                        , \vs -> Expect.equal True (List.member "b" vs)
                        ]
                        values
            , test "does not match when none of the alternatives are present" <|
                \_ ->
                    Expect.equal []
                        (run (choice [ word "x", word "y" ]) [ "z" ])
            ]
        , describe "repeat"
            [ test "matches zero tokens producing empty list" <|
                \_ ->
                    let
                        results =
                            run (repeat (word "a")) [ "b" ]

                        values =
                            List.map Tuple.second results
                    in
                    Expect.equal True (List.member [] values)
            , test "greedily collects all matching tokens" <|
                \_ ->
                    let
                        results =
                            run (repeat (word "a")) [ "a", "a", "b" ]

                        bestValue =
                            results |> List.head |> Maybe.map Tuple.second
                    in
                    Expect.equal (Just [ "a", "a" ]) bestValue
            , test "prefers longer matches (lower weight)" <|
                \_ ->
                    let
                        results =
                            run (repeat (word "a")) [ "a", "a" ]
                    in
                    case List.sortBy Tuple.first results of
                        ( _, topValue ) :: _ ->
                            Expect.equal [ "a", "a" ] topValue

                        [] ->
                            Expect.fail "Expected results"
            ]
        , describe "hasCompleteMatch"
            [ test "returns True for exact single-word match" <|
                \_ ->
                    Expect.equal True (hasCompleteMatch (word "buy") [ "buy" ])
            , test "returns False when token is absent" <|
                \_ ->
                    Expect.equal False (hasCompleteMatch (word "buy") [ "sell" ])
            , test "returns False for empty input against word parser" <|
                \_ ->
                    Expect.equal False (hasCompleteMatch (word "buy") [])
            , test "returns True for seq grammar with all tokens present" <|
                \_ ->
                    let
                        grammar =
                            fromGrammar
                                (tg
                                    (NldGrammar.Seq
                                        [ tg (NldGrammar.MinimalToken [ ( 0.0, "buy" ), ( 0.0, "sell" ) ])
                                        , tg (NldGrammar.Token NldGrammar.TokenNat)
                                        , tg NldGrammar.AnyToken
                                        ]
                                    )
                                )
                    in
                    Expect.equal True (hasCompleteMatch grammar [ "buy", "100", "AAPL" ])
            , test "returns False for seq grammar with only partial input" <|
                \_ ->
                    let
                        grammar =
                            fromGrammar
                                (tg
                                    (NldGrammar.Seq
                                        [ tg (NldGrammar.MinimalToken [ ( 0.0, "buy" ), ( 0.0, "sell" ) ])
                                        , tg (NldGrammar.Token NldGrammar.TokenNat)
                                        , tg NldGrammar.AnyToken
                                        ]
                                    )
                                )
                    in
                    Expect.equal False (hasCompleteMatch grammar [ "buy", "100" ])
            ]
        , describe "autocomplete / topK"
            [ test "word parser wants its token when missing" <|
                \_ ->
                    Expect.equal [ "cat" ] (topK 5 (word "cat") [])
            , test "no suggestions when parse succeeds" <|
                \_ ->
                    Expect.equal [] (topK 5 (word "cat") [ "cat" ])
            , test "map2 suggests second parser after first matches" <|
                \_ ->
                    Expect.equal [ "apples" ]
                        (topK 5 (map2 Tuple.pair (word "buy") (word "apples")) [ "buy" ])
            , test "map2 suggests first parser when nothing matches" <|
                \_ ->
                    Expect.equal [ "buy" ]
                        (topK 5 (map2 Tuple.pair (word "buy") (word "apples")) [])
            , test "map2 no suggestions when complete" <|
                \_ ->
                    Expect.equal []
                        (topK 5 (map2 Tuple.pair (word "buy") (word "apples")) [ "buy", "apples" ])
            , test "choice shows merged wanted" <|
                \_ ->
                    let
                        result =
                            topK 5 (choice [ word "cat", word "dog" ]) []
                    in
                    Expect.equal True
                        (List.member "cat" result && List.member "dog" result)
            , test "only suggests the relevant next token, not tokens from unrelated branches" <|
                \_ ->
                    -- Regression for Bug 2: before the fromGrammar Seq fix, all branches
                    -- had wanted=Set.empty so dead branches leaked their first tokens
                    -- into suggestions. With the fix, "search" in the input causes only
                    -- the search-books branch to make progress, so only "books" is suggested.
                    Expect.equal [ "books" ]
                        (topK 1 bookshopGrammar [ "search" ])
            ]
        , describe "looksLikeDate"
            [ test "accepts ISO date with dashes" <|
                \_ ->
                    Expect.equal True (looksLikeDate "2024-01-15")
            , test "accepts date with slashes" <|
                \_ ->
                    Expect.equal True (looksLikeDate "01/15/2024")
            , test "rejects plain string" <|
                \_ ->
                    Expect.equal False (looksLikeDate "foo")
            , test "rejects partial date with only two parts" <|
                \_ ->
                    Expect.equal False (looksLikeDate "2024-01")
            , test "rejects date with non-integer parts" <|
                \_ ->
                    Expect.equal False (looksLikeDate "2024-ab-15")
            ]
        , describe "looksLikeTime"
            [ test "accepts HH:MM" <|
                \_ ->
                    Expect.equal True (looksLikeTime "10:30")
            , test "accepts HH:MM:SS" <|
                \_ ->
                    Expect.equal True (looksLikeTime "10:30:45")
            , test "accepts HH:MM:SS.sss (fractional seconds)" <|
                \_ ->
                    Expect.equal True (looksLikeTime "10:30:45.5")
            , test "rejects plain string" <|
                \_ ->
                    Expect.equal False (looksLikeTime "foo")
            , test "rejects single number" <|
                \_ ->
                    Expect.equal False (looksLikeTime "10")
            , test "rejects non-integer hour" <|
                \_ ->
                    Expect.equal False (looksLikeTime "ab:30")
            ]
        , describe "looksLikeDateTime"
            [ test "accepts ISO datetime with T separator" <|
                \_ ->
                    Expect.equal True (looksLikeDateTime "2024-01-15T10:30")
            , test "accepts date-only string (falls through to looksLikeDate)" <|
                \_ ->
                    Expect.equal True (looksLikeDateTime "2024-01-15")
            , test "rejects plain string" <|
                \_ ->
                    Expect.equal False (looksLikeDateTime "foo")
            , test "rejects when date part is invalid" <|
                \_ ->
                    Expect.equal False (looksLikeDateTime "foo-bar-bazT10:30")
            ]
        , describe "fromGrammar"
            [ test "AnyToken matches any single token" <|
                \_ ->
                    let
                        results =
                            run (fromGrammar (tg NldGrammar.AnyToken)) [ "hello" ]
                    in
                    Expect.equal [ ( 0.0, ( [], [ "hello" ] ) ) ] results
            , test "Token TokenNat matches integer strings" <|
                \_ ->
                    let
                        results =
                            run (fromGrammar (tg (NldGrammar.Token NldGrammar.TokenNat))) [ "42" ]

                        values =
                            List.map (Tuple.second >> resultTokens) results
                    in
                    Expect.equal [ [ "42" ] ] values
            , test "Token TokenFloat matches float strings" <|
                \_ ->
                    let
                        results =
                            run (fromGrammar (tg (NldGrammar.Token NldGrammar.TokenFloat))) [ "3.14" ]

                        values =
                            List.map (Tuple.second >> resultTokens) results
                    in
                    Expect.equal [ [ "3.14" ] ] values
            , test "Token TokenBoolean matches true and false" <|
                \_ ->
                    let
                        trueResult =
                            run (fromGrammar (tg (NldGrammar.Token NldGrammar.TokenBoolean))) [ "true" ]

                        falseResult =
                            run (fromGrammar (tg (NldGrammar.Token NldGrammar.TokenBoolean))) [ "false" ]
                    in
                    Expect.all
                        [ \_ -> Expect.equal [ [ "true" ] ] (List.map (Tuple.second >> resultTokens) trueResult)
                        , \_ -> Expect.equal [ [ "false" ] ] (List.map (Tuple.second >> resultTokens) falseResult)
                        ]
                        ()
            , test "Seq matches tokens in sequence" <|
                \_ ->
                    let
                        grammar =
                            tg
                                (NldGrammar.Seq
                                    [ tg (NldGrammar.MinimalToken [ ( 0.0, "set" ) ])
                                    , tg (NldGrammar.Token NldGrammar.TokenNat)
                                    ]
                                )

                        results =
                            run (fromGrammar grammar) [ "set", "5" ]

                        values =
                            List.map (Tuple.second >> resultTokens) results
                    in
                    Expect.equal True (List.member [ "set", "5" ] values)
            , test "Choice matches either alternative" <|
                \_ ->
                    let
                        grammar =
                            tg
                                (NldGrammar.Choice
                                    [ tg (NldGrammar.MinimalToken [ ( 0.0, "asc" ) ])
                                    , tg (NldGrammar.MinimalToken [ ( 0.0, "desc" ) ])
                                    ]
                                )

                        ascResults =
                            run (fromGrammar grammar) [ "asc" ]

                        descResults =
                            run (fromGrammar grammar) [ "desc" ]
                    in
                    Expect.all
                        [ \_ -> Expect.equal [ [ "asc" ] ] (List.map (Tuple.second >> resultTokens) ascResults)
                        , \_ -> Expect.equal [ [ "desc" ] ] (List.map (Tuple.second >> resultTokens) descResults)
                        ]
                        ()
            , test "Repeat collects all matching tokens" <|
                \_ ->
                    let
                        grammar =
                            tg (NldGrammar.Repeat (tg (NldGrammar.MinimalToken [ ( 0.0, "tag" ) ])))

                        results =
                            run (fromGrammar grammar) [ "tag", "tag", "other" ]

                        bestValue =
                            results |> List.head |> Maybe.map (Tuple.second >> resultTokens)
                    in
                    Expect.equal (Just [ "tag", "tag" ]) bestValue
            , test "meta from tagged grammar is included in result" <|
                \_ ->
                    let
                        grammar =
                            NldGrammar.tagged [ "cmd-meta" ] (NldGrammar.Literal "go")

                        results =
                            run (fromGrammar grammar) [ "go" ]

                        metas =
                            List.map (Tuple.second >> Tuple.first) results
                    in
                    Expect.equal [ [ "cmd-meta" ] ] metas
            ]
        ]
