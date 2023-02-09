module Code.BranchShorthandTests exposing (..)

import Code.BranchShorthand as BranchShorthand
import Expect
import Test exposing (..)


isValidBranchSlug : Test
isValidBranchSlug =
    describe "Branch.isValidBranchSlug"
        [ test "can be alphanumeric characters" <|
            \_ ->
                let
                    result =
                        BranchShorthand.isValidBranchSlug "mybranch"
                in
                Expect.true "Expected simple aplhanum in slugs to pass validation" result
        , test "can be any casing" <|
            \_ ->
                let
                    result =
                        BranchShorthand.isValidBranchSlug "AnyCasing"
                in
                Expect.true "Expected any casing in slugs to pass validation" result
        , test "can include _" <|
            \_ ->
                let
                    result =
                        BranchShorthand.isValidBranchSlug "underscores__are_valid"
                in
                Expect.true "Expected underscores in slugs to pass validation" result
        , test "can include -" <|
            \_ ->
                let
                    result =
                        BranchShorthand.isValidBranchSlug "dashes-are--valid"
                in
                Expect.true "Expected dashes in slugs to pass validation" result
        , test "can not have spaces" <|
            \_ ->
                let
                    result =
                        BranchShorthand.isValidBranchSlug "cant have spaces"
                in
                Expect.false "Expected spaces in slugs to fail validation" result
        , test "can not have symbols" <|
            \_ ->
                let
                    result =
                        BranchShorthand.isValidBranchSlug "ca|n/th\u{0007}ve$ymbols\"'!@#"
                in
                Expect.false "Expected symbols in slugs to fail validation" result
        ]


fromString : Test
fromString =
    describe "Branch.fromString"
        [ test "parses a simple topic branch slug" <|
            \_ ->
                let
                    result =
                        BranchShorthand.fromString "mybranch"

                    expected =
                        Just (BranchShorthand.unsafeFromString "mybranch")
                in
                Expect.equal result expected
        , test "parses a branch with dashes" <|
            \_ ->
                let
                    result =
                        BranchShorthand.fromString "my-branch"

                    expected =
                        Just (BranchShorthand.unsafeFromString "my-branch")
                in
                Expect.equal result expected
        , test "parses a branch with underscores" <|
            \_ ->
                let
                    result =
                        BranchShorthand.fromString "my_branch"

                    expected =
                        Just (BranchShorthand.unsafeFromString "my_branch")
                in
                Expect.equal result expected
        , test "parses a topic branch with a handle" <|
            \_ ->
                let
                    result =
                        BranchShorthand.fromString "@somehandle/mybranch"

                    expected =
                        Just (BranchShorthand.unsafeFromString "@somehandle/mybranch")
                in
                Expect.equal result expected
        , test "fails to parse a branch with special characters" <|
            \_ ->
                let
                    result =
                        BranchShorthand.fromString "m$^&ybranch"

                    expected =
                        Nothing
                in
                Expect.equal result expected
        , test "fails to parse a branch with slashes and no handle" <|
            \_ ->
                let
                    result =
                        BranchShorthand.fromString "my/branch"

                    expected =
                        Nothing
                in
                Expect.equal result expected
        , test "fails to parse a branch beginning with a slash" <|
            \_ ->
                let
                    result =
                        BranchShorthand.fromString "my/branch"

                    expected =
                        Nothing
                in
                Expect.equal result expected
        , test "fails to parse a branch beginning with only a handle" <|
            \_ ->
                let
                    result =
                        BranchShorthand.fromString "my/branch"

                    expected =
                        Nothing
                in
                Expect.equal result expected
        , test "fails to parse a branch with a handle, but more than 1 slash" <|
            \_ ->
                let
                    result =
                        BranchShorthand.fromString "@someowner/mybranch/annother"

                    expected =
                        Nothing
                in
                Expect.equal result expected
        , test "fails to parse a branch with an @ in the middle" <|
            \_ ->
                let
                    result =
                        BranchShorthand.fromString "someowner@mybranch"

                    expected =
                        Nothing
                in
                Expect.equal result expected
        , test "fails to parse a branch with an multiple @" <|
            \_ ->
                let
                    result =
                        BranchShorthand.fromString "@someowner@mybranch"

                    expected =
                        Nothing
                in
                Expect.equal result expected
        , test "fails to parse a branch with an multiple @ and a slash" <|
            \_ ->
                let
                    result =
                        BranchShorthand.fromString "@some@owner/mybranch"

                    expected =
                        Nothing
                in
                Expect.equal result expected
        ]


toString : Test
toString =
    describe "BranchShorthand.toString"
        [ test "just slug" <|
            \_ ->
                let
                    result =
                        "mybranch"
                            |> BranchShorthand.unsafeFromString
                            |> BranchShorthand.toString
                in
                Expect.equal "mybranch" result
        , test "owner handle and slug" <|
            \_ ->
                let
                    result =
                        "@owner/mybranch"
                            |> BranchShorthand.unsafeFromString
                            |> BranchShorthand.toString
                in
                Expect.equal "@owner/mybranch" result
        ]
