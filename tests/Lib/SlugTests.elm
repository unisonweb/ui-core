module Lib.SlugTests exposing (..)

import Expect
import Lib.Slug as Slug
import Test exposing (..)


fromString : Test
fromString =
    describe "Slug.fromString"
        [ test "Creates a Slug from a valid string" <|
            \_ ->
                "tolkien"
                    |> Slug.fromString
                    |> Maybe.map Slug.toString
                    |> Expect.equal (Just "tolkien")
        , test "Fails to create from an invalid string" <|
            \_ ->
                Slug.fromString "-----"
                    |> Expect.equal Nothing
        ]


equals : Test
equals =
    describe "Slug.equals"
        [ test "Returns True when the slugs are the same" <|
            \_ ->
                let
                    a =
                        Slug.fromString "tolkien"

                    b =
                        Slug.fromString "tolkien"

                    result =
                        Maybe.map2 Slug.equals a b
                            |> Maybe.withDefault False
                in
                Expect.equal True result
                    |> Expect.onFail "Expected slugs tolkien and tolkien to be equal"
        , test "Returns False when the slugs are different" <|
            \_ ->
                let
                    a =
                        Slug.fromString "gimli"

                    b =
                        Slug.fromString "legolas"

                    result =
                        Maybe.map2 Slug.equals a b
                            |> Maybe.withDefault False
                in
                Expect.equal False result
                    |> Expect.onFail "Expected slugs gimli and legolas not to be equal"
        ]


toString : Test
toString =
    describe "Slug.toString"
        [ test "Returns a string version of a Slug" <|
            \_ ->
                let
                    result =
                        "gandalf"
                            |> Slug.fromString
                            |> Maybe.map Slug.toString
                            |> Maybe.withDefault "FAIL"
                in
                Expect.equal "gandalf" result
        ]


isValidSlug : Test
isValidSlug =
    describe "Slug.isValidSlug"
        [ test "Can be alphanumeric characters" <|
            \_ ->
                Slug.isValidSlug "samwise123"
                    |> Expect.equal True
                    |> Expect.onFail "Expected alphanumeric characters in slugs to succeed validation"
        , test "Can include hyphens" <|
            \_ ->
                Slug.isValidSlug "can-have-hyphens"
                    |> Expect.equal True
                    |> Expect.onFail "Expected hyphens in slugs to succeed validation"
        , test "Can' include consecutive hyphens" <|
            \_ ->
                Slug.isValidSlug "cant-have----consecutive--hyphens"
                    |> Expect.equal False
                    |> Expect.onFail "Expected consecutive hyphens in slugs to fail validation"
        , test "Can't have spaces" <|
            \_ ->
                Slug.isValidSlug "cant have spaces"
                    |> Expect.equal False
                    |> Expect.onFail "Expected spaces in slugs to fail validation"
        , test "Can't have symbols" <|
            \_ ->
                Slug.isValidSlug "cant have $ymbols$!@#_"
                    |> Expect.equal False
                    |> Expect.onFail "Expected symbols in slugs to fail validation"
        , test "Can't have underscores" <|
            \_ ->
                Slug.isValidSlug "cant_have_underscores"
                    |> Expect.equal False
                    |> Expect.onFail "Expected underscores in slugs to fail validation"
        , test "Can't be longer than 39 characters" <|
            \_ ->
                Slug.isValidSlug "cantbemorethanthirtyninecharacterslongthatswaytolongofaslug"
                    |> Expect.equal False
                    |> Expect.onFail "Expected long slugs to fail validation"
        , test "Can't start with a hyphen" <|
            \_ ->
                Slug.isValidSlug "-cant-start-with-a-hyphen"
                    |> Expect.equal False
                    |> Expect.onFail "Expected - prefixed slugs to fail validation"
        , test "Can't end with a hyphen" <|
            \_ ->
                Slug.isValidSlug "can-end-with-a-hyphen-"
                    |> Expect.equal False
                    |> Expect.onFail "Expected - suffixed slugs to fail validation"
        ]
