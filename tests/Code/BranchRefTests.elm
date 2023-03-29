module Code.BranchRefTests exposing (..)

import Code.BranchRef as BranchRef
import Expect
import Test exposing (..)


isValidBranchSlug : Test
isValidBranchSlug =
    describe "Branch.isValidBranchSlug"
        [ test "can be alphanumeric characters" <|
            \_ ->
                BranchRef.isValidBranchSlug "mybranch"
                    |> Expect.equal True
                    |> Expect.onFail
                        "Expected simple aplhanum in slugs to pass validation"
        , test "can be any casing" <|
            \_ ->
                BranchRef.isValidBranchSlug "AnyCasing"
                    |> Expect.equal True
                    |> Expect.onFail
                        "Expected any casing in slugs to pass validation"
        , test "can include _" <|
            \_ ->
                BranchRef.isValidBranchSlug "underscores__are_valid"
                    |> Expect.equal True
                    |> Expect.onFail "Expected underscores in slugs to pass validation"
        , test "can include -" <|
            \_ ->
                BranchRef.isValidBranchSlug "dashes-are--valid"
                    |> Expect.equal True
                    |> Expect.onFail "Expected dashes in slugs to pass validation"
        , test "can not have spaces" <|
            \_ ->
                BranchRef.isValidBranchSlug "cant have spaces"
                    |> Expect.equal False
                    |> Expect.onFail "Expected spaces in slugs to fail validation"
        , test "can not have symbols" <|
            \_ ->
                BranchRef.isValidBranchSlug "ca|n/th\u{0007}ve$ymbols\"'!@#"
                    |> Expect.equal False
                    |> Expect.onFail "Expected symbols in slugs to fail validation"
        ]


fromString : Test
fromString =
    describe "Branch.fromString"
        [ test "parses a simple topic branch slug" <|
            \_ ->
                let
                    result =
                        BranchRef.fromString "mybranch"

                    expected =
                        Just (BranchRef.unsafeFromString "mybranch")
                in
                Expect.equal result expected
        , test "parses a branch with dashes" <|
            \_ ->
                let
                    result =
                        BranchRef.fromString "my-branch"

                    expected =
                        Just (BranchRef.unsafeFromString "my-branch")
                in
                Expect.equal result expected
        , test "parses a branch with underscores" <|
            \_ ->
                let
                    result =
                        BranchRef.fromString "my_branch"

                    expected =
                        Just (BranchRef.unsafeFromString "my_branch")
                in
                Expect.equal result expected
        , test "parses a topic branch with a handle" <|
            \_ ->
                let
                    result =
                        BranchRef.fromString "@somehandle/mybranch"

                    expected =
                        Just (BranchRef.unsafeFromString "@somehandle/mybranch")
                in
                Expect.equal result expected
        , test "fails to parse a branch with special characters" <|
            \_ ->
                let
                    result =
                        BranchRef.fromString "m$^&ybranch"

                    expected =
                        Nothing
                in
                Expect.equal result expected
        , test "fails to parse a branch with slashes and no handle" <|
            \_ ->
                let
                    result =
                        BranchRef.fromString "my/branch"

                    expected =
                        Nothing
                in
                Expect.equal result expected
        , test "fails to parse a branch beginning with a slash" <|
            \_ ->
                let
                    result =
                        BranchRef.fromString "my/branch"

                    expected =
                        Nothing
                in
                Expect.equal result expected
        , test "fails to parse a branch beginning with only a handle" <|
            \_ ->
                let
                    result =
                        BranchRef.fromString "my/branch"

                    expected =
                        Nothing
                in
                Expect.equal result expected
        , test "fails to parse a branch with a handle, but more than 1 slash" <|
            \_ ->
                let
                    result =
                        BranchRef.fromString "@someowner/mybranch/annother"

                    expected =
                        Nothing
                in
                Expect.equal result expected
        , test "fails to parse a branch with an @ in the middle" <|
            \_ ->
                let
                    result =
                        BranchRef.fromString "someowner@mybranch"

                    expected =
                        Nothing
                in
                Expect.equal result expected
        , test "fails to parse a branch with an multiple @" <|
            \_ ->
                let
                    result =
                        BranchRef.fromString "@someowner@mybranch"

                    expected =
                        Nothing
                in
                Expect.equal result expected
        , test "fails to parse a branch with an multiple @ and a slash" <|
            \_ ->
                let
                    result =
                        BranchRef.fromString "@some@owner/mybranch"

                    expected =
                        Nothing
                in
                Expect.equal result expected
        ]


toString : Test
toString =
    describe "BranchRef.toString"
        [ test "just slug" <|
            \_ ->
                let
                    result =
                        "mybranch"
                            |> BranchRef.unsafeFromString
                            |> BranchRef.toString
                in
                Expect.equal "mybranch" result
        , test "owner handle and slug" <|
            \_ ->
                let
                    result =
                        "@owner/mybranch"
                            |> BranchRef.unsafeFromString
                            |> BranchRef.toString
                in
                Expect.equal "@owner/mybranch" result
        ]


toApiUrlString : Test
toApiUrlString =
    describe "BranchRef.toApiUrlString"
        [ test "just slug" <|
            \_ ->
                let
                    result =
                        "mybranch"
                            |> BranchRef.unsafeFromString
                            |> BranchRef.toApiUrlString
                in
                Expect.equal "mybranch" result
        , test "owner handle and slug" <|
            \_ ->
                let
                    result =
                        "@owner/mybranch"
                            |> BranchRef.unsafeFromString
                            |> BranchRef.toApiUrlString
                in
                Expect.equal "@owner%2Fmybranch" result
        ]
