module Code.VersionTests exposing (..)

import Code.Version as Version exposing (version)
import Expect
import Test exposing (..)


equals : Test
equals =
    describe "Version.equals"
        [ test "Returns True when equal" <|
            \_ ->
                Version.equals (version 1 2 3) (version 1 2 3)
                    |> Expect.equal True
                    |> Expect.onFail "Expected Version \"1.2.3\" and ProjectVersion \"1.2.3\" to be equal"
        , test "Returns False when not equal on major" <|
            \_ ->
                Version.equals (version 1 2 3) (version 2 2 3)
                    |> Expect.equal False
                    |> Expect.onFail "Expected Version \"1.2.3\" and ProjectVersion \"2.2.3\" not to be equal"
        , test "Returns False when not equal on minor" <|
            \_ ->
                Version.equals (version 1 2 3) (version 1 3 3)
                    |> Expect.equal False
                    |> Expect.onFail "Expected Version \"1.2.3\" and ProjectVersion \"1.3.3\" not to be equal"
        , test "Returns False when not equal on patch" <|
            \_ ->
                Version.equals (version 1 2 3) (version 1 2 4)
                    |> Expect.equal False
                    |> Expect.onFail "Expected Version \"1.2.3\" and ProjectVersion \"1.2.4\" not to be equal"
        ]


major : Test
major =
    describe "Version.major"
        [ test "Returns a the major part of the version" <|
            \_ ->
                version 2 3 4
                    |> Version.major
                    |> Expect.equal 2
        ]


minor : Test
minor =
    describe "Version.minor"
        [ test "Returns a the minor part of the version" <|
            \_ ->
                version 2 3 4
                    |> Version.minor
                    |> Expect.equal 3
        ]


patch : Test
patch =
    describe "Version.patch"
        [ test "Returns a the patch part of the version" <|
            \_ ->
                version 2 3 4
                    |> Version.patch
                    |> Expect.equal 4
        ]


nextMajor : Test
nextMajor =
    describe "Version.nextMajor"
        [ test "Returns a the next major version" <|
            \_ ->
                version 2 3 4
                    |> Version.nextMajor
                    |> Version.toString
                    |> Expect.equal "3.0.0"
        ]


nextMinor : Test
nextMinor =
    describe "Version.nextMinor"
        [ test "Returns a the next minor version" <|
            \_ ->
                version 2 3 4
                    |> Version.nextMinor
                    |> Version.toString
                    |> Expect.equal "2.4.0"
        ]


nextPatch : Test
nextPatch =
    describe "Version.nextPatch"
        [ test "Returns a the next patch version" <|
            \_ ->
                version 2 3 4
                    |> Version.nextPatch
                    |> Version.toString
                    |> Expect.equal "2.3.5"
        ]


toList : Test
toList =
    describe "Version.toList"
        [ test "Returns a list version of the version" <|
            \_ ->
                version 2 3 4
                    |> Version.toList
                    |> Expect.equal [ 2, 3, 4 ]
        ]


toString : Test
toString =
    describe "Version.toString"
        [ test "Returns a string version of the version" <|
            \_ ->
                version 2 3 4
                    |> Version.toString
                    |> Expect.equal "2.3.4"
        ]


toUrlString : Test
toUrlString =
    describe "Version.toUrlString"
        [ test "Returns a url string version of the version (dots are supported)" <|
            \_ ->
                version 2 3 4
                    |> Version.toUrlString
                    |> Expect.equal "2.3.4"
        ]


fromList : Test
fromList =
    describe "Version.fromList"
        [ test "Creates a Version with a valid version list" <|
            \_ ->
                let
                    pv =
                        Version.fromList [ 2, 3, 4 ]
                in
                Expect.equal (Just "2.3.4") (Maybe.map Version.toString pv)
        , test "Fails to create a hash with an incorrect format" <|
            \_ ->
                let
                    pv =
                        Version.fromList [ 2, 3 ]
                in
                Expect.equal Nothing (Maybe.map Version.toString pv)
        ]


fromString : Test
fromString =
    describe "Version.fromString"
        [ test "Creates a Version with a valid version string" <|
            \_ ->
                let
                    pv =
                        Version.fromString "2.3.4"
                in
                Expect.equal (Just "2.3.4") (Maybe.map Version.toString pv)
        , test "Fails to create a hash with an incorrect format" <|
            \_ ->
                let
                    pv =
                        Version.fromString "2.1"
                in
                Expect.equal Nothing (Maybe.map Version.toString pv)
        ]


fromUrlString : Test
fromUrlString =
    describe "Version.fromUrlString"
        [ test "Creates a Version with a valid version string" <|
            \_ ->
                let
                    pv =
                        Version.fromString "2.3.4"
                in
                Expect.equal (Just "2.3.4") (Maybe.map Version.toString pv)
        , test "Fails to create a Version with an incorrect format" <|
            \_ ->
                let
                    pv =
                        Version.fromString "2.1"
                in
                Expect.equal Nothing (Maybe.map Version.toString pv)
        ]


lessThan : Test
lessThan =
    describe "Version.lessThan"
        [ test "returns True when `a` is less than `b`" <|
            \_ ->
                let
                    a =
                        version 1 2 3

                    b =
                        version 1 2 4
                in
                Expect.equal True (Version.lessThan a b)
        , test "returns False when `a` is greater than `b`" <|
            \_ ->
                let
                    a =
                        version 2 0 3

                    b =
                        version 1 2 4
                in
                Expect.equal False (Version.lessThan a b)
        , test "returns False when `a` is equal to `b`" <|
            \_ ->
                let
                    a =
                        version 2 0 3

                    b =
                        version 2 0 3
                in
                Expect.equal False (Version.lessThan a b)
        ]


greaterThan : Test
greaterThan =
    describe "Version.greaterThan"
        [ test "returns True when `a` is greater than `b`" <|
            \_ ->
                let
                    a =
                        version 3 1 2

                    b =
                        version 1 2 4
                in
                Expect.equal True (Version.greaterThan a b)
        , test "returns False when `a` is less than `b`" <|
            \_ ->
                let
                    a =
                        version 1 3 2

                    b =
                        version 2 0 3
                in
                Expect.equal False (Version.greaterThan a b)
        , test "returns False when `a` is equal to `b`" <|
            \_ ->
                let
                    a =
                        version 2 0 3

                    b =
                        version 2 0 3
                in
                Expect.equal False (Version.greaterThan a b)
        ]


compare : Test
compare =
    describe "Version.compare"
        [ test "compares versions for use in List.sortWith" <|
            \_ ->
                let
                    input =
                        [ version 1 1 99
                        , version 3 1 2
                        , version 2 0 9
                        , version 3 1 1
                        ]

                    result =
                        input
                            |> List.sortWith Version.compare
                            |> List.map Version.toString

                    expected =
                        [ "1.1.99"
                        , "2.0.9"
                        , "3.1.1"
                        , "3.1.2"
                        ]
                in
                Expect.equal result expected
        ]


ascending : Test
ascending =
    describe "Version.ascending"
        [ test "compares versions for use in List.sortWith" <|
            \_ ->
                let
                    input =
                        [ version 1 1 99
                        , version 3 1 2
                        , version 2 0 9
                        , version 3 1 1
                        ]

                    result =
                        input
                            |> List.sortWith Version.ascending
                            |> List.map Version.toString

                    expected =
                        [ "1.1.99"
                        , "2.0.9"
                        , "3.1.1"
                        , "3.1.2"
                        ]
                in
                Expect.equal result expected
        ]


descending : Test
descending =
    describe "Version.descending"
        [ test "compares versions for use in List.sortWith" <|
            \_ ->
                let
                    input =
                        [ version 1 1 99
                        , version 3 1 2
                        , version 2 0 9
                        , version 3 1 1
                        ]

                    result =
                        input
                            |> List.sortWith Version.descending
                            |> List.map Version.toString

                    expected =
                        [ "3.1.2"
                        , "3.1.1"
                        , "2.0.9"
                        , "1.1.99"
                        ]
                in
                Expect.equal result expected
        ]


isANextValid : Test
isANextValid =
    describe "Version.isANextValid"
        [ test "compares versions for use in List.sortWith" <|
            \_ ->
                let
                    input =
                        [ version 1 1 99
                        , version 3 1 2
                        , version 2 0 9
                        , version 3 1 1
                        ]

                    result =
                        input
                            |> List.sortWith Version.descending
                            |> List.map Version.toString

                    expected =
                        [ "3.1.2"
                        , "3.1.1"
                        , "2.0.9"
                        , "1.1.99"
                        ]
                in
                Expect.equal result expected
        ]


{-| Given a candidate, find the next and nearest valid version


## Examples:

  - clampToNextValid (Version 1 0 0) (Version 0 0 1)
    -> Version 2 0 0

  - clampToNextValid (Version 1 0 0) (Version 1.1.0)
    -> Version 1.1.0

  - clampToNextValid (Version 1 0 0) (Version 1.5.0)
    -> Version 1.1.0

  - clampToNextValid (Version 1 0 0) (Version 1.0.3)
    -> Version 1.0.1

-}
clampToNextValid : Test
clampToNextValid =
    describe "Version.clampToNextValid"
        [ test "compares versions for use in List.sortWith" <|
            \_ ->
                let
                    input =
                        [ version 1 1 99
                        , version 3 1 2
                        , version 2 0 9
                        , version 3 1 1
                        ]

                    result =
                        input
                            |> List.sortWith Version.descending
                            |> List.map Version.toString

                    expected =
                        [ "3.1.2"
                        , "3.1.1"
                        , "2.0.9"
                        , "1.1.99"
                        ]
                in
                Expect.equal result expected
        ]
