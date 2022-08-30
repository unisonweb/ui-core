module Lib.SlugTests exposing (..)

import Expect
import Lib.Slug as Slug
import Test exposing (..)


fromString : Test
fromString =
    describe "Slug.fromString"
        [ test "Creates a Slug from a valid string" <|
            \_ ->
                let
                    slug =
                        Slug.fromString "tolkien"

                    result =
                        slug |> Maybe.map Slug.toString
                in
                Expect.equal (Just "tolkien") result
        , test "Fails to create from an invalid string" <|
            \_ ->
                let
                    slug =
                        Slug.fromString "-----"
                in
                Expect.equal Nothing slug
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
                Expect.true "Expected slugs tolkien and tolkien to be equal" result
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
                Expect.false "Expected slugs gimli and legolas not to be equal" result
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
                let
                    result =
                        Slug.isValidSlug "samwise123"
                in
                Expect.true "Expected alphanumeric characters in slugs to succeed validation" result
        , test "Can include hyphens" <|
            \_ ->
                let
                    result =
                        Slug.isValidSlug "can-have-hyphens"
                in
                Expect.true "Expected hyphens in slugs to succeed validation" result
        , test "Can' include consecutive hyphens" <|
            \_ ->
                let
                    result =
                        Slug.isValidSlug "cant-have----consecutive--hyphens"
                in
                Expect.false "Expected consecutive hyphens in slugs to fail validation" result
        , test "Can't have spaces" <|
            \_ ->
                let
                    result =
                        Slug.isValidSlug "cant have spaces"
                in
                Expect.false "Expected spaces in slugs to fail validation" result
        , test "Can't have symbols" <|
            \_ ->
                let
                    result =
                        Slug.isValidSlug "cant have $ymbols$!@#_"
                in
                Expect.false "Expected symbols in slugs to fail validation" result
        , test "Can't have underscores" <|
            \_ ->
                let
                    result =
                        Slug.isValidSlug "cant_have_underscores"
                in
                Expect.false "Expected underscores in slugs to fail validation" result
        , test "Can't be longer than 39 characters" <|
            \_ ->
                let
                    result =
                        Slug.isValidSlug "cantbemorethanthirtyninecharacterslongthatswaytolongofaslug"
                in
                Expect.false "Expected long slugs to fail validation" result
        , test "Can't start with a hyphen" <|
            \_ ->
                let
                    result =
                        Slug.isValidSlug "-cant-start-with-a-hyphen"
                in
                Expect.false "Expected - prefixed slugs to fail validation" result
        , test "Can't end with a hyphen" <|
            \_ ->
                let
                    result =
                        Slug.isValidSlug "can-end-with-a-hyphen-"
                in
                Expect.false "Expected - suffixed slugs to fail validation" result
        ]
