module Code.HashTests exposing (..)

import Code.Hash as Hash
import Expect
import Test exposing (..)


equals : Test
equals =
    describe "Hash.equals"
        [ test "Returns True when equal" <|
            \_ ->
                Maybe.withDefault False (Maybe.map2 Hash.equals (Hash.fromString "#foo") (Hash.fromString "#foo"))
                    |> Expect.equal True
                    |> Expect.onFail "Expected Hash \"#foo\" and Hash \"#foo\" to be equal"
        , test "Returns False when not equal" <|
            \_ ->
                Maybe.withDefault False (Maybe.map2 Hash.equals (Hash.fromString "#foo") (Hash.fromString "#bar"))
                    |> Expect.equal False
                    |> Expect.onFail "Expected Hash \"#foo\" and Hash \"#bar\" to *not* be equal"
        ]


toShortString : Test
toShortString =
    describe "Hash.toShortString"
        [ test "Returns a short version of the hash" <|
            \_ ->
                let
                    result =
                        "#abc123def456"
                            |> Hash.fromString
                            |> Maybe.map Hash.toShortString
                            |> Maybe.withDefault "fail"
                in
                Expect.equal "#abc123de" result
        , test "doesn't shorten for builtins" <|
            \_ ->
                let
                    result =
                        "##IO.socketSend.impl"
                            |> Hash.fromString
                            |> Maybe.map Hash.toShortString
                            |> Maybe.withDefault "fail"
                in
                Expect.equal "##IO.socketSend.impl" result
        ]


stripHashPrefix : Test
stripHashPrefix =
    describe "Hash.stripHashPrefix"
        [ test "removes the prefix of the hash" <|
            \_ ->
                let
                    result =
                        Hash.stripHashPrefix "#abc123def456"
                in
                Expect.equal "abc123def456" result
        , test "removes both hash prefixes for builtins" <|
            \_ ->
                let
                    result =
                        Hash.stripHashPrefix "##IO.socketSend.impl"
                in
                Expect.equal "IO.socketSend.impl" result
        , test "ignores non hashes" <|
            \_ ->
                let
                    result =
                        Hash.stripHashPrefix "thisis#not##ahash"
                in
                Expect.equal "thisis#not##ahash" result
        ]


toUrlString : Test
toUrlString =
    describe "Hash.toUrlString"
        [ test "Extracts the raw hash value in a URL format" <|
            \_ ->
                let
                    result =
                        "#foo"
                            |> Hash.fromString
                            |> Maybe.map Hash.toUrlString
                            |> Maybe.withDefault "fail"
                in
                Expect.equal "@foo" result
        , test "URI encodes the raw hash" <|
            \_ ->
                let
                    result =
                        "#foo/"
                            |> Hash.fromString
                            |> Maybe.map Hash.toUrlString
                            |> Maybe.withDefault "fail"
                in
                Expect.equal "@foo%2F" result
        , test "URI encodes the raw hash with a constructor suffix" <|
            \_ ->
                let
                    result =
                        "#foo/#bar"
                            |> Hash.fromString
                            |> Maybe.map Hash.toUrlString
                            |> Maybe.withDefault "fail"
                in
                Expect.equal "@foo%2F@bar" result
        ]


toApiUrlString : Test
toApiUrlString =
    describe "Hash.toApiUrlString"
        [ test "Extracts the raw hash value in an API URL format" <|
            \_ ->
                let
                    result =
                        "#foo"
                            |> Hash.fromString
                            |> Maybe.map Hash.toApiUrlString
                            |> Maybe.withDefault "fail"
                in
                Expect.equal "@foo" result
        , test "URI encodes the raw hash" <|
            \_ ->
                let
                    result =
                        "#foo/"
                            |> Hash.fromString
                            |> Maybe.map Hash.toApiUrlString
                            |> Maybe.withDefault "fail"
                in
                Expect.equal "@foo%2F" result
        , test "URI encodes the raw hash with a constructor suffix" <|
            \_ ->
                let
                    result =
                        "#foo/#bar"
                            |> Hash.fromString
                            |> Maybe.map Hash.toApiUrlString
                            |> Maybe.withDefault "fail"
                in
                Expect.equal "@foo%2F@bar" result
        ]


fromString : Test
fromString =
    describe "Hash.fromString"
        [ test "Creates a Hash with a valid prefixed raw hash" <|
            \_ ->
                let
                    hash =
                        Hash.fromString "#foo"
                in
                Expect.equal (Just "#foo") (Maybe.map Hash.toString hash)
        , test "Fails to create a hash with an incorrect prefix" <|
            \_ ->
                let
                    hash =
                        Hash.fromString "$foo"
                in
                Expect.equal Nothing (Maybe.map Hash.toString hash)
        , test "Fails to create a hash with an @ symbol prefix" <|
            \_ ->
                let
                    hash =
                        Hash.fromString "@foo"
                in
                Expect.equal Nothing (Maybe.map Hash.toString hash)
        , test "Fails to create a hash with no symbol prefix" <|
            \_ ->
                let
                    hash =
                        Hash.fromString "foo"
                in
                Expect.equal Nothing (Maybe.map Hash.toString hash)
        ]


fromUrlString : Test
fromUrlString =
    describe "Hash.fromUrlString"
        [ test "Creates a Hash with a valid URL prefixed raw hash" <|
            \_ ->
                let
                    hash =
                        Hash.fromUrlString "@foo"
                in
                Expect.equal (Just "#foo") (Maybe.map Hash.toString hash)
        , test "Fails to create a hash with an incorrect prefix" <|
            \_ ->
                let
                    hash =
                        Hash.fromUrlString "$foo"
                in
                Expect.equal Nothing (Maybe.map Hash.toString hash)
        , test "Fails to create a hash with an # symbol prefix" <|
            \_ ->
                let
                    hash =
                        Hash.fromUrlString "#foo"
                in
                Expect.equal Nothing (Maybe.map Hash.toString hash)
        , test "Fails to create a hash with no symbol prefix" <|
            \_ ->
                let
                    hash =
                        Hash.fromUrlString "foo"
                in
                Expect.equal Nothing (Maybe.map Hash.toString hash)
        ]


isRawHash : Test
isRawHash =
    describe "Hash.isRawHash"
        [ test "True for strings prefixed with #" <|
            \_ ->
                Hash.isRawHash "#foo"
                    |> Expect.equal True
                    |> Expect.onFail "# is a raw hash"
        , test "True for strings prefixed with @" <|
            \_ ->
                Hash.isRawHash "@foo"
                    |> Expect.equal True
                    |> Expect.onFail "@ is a raw hash"
        , test "False for non prefixed strings" <|
            \_ ->
                Hash.isRawHash "foo"
                    |> Expect.equal False
                    |> Expect.onFail "needs prefix"
        ]
