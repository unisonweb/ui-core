module Lib.Nld exposing (..)

{-| Natural Language Disambiguator — a parser combinator library that finds
tokens in any order within an input, preferring tokens that appear close to
their expected position.

The Peach nondeterminism effect from the Unison original is encoded as
`List ( Float, Nld meta a )` — explicit weighted branches — in the `More`
continuation.

-}

import Dict
import Lib.Nld.Grammar as NldGrammar exposing (Grammar, TaggedGrammar)
import Lib.Nld.TokenPositions as TokenPositions exposing (TokenPositions)
import List.Extra as ListE
import Set exposing (Set)



-- TYPE


{-| A parser that produces values of type `a`, with grammar nodes tagged with
type `meta`.

  - `Done a remaining lastPos` — parsing succeeded; `remaining` is the token
    pool after consuming matched tokens; `lastPos` is the index of the last
    consumed token, used for gap-cost weighting.
  - `More tg k` — needs more input; `tg` is the TaggedGrammar describing
    what this parser is currently looking for (used for autocomplete); `k` is
    the continuation, returning a weighted list of next states.

-}
type Nld meta a
    = Done a TokenPositions Int
    | More (TaggedGrammar meta) (TokenPositions -> Int -> List ( Float, Nld meta a ))


{-| Extract the tagged grammar from a parser, if it is still in progress.
Returns `Nothing` for completed parsers.
-}
grammar : Nld meta a -> Maybe (TaggedGrammar meta)
grammar nld =
    case nld of
        Done _ _ _ ->
            Nothing

        More tg _ ->
            Just tg


{-| Extract the current tagged grammar from a parser, defaulting to an empty
tagged Seq for completed parsers. Use this when building combined grammars.
-}
grammarOf : Nld meta a -> TaggedGrammar meta
grammarOf nld =
    case nld of
        Done _ _ _ ->
            NldGrammar.tagged [] (NldGrammar.Seq [])

        More tg _ ->
            tg


{-| Extract the set of tokens a parser is currently looking for.
Returns `Set.empty` for completed parsers.
-}
wanted : Nld meta a -> Set String
wanted nld =
    case nld of
        Done _ _ _ ->
            Set.empty

        More tg _ ->
            wantedFromGrammar tg.grammar


wantedFromGrammar : Grammar meta -> Set String
wantedFromGrammar grammar_ =
    case grammar_ of
        NldGrammar.Literal t ->
            Set.singleton t

        NldGrammar.MinimalToken pairs ->
            Set.fromList (List.map Tuple.second pairs)

        NldGrammar.AnyToken ->
            Set.empty

        NldGrammar.Token _ ->
            Set.empty

        NldGrammar.Repeat tg ->
            wantedFromGrammar tg.grammar

        NldGrammar.Seq tgs ->
            case tgs of
                [] ->
                    Set.empty

                first :: _ ->
                    wantedFromGrammar first.grammar

        NldGrammar.Choice tgs ->
            List.foldl (\tg acc -> Set.union (wantedFromGrammar tg.grammar) acc) Set.empty tgs



-- LEAF PARSERS


{-| Always succeeds with `a`, consuming no tokens.
-}
pure : a -> Nld meta a
pure a =
    More (NldGrammar.tagged [] (NldGrammar.Seq []))
        (\rem pos -> [ ( 0.0, Done a rem pos ) ])


{-| Match one occurrence of the exact token `w`. Returns one branch per
position where `w` appears in the token pool, weighted by gap cost from
`prevPos`.
-}
word : String -> Nld meta String
word w =
    More (NldGrammar.tagged [] (NldGrammar.Literal w))
        (\remaining prevPos ->
            TokenPositions.positions w remaining
                |> Set.toList
                |> List.map
                    (\pos ->
                        ( TokenPositions.gapCost prevPos pos
                        , Done w (TokenPositions.remove w pos remaining) pos
                        )
                    )
        )


{-| Match any token satisfying `pred`. The wanted set is empty because
predicate-based matching cannot declare specific wanted tokens.
-}
tokenMatching : (String -> Bool) -> Nld meta String
tokenMatching pred =
    More (NldGrammar.tagged [] NldGrammar.AnyToken)
        (\remaining prevPos ->
            remaining.byPosition
                |> Dict.toList
                |> List.filterMap
                    (\( pos, t ) ->
                        if pred t then
                            Just
                                ( TokenPositions.gapCost prevPos pos
                                , Done t (TokenPositions.remove t pos remaining) pos
                                )

                        else
                            Nothing
                    )
        )


{-| Match any single token.
-}
token : Nld meta String
token =
    tokenMatching (always True)


{-| Match any token that parses as an integer.
-}
nat : Nld meta Int
nat =
    More (NldGrammar.tagged [] (NldGrammar.Token NldGrammar.TokenNat))
        (\remaining prevPos ->
            remaining.byPosition
                |> Dict.toList
                |> List.filterMap
                    (\( pos, t ) ->
                        t
                            |> String.toInt
                            |> Maybe.map
                                (\n ->
                                    ( TokenPositions.gapCost prevPos pos
                                    , Done n (TokenPositions.remove t pos remaining) pos
                                    )
                                )
                    )
        )


{-| Match any of the given weighted tokens. Each tuple is `(baseWeight, token)`;
lower total weight (base + gap cost) is preferred. The grammar contains
all listed tokens, making them available as autocomplete suggestions.
-}
minimalToken : List ( Float, String ) -> Nld meta String
minimalToken weightedTokens =
    More (NldGrammar.tagged [] (NldGrammar.MinimalToken weightedTokens))
        (\remaining prevPos ->
            weightedTokens
                |> List.concatMap
                    (\( baseWeight, t ) ->
                        TokenPositions.positions t remaining
                            |> Set.toList
                            |> List.map
                                (\pos ->
                                    ( baseWeight + TokenPositions.gapCost prevPos pos
                                    , Done t (TokenPositions.remove t pos remaining) pos
                                    )
                                )
                    )
        )


{-| Match an exact literal string, making it available as an autocomplete suggestion.
-}
literal : String -> Nld meta String
literal str =
    More (NldGrammar.tagged [] (NldGrammar.Literal str))
        (\remaining prevPos ->
            TokenPositions.positions str remaining
                |> Set.toList
                |> List.map
                    (\pos ->
                        ( TokenPositions.gapCost prevPos pos
                        , Done str (TokenPositions.remove str pos remaining) pos
                        )
                    )
        )



-- COMBINATORS


{-| Transform the result of a parser.
-}
map : (a -> b) -> Nld meta a -> Nld meta b
map f nld =
    case nld of
        Done a rem lastPos ->
            Done (f a) rem lastPos

        More tg k ->
            More tg (\rem pos -> List.map (Tuple.mapSecond (map f)) (k rem pos))


{-| Combine two parsers. Tokens for `na` and `nb` may appear in any order;
gap cost biases toward the declared order.
-}
map2 : (a -> b -> c) -> Nld meta a -> Nld meta b -> Nld meta c
map2 f na nb =
    case na of
        Done a remA lastPosA ->
            case nb of
                Done b remB lastPosB ->
                    Done (f a b) remB (max lastPosA lastPosB)

                More tgB k ->
                    -- na is done: step nb using na's remaining positions
                    More tgB
                        (\_ _ ->
                            k remA lastPosA
                                |> List.map (\( w, nb_ ) -> ( w, map2 f (Done a remA lastPosA) nb_ ))
                        )

        More tgA k ->
            More (NldGrammar.tagged [] (NldGrammar.Seq [ tgA, grammarOf nb ]))
                (\remaining lastPos ->
                    k remaining lastPos
                        |> List.map (\( w, na_ ) -> ( w, map2 f na_ nb ))
                )


{-| Try each parser in the list, returning all results from all that match.
-}
choice : List (Nld meta a) -> Nld meta a
choice nlds =
    case nlds of
        [] ->
            More (NldGrammar.tagged [] (NldGrammar.Choice [])) (\_ _ -> [])

        [ single ] ->
            single

        _ ->
            More (NldGrammar.tagged [] (NldGrammar.Choice (List.map grammarOf nlds)))
                (\remaining lastPos ->
                    List.concatMap
                        (\nld ->
                            case nld of
                                Done a rem lp ->
                                    [ ( 0.0, Done a rem lp ) ]

                                More _ k ->
                                    k remaining lastPos
                        )
                        nlds
                )


{-| Match zero or more occurrences of `nld`. Greedily collects the maximum
number of non-overlapping matches, then returns all prefix lengths as weighted
branches (longer = lower weight = preferred).
-}
repeat : Nld meta a -> Nld meta (List a)
repeat nld =
    More (NldGrammar.tagged [] (NldGrammar.Repeat (grammarOf nld)))
        (\remaining lastPos ->
            let
                ( fullList, finalRem, finalPos ) =
                    collectGreedy nld [] remaining lastPos 0

                n =
                    List.length fullList
            in
            List.range 0 n
                |> List.map
                    (\i ->
                        ( toFloat (n - i)
                        , Done (List.take i fullList) finalRem finalPos
                        )
                    )
        )


{-| Greedily collect matches of `nld`, up to a safety limit of 50 iterations.
Stops early if no positional progress is made (guards against parsers that
match without consuming tokens, e.g. `repeat (pure x)`).
-}
collectGreedy : Nld meta a -> List a -> TokenPositions -> Int -> Int -> ( List a, TokenPositions, Int )
collectGreedy nld acc remaining lastPos iters =
    if iters > 50 then
        ( acc, remaining, lastPos )

    else
        case
            runOne nld remaining lastPos
                |> List.filter (\( _, ( _, _, pos ) ) -> pos >= lastPos)
                |> List.sortBy Tuple.first
                |> List.head
        of
            Nothing ->
                ( acc, remaining, lastPos )

            Just ( _, ( a, rem, pos ) ) ->
                if pos == lastPos && iters > 0 then
                    -- No positional progress; stop to avoid an infinite loop
                    ( acc, remaining, lastPos )

                else
                    collectGreedy nld (acc ++ [ a ]) rem pos (iters + 1)


{-| Run a parser to completion from the given state, returning all successful
completions with their accumulated weights.
-}
runOne : Nld meta a -> TokenPositions -> Int -> List ( Float, ( a, TokenPositions, Int ) )
runOne nld remaining lastPos =
    case nld of
        Done a rem pos ->
            [ ( 0.0, ( a, rem, pos ) ) ]

        More _ k ->
            k remaining lastPos
                |> List.concatMap
                    (\( w, nld_ ) ->
                        runOne nld_ remaining lastPos
                            |> List.map (Tuple.mapFirst ((+) w))
                    )



-- RUN


{-| Check whether the given token list forms at least one complete parse.
-}
hasCompleteMatch : Nld meta a -> List String -> Bool
hasCompleteMatch nld tokens =
    not (List.isEmpty (run nld tokens))


{-| Execute a parser on a token list. Returns all results ordered by match
quality (lowest weight first).
-}
run : Nld meta a -> List String -> List ( Float, a )
run nld tokens =
    let
        go : Nld meta a -> TokenPositions -> Int -> Float -> List ( Float, a )
        go nld_ remaining lastPos baseWeight =
            case nld_ of
                Done a _ _ ->
                    [ ( baseWeight, a ) ]

                More _ k ->
                    k remaining lastPos
                        |> List.concatMap
                            (\( w, nld__ ) ->
                                go nld__ remaining lastPos (baseWeight + w)
                            )
    in
    go nld (TokenPositions.fromList tokens) 0 0.0
        |> List.sortBy Tuple.first


runList : Nld meta a -> List String -> List a
runList nld tokens =
    tokens
        |> run nld
        |> List.map Tuple.second


runTake : Int -> Nld meta a -> List String -> List a
runTake k nld tokens =
    tokens
        |> runList nld
        |> List.take k



-- SUGGESTIONS


queryCompletion : Nld meta a -> String -> String
queryCompletion nld query =
    case ListE.unconsLast (String.split " " query) of
        Nothing ->
            query

        Just ( "", _ ) ->
            query

        Just ( last, init ) ->
            init
                |> topK 100 nld
                |> List.filter (String.startsWith last)
                |> List.head
                |> Maybe.map (\completion -> String.join " " (init ++ [ completion ]))
                |> Maybe.withDefault query


suggestions : Int -> Nld meta a -> List String -> List a
suggestions limit nld tokens =
    let
        go : Int -> List String -> List a
        go k tokens_ =
            let
                suggestions_ =
                    runTake k nld tokens_

                leftover =
                    k - List.length suggestions_
            in
            -- If there's room for more results, we try another level
            if leftover > 0 then
                let
                    expanded =
                        tokens_
                            |> topK leftover nld
                            |> ListE.unique
                            -- recur
                            |> List.concatMap (\next -> go leftover (List.append tokens_ [ next ]))
                            |> List.take k
                            |> ListE.unique
                in
                -- Fall back to already-found completions if expansion yields nothing.
                -- This handles grammars where a branch has exactly one completion:
                -- e.g. "search books" with limit=10 would otherwise discard the
                -- found result while searching for 9 more that don't exist.
                if List.isEmpty expanded then
                    suggestions_

                else
                    expanded

            else
                suggestions_
    in
    go limit tokens


{-| Like `suggestions`, but accepts a raw query string instead of a token list.
The partial last word is first completed via `queryCompletion`, so typing "ord"
expands to "order" before the suggestion lookup runs.
-}
suggestionsForQuery : Int -> Nld meta a -> String -> List a
suggestionsForQuery limit nld q =
    if String.isEmpty q then
        []

    else
        q
            |> queryCompletion nld
            |> String.words
            |> suggestions limit nld



-- AUTOCOMPLETE


{-| Traverse the grammar embedded in a parser on partial input and return
`(weight, suggestion)` pairs where each suggestion is a single token that
would help the grammar make progress. Only paths that consumed all input
tokens are returned (weight < 1000). Results are ordered by weight (lowest =
best), deduplicated by token.

Weighting mirrors the Unison original: gap costs accumulate as tokens are
matched during traversal, plus 10000 × remaining-token-count is added at the
end to penalise incomplete paths.

-}
type alias GrammarPath =
    { cost : Float
    , remaining : TokenPositions
    , pos : Int
    , suggestion : Maybe String
    }


autocomplete : Nld meta a -> List String -> List ( Float, String )
autocomplete nld tokens =
    case nld of
        Done _ _ _ ->
            []

        More tg _ ->
            let
                tps =
                    TokenPositions.fromList tokens
            in
            goGrammar tg.grammar tps 0 0.0
                |> List.filterMap
                    (\path ->
                        case path.suggestion of
                            Nothing ->
                                Nothing

                            Just t ->
                                let
                                    totalCost =
                                        path.cost + 10000.0 * toFloat (Dict.size path.remaining.byPosition)
                                in
                                if totalCost < 1000.0 then
                                    Just ( totalCost, t )

                                else
                                    Nothing
                    )
                |> List.sortBy Tuple.first
                |> ListE.uniqueBy Tuple.second


goGrammar : Grammar meta -> TokenPositions -> Int -> Float -> List GrammarPath
goGrammar grammar_ remaining curPos cost =
    case grammar_ of
        NldGrammar.Literal t ->
            let
                posSet =
                    TokenPositions.positions t remaining
            in
            if Set.isEmpty posSet then
                [ { cost = cost, remaining = remaining, pos = curPos, suggestion = Just t } ]

            else
                posSet
                    |> Set.toList
                    |> List.map
                        (\pos ->
                            { cost = cost + TokenPositions.gapCost curPos pos
                            , remaining = TokenPositions.remove t pos remaining
                            , pos = pos
                            , suggestion = Nothing
                            }
                        )

        NldGrammar.MinimalToken pairs ->
            pairs
                |> List.concatMap
                    (\( baseWeight, tok ) ->
                        let
                            posSet =
                                TokenPositions.positions tok remaining
                        in
                        if Set.isEmpty posSet then
                            [ { cost = cost + baseWeight, remaining = remaining, pos = curPos, suggestion = Just tok } ]

                        else
                            posSet
                                |> Set.toList
                                |> List.map
                                    (\pos ->
                                        { cost = cost + baseWeight + TokenPositions.gapCost curPos pos
                                        , remaining = TokenPositions.remove tok pos remaining
                                        , pos = pos
                                        , suggestion = Nothing
                                        }
                                    )
                    )

        NldGrammar.AnyToken ->
            remaining.byPosition
                |> Dict.toList
                |> List.map
                    (\( pos, t ) ->
                        { cost = cost + TokenPositions.gapCost curPos pos
                        , remaining = TokenPositions.remove t pos remaining
                        , pos = pos
                        , suggestion = Nothing
                        }
                    )

        NldGrammar.Token tt ->
            remaining.byPosition
                |> Dict.toList
                |> List.filterMap
                    (\( pos, t ) ->
                        if matchesTokenType tt t then
                            Just
                                { cost = cost + TokenPositions.gapCost curPos pos
                                , remaining = TokenPositions.remove t pos remaining
                                , pos = pos
                                , suggestion = Nothing
                                }

                        else
                            Nothing
                    )

        NldGrammar.Repeat innerTg ->
            let
                -- Greedily consume tokens matching innerTg.grammar, collecting all prefix
                -- lengths (including zero). Each recursive call has strictly fewer tokens
                -- in remaining, so this terminates.
                consumed =
                    goGrammar innerTg.grammar remaining curPos cost
                        |> List.filter (\path -> path.suggestion == Nothing)
                        |> List.concatMap
                            (\path ->
                                goGrammar (NldGrammar.Repeat innerTg) path.remaining path.pos path.cost
                            )
            in
            { cost = cost, remaining = remaining, pos = curPos, suggestion = Nothing } :: consumed

        NldGrammar.Seq tgs ->
            goSeqGrammar (List.map .grammar tgs) remaining curPos cost Nothing

        NldGrammar.Choice tgs ->
            tgs
                |> List.concatMap (\tg -> goGrammar tg.grammar remaining curPos cost)


goSeqGrammar : List (Grammar meta) -> TokenPositions -> Int -> Float -> Maybe String -> List GrammarPath
goSeqGrammar gs remaining curPos cost firstCompletion =
    case gs of
        [] ->
            [ { cost = cost, remaining = remaining, pos = curPos, suggestion = firstCompletion } ]

        g :: rest ->
            let
                -- When we already have a pending suggestion (firstCompletion), an
                -- AnyToken slot cannot legitimately absorb input tokens: the user
                -- still needs to type the suggested token first. Treat AnyToken as
                -- a zero-cost skip so those input tokens are not silently consumed,
                -- which would otherwise produce misleading autocomplete paths.
                paths =
                    case ( firstCompletion, g ) of
                        ( Just _, NldGrammar.AnyToken ) ->
                            [ { cost = cost, remaining = remaining, pos = curPos, suggestion = Nothing } ]

                        ( Just _, NldGrammar.Repeat innerTg ) ->
                            case innerTg.grammar of
                                NldGrammar.AnyToken ->
                                    [ { cost = cost, remaining = remaining, pos = curPos, suggestion = Nothing } ]

                                _ ->
                                    goGrammar g remaining curPos cost

                        _ ->
                            goGrammar g remaining curPos cost
            in
            paths
                |> List.concatMap
                    (\path ->
                        let
                            acc =
                                case firstCompletion of
                                    Just _ ->
                                        firstCompletion

                                    Nothing ->
                                        path.suggestion
                        in
                        goSeqGrammar rest path.remaining path.pos path.cost acc
                    )


{-| Return the top `k` suggestions from `autocomplete`, ordered by match quality.
-}
topK : Int -> Nld meta a -> List String -> List String
topK k nld tokens =
    autocomplete nld tokens
        |> List.take k
        |> List.map Tuple.second


matchesTokenType : NldGrammar.TokenType -> String -> Bool
matchesTokenType tt t =
    case tt of
        NldGrammar.TokenNat ->
            String.toInt t /= Nothing

        NldGrammar.TokenInt ->
            String.toInt t /= Nothing

        NldGrammar.TokenFloat ->
            String.toFloat t /= Nothing

        NldGrammar.TokenBoolean ->
            t == "true" || t == "false"

        NldGrammar.TokenDate ->
            looksLikeDate t

        NldGrammar.TokenDateTime ->
            looksLikeDateTime t

        NldGrammar.TokenTime ->
            looksLikeTime t

        NldGrammar.TokenCurrency _ ->
            String.toFloat t /= Nothing



-- GRAMMAR INTERPRETER


{-| Convert a `TaggedGrammar meta` into a runnable `Nld` parser. The result
type is `Nld meta ( List meta, List String )`, where `List meta` accumulates
the metadata from all `TaggedGrammar` nodes traversed, and `List String`
contains the matched token strings in the order they were consumed.
-}
fromGrammar : TaggedGrammar meta -> Nld meta ( List meta, List String )
fromGrammar tg =
    let
        inner g =
            case g of
                NldGrammar.AnyToken ->
                    map (\t -> ( [], [ t ] )) token

                NldGrammar.MinimalToken weightedTokens ->
                    map (\t -> ( [], [ t ] )) (minimalToken weightedTokens)

                NldGrammar.Repeat innerTg ->
                    repeat (fromGrammar innerTg)
                        |> map
                            (\pairs ->
                                ( List.concatMap Tuple.first pairs
                                , List.concatMap Tuple.second pairs
                                )
                            )

                NldGrammar.Seq tgs ->
                    case tgs of
                        [] ->
                            pure ( [], [] )

                        first :: rest ->
                            List.foldl
                                (\step acc ->
                                    map2
                                        (\( m1, t1 ) ( m2, t2 ) -> ( m1 ++ m2, t1 ++ t2 ))
                                        acc
                                        (fromGrammar step)
                                )
                                (fromGrammar first)
                                rest

                NldGrammar.Choice tgs ->
                    choice (List.map fromGrammar tgs)

                NldGrammar.Literal str ->
                    map (\t -> ( [], [ t ] )) (literal str)

                NldGrammar.Token tokenType ->
                    map (\t -> ( [], [ t ] )) (tokenForType tokenType)
    in
    inner tg.grammar
        |> map (\( metas, tokens ) -> ( tg.meta ++ metas, tokens ))


tokenForType : NldGrammar.TokenType -> Nld meta String
tokenForType tokenType =
    More (NldGrammar.tagged [] (NldGrammar.Token tokenType))
        (\remaining prevPos ->
            remaining.byPosition
                |> Dict.toList
                |> List.filterMap
                    (\( pos, t ) ->
                        if matchesTokenType tokenType t then
                            Just
                                ( TokenPositions.gapCost prevPos pos
                                , Done t (TokenPositions.remove t pos remaining) pos
                                )

                        else
                            Nothing
                    )
        )


looksLikeDate : String -> Bool
looksLikeDate t =
    let
        allInts parts =
            List.all (\p -> String.toInt p /= Nothing) parts
    in
    case String.split "-" t of
        [ _, _, _ ] as parts ->
            allInts parts

        _ ->
            case String.split "/" t of
                [ _, _, _ ] as parts ->
                    allInts parts

                _ ->
                    False


looksLikeTime : String -> Bool
looksLikeTime t =
    case String.split ":" t of
        [ h, m ] ->
            String.toInt h /= Nothing && String.toInt m /= Nothing

        [ h, m, s ] ->
            String.toInt h /= Nothing && String.toInt m /= Nothing && String.toFloat s /= Nothing

        _ ->
            False


looksLikeDateTime : String -> Bool
looksLikeDateTime t =
    case String.split "T" t of
        [ datePart, timePart ] ->
            looksLikeDate datePart && looksLikeTime timePart

        _ ->
            looksLikeDate t
