module Lib.Nld.TokenPositionsTest exposing (suite)

import Expect
import Lib.Nld.TokenPositions as TokenPositions
import Set
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Nld.TokenPositions"
        [ describe "fromList"
            [ test "absent token in empty list returns empty positions" <|
                \_ ->
                    let
                        tp =
                            TokenPositions.fromList []
                    in
                    Expect.equal Set.empty (TokenPositions.positions "foo" tp)
            , test "single token is at position 0" <|
                \_ ->
                    let
                        tp =
                            TokenPositions.fromList [ "foo" ]
                    in
                    Expect.equal (Set.singleton 0) (TokenPositions.positions "foo" tp)
            , test "tokens get sequential positions" <|
                \_ ->
                    let
                        tp =
                            TokenPositions.fromList [ "a", "b", "c" ]
                    in
                    Expect.all
                        [ \t -> Expect.equal (Set.singleton 0) (TokenPositions.positions "a" t)
                        , \t -> Expect.equal (Set.singleton 1) (TokenPositions.positions "b" t)
                        , \t -> Expect.equal (Set.singleton 2) (TokenPositions.positions "c" t)
                        ]
                        tp
            , test "duplicate tokens accumulate all their positions" <|
                \_ ->
                    let
                        tp =
                            TokenPositions.fromList [ "a", "b", "a" ]
                    in
                    Expect.equal (Set.fromList [ 0, 2 ]) (TokenPositions.positions "a" tp)
            ]
        , describe "positions"
            [ test "returns empty set for absent token" <|
                \_ ->
                    let
                        tp =
                            TokenPositions.fromList [ "foo" ]
                    in
                    Expect.equal Set.empty (TokenPositions.positions "bar" tp)
            , test "returns all positions for a repeated token" <|
                \_ ->
                    let
                        tp =
                            TokenPositions.fromList [ "x", "y", "x" ]
                    in
                    Expect.equal (Set.fromList [ 0, 2 ]) (TokenPositions.positions "x" tp)
            ]
        , describe "remove"
            [ test "removes token from both maps" <|
                \_ ->
                    let
                        tp =
                            TokenPositions.fromList [ "foo", "bar" ]

                        tp2 =
                            TokenPositions.remove "foo" 0 tp
                    in
                    Expect.all
                        [ \t -> Expect.equal Set.empty (TokenPositions.positions "foo" t)
                        , \t -> Expect.equal (Set.singleton 1) (TokenPositions.positions "bar" t)
                        ]
                        tp2
            , test "removing one occurrence of a duplicate leaves the other" <|
                \_ ->
                    let
                        tp =
                            TokenPositions.fromList [ "a", "a" ]

                        tp2 =
                            TokenPositions.remove "a" 0 tp
                    in
                    Expect.equal (Set.singleton 1) (TokenPositions.positions "a" tp2)
            , test "removing an absent token is a no-op" <|
                \_ ->
                    let
                        tp =
                            TokenPositions.fromList [ "foo" ]

                        tp2 =
                            TokenPositions.remove "bar" 99 tp
                    in
                    Expect.equal (Set.singleton 0) (TokenPositions.positions "foo" tp2)
            ]
        , describe "gapCost"
            [ test "zero cost at the same position" <|
                \_ ->
                    Expect.equal 0.0 (TokenPositions.gapCost 0 0)
            , test "forward gap cost equals the distance" <|
                \_ ->
                    Expect.equal 3.0 (TokenPositions.gapCost 0 3)
            , test "single step forward costs 1" <|
                \_ ->
                    Expect.equal 1.0 (TokenPositions.gapCost 2 3)
            , test "backward gap carries a 1.5x penalty" <|
                \_ ->
                    -- prevPos=3, currentPos=1: 1.5 * (3 - 1 + 1) = 1.5 * 3 = 4.5
                    Expect.within (Expect.Absolute 0.001) 4.5 (TokenPositions.gapCost 3 1)
            , test "single step back costs more than single step forward" <|
                \_ ->
                    let
                        forward =
                            TokenPositions.gapCost 2 3

                        backward =
                            TokenPositions.gapCost 3 2
                    in
                    Expect.lessThan backward forward
            ]
        ]
