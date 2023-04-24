module Code.ProjectVersionTests exposing (..)

import Code.ProjectVersion as ProjectVersion exposing (projectVersion)
import Expect
import Test exposing (..)


equals : Test
equals =
    describe "ProjectVersion.equals"
        [ test "Returns True when equal" <|
            \_ ->
                ProjectVersion.equals (projectVersion 1 2 3) (projectVersion 1 2 3)
                    |> Expect.equal True
                    |> Expect.onFail "Expected ProjectVersion \"1.2.3\" and ProjectVersion \"1.2.3\" to be equal"
        , test "Returns False when not equal on major" <|
            \_ ->
                ProjectVersion.equals (projectVersion 1 2 3) (projectVersion 2 2 3)
                    |> Expect.equal False
                    |> Expect.onFail "Expected ProjectVersion \"1.2.3\" and ProjectVersion \"2.2.3\" not to be equal"
        , test "Returns False when not equal on minor" <|
            \_ ->
                ProjectVersion.equals (projectVersion 1 2 3) (projectVersion 1 3 3)
                    |> Expect.equal False
                    |> Expect.onFail "Expected ProjectVersion \"1.2.3\" and ProjectVersion \"1.3.3\" not to be equal"
        , test "Returns False when not equal on patch" <|
            \_ ->
                ProjectVersion.equals (projectVersion 1 2 3) (projectVersion 1 2 4)
                    |> Expect.equal False
                    |> Expect.onFail "Expected ProjectVersion \"1.2.3\" and ProjectVersion \"1.2.4\" not to be equal"
        ]


major : Test
major =
    describe "ProjectVersion.major"
        [ test "Returns a the major part of the version" <|
            \_ ->
                projectVersion 2 3 4
                    |> ProjectVersion.major
                    |> Expect.equal 2
        ]


minor : Test
minor =
    describe "ProjectVersion.minor"
        [ test "Returns a the minor part of the version" <|
            \_ ->
                projectVersion 2 3 4
                    |> ProjectVersion.minor
                    |> Expect.equal 3
        ]


patch : Test
patch =
    describe "ProjectVersion.patch"
        [ test "Returns a the patch part of the version" <|
            \_ ->
                projectVersion 2 3 4
                    |> ProjectVersion.patch
                    |> Expect.equal 4
        ]


nextMajor : Test
nextMajor =
    describe "ProjectVersion.nextMajor"
        [ test "Returns a the next major version" <|
            \_ ->
                projectVersion 2 3 4
                    |> ProjectVersion.nextMajor
                    |> ProjectVersion.toString
                    |> Expect.equal "3.0.0"
        ]


nextMinor : Test
nextMinor =
    describe "ProjectVersion.nextMinor"
        [ test "Returns a the next minor version" <|
            \_ ->
                projectVersion 2 3 4
                    |> ProjectVersion.nextMinor
                    |> ProjectVersion.toString
                    |> Expect.equal "2.4.0"
        ]


nextPatch : Test
nextPatch =
    describe "ProjectVersion.nextPatch"
        [ test "Returns a the next patch version" <|
            \_ ->
                projectVersion 2 3 4
                    |> ProjectVersion.nextPatch
                    |> ProjectVersion.toString
                    |> Expect.equal "2.3.5"
        ]


toList : Test
toList =
    describe "ProjectVersion.toList"
        [ test "Returns a list version of the version" <|
            \_ ->
                projectVersion 2 3 4
                    |> ProjectVersion.toList
                    |> Expect.equal [ 2, 3, 4 ]
        ]


toString : Test
toString =
    describe "ProjectVersion.toString"
        [ test "Returns a string version of the version" <|
            \_ ->
                projectVersion 2 3 4
                    |> ProjectVersion.toString
                    |> Expect.equal "2.3.4"
        ]


toUrlString : Test
toUrlString =
    describe "ProjectVersion.toUrlString"
        [ test "Returns a url string version of the version" <|
            \_ ->
                projectVersion 2 3 4
                    |> ProjectVersion.toUrlString
                    |> Expect.equal "2_3_4"
        ]


fromList : Test
fromList =
    describe "ProjectVersion.fromList"
        [ test "Creates a ProjectVersion with a valid version list" <|
            \_ ->
                let
                    pv =
                        ProjectVersion.fromList [ 2, 3, 4 ]
                in
                Expect.equal (Just "2.3.4") (Maybe.map ProjectVersion.toString pv)
        , test "Fails to create a hash with an incorrect format" <|
            \_ ->
                let
                    pv =
                        ProjectVersion.fromList [ 2, 3 ]
                in
                Expect.equal Nothing (Maybe.map ProjectVersion.toString pv)
        ]


fromString : Test
fromString =
    describe "ProjectVersion.fromString"
        [ test "Creates a ProjectVersion with a valid version string" <|
            \_ ->
                let
                    pv =
                        ProjectVersion.fromString "2.3.4"
                in
                Expect.equal (Just "2.3.4") (Maybe.map ProjectVersion.toString pv)
        , test "Fails to create a hash with an incorrect format" <|
            \_ ->
                let
                    pv =
                        ProjectVersion.fromString "2.1"
                in
                Expect.equal Nothing (Maybe.map ProjectVersion.toString pv)
        ]


fromUrlString : Test
fromUrlString =
    describe "ProjectVersion.fromUrlString"
        [ test "Creates a ProjectVersion with a valid version string" <|
            \_ ->
                let
                    pv =
                        ProjectVersion.fromString "2.3.4"
                in
                Expect.equal (Just "2.3.4") (Maybe.map ProjectVersion.toString pv)
        , test "Fails to create a ProjectVersion with an incorrect format" <|
            \_ ->
                let
                    pv =
                        ProjectVersion.fromString "2.1"
                in
                Expect.equal Nothing (Maybe.map ProjectVersion.toString pv)
        ]


lessThan : Test
lessThan =
    describe "ProjectVersion.lessThan"
        [ test "returns True when `a` is less than `b`" <|
            \_ ->
                let
                    a =
                        projectVersion 1 2 3

                    b =
                        projectVersion 1 2 4
                in
                Expect.equal True (ProjectVersion.lessThan a b)
        , test "returns False when `a` is greater than `b`" <|
            \_ ->
                let
                    a =
                        projectVersion 2 0 3

                    b =
                        projectVersion 1 2 4
                in
                Expect.equal False (ProjectVersion.lessThan a b)
        , test "returns False when `a` is equal to `b`" <|
            \_ ->
                let
                    a =
                        projectVersion 2 0 3

                    b =
                        projectVersion 2 0 3
                in
                Expect.equal False (ProjectVersion.lessThan a b)
        ]


greaterThan : Test
greaterThan =
    describe "ProjectVersion.greaterThan"
        [ test "returns True when `a` is greater than `b`" <|
            \_ ->
                let
                    a =
                        projectVersion 3 1 2

                    b =
                        projectVersion 1 2 4
                in
                Expect.equal True (ProjectVersion.greaterThan a b)
        , test "returns False when `a` is less than `b`" <|
            \_ ->
                let
                    a =
                        projectVersion 1 3 2

                    b =
                        projectVersion 2 0 3
                in
                Expect.equal False (ProjectVersion.greaterThan a b)
        , test "returns False when `a` is equal to `b`" <|
            \_ ->
                let
                    a =
                        projectVersion 2 0 3

                    b =
                        projectVersion 2 0 3
                in
                Expect.equal False (ProjectVersion.greaterThan a b)
        ]


compare : Test
compare =
    describe "ProjectVersion.compare"
        [ test "compares versions for use in List.sortWith" <|
            \_ ->
                let
                    input =
                        [ projectVersion 1 1 99
                        , projectVersion 3 1 2
                        , projectVersion 2 0 9
                        , projectVersion 3 1 1
                        ]

                    result =
                        input
                            |> List.sortWith ProjectVersion.compare
                            |> List.map ProjectVersion.toString

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
    describe "ProjectVersion.ascending"
        [ test "compares versions for use in List.sortWith" <|
            \_ ->
                let
                    input =
                        [ projectVersion 1 1 99
                        , projectVersion 3 1 2
                        , projectVersion 2 0 9
                        , projectVersion 3 1 1
                        ]

                    result =
                        input
                            |> List.sortWith ProjectVersion.ascending
                            |> List.map ProjectVersion.toString

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
    describe "ProjectVersion.descending"
        [ test "compares versions for use in List.sortWith" <|
            \_ ->
                let
                    input =
                        [ projectVersion 1 1 99
                        , projectVersion 3 1 2
                        , projectVersion 2 0 9
                        , projectVersion 3 1 1
                        ]

                    result =
                        input
                            |> List.sortWith ProjectVersion.descending
                            |> List.map ProjectVersion.toString

                    expected =
                        [ "3.1.2"
                        , "3.1.1"
                        , "2.0.9"
                        , "1.1.99"
                        ]
                in
                Expect.equal result expected
        ]
