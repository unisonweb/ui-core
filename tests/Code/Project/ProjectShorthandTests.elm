module Code.Project.ProjectShorthandTests exposing (..)

import Code.Project.ProjectShorthand as ProjectShorthand exposing (ProjectShorthand)
import Code.Project.ProjectSlug as ProjectSlug
import Expect
import Lib.UserHandle as UserHandle
import Test exposing (..)


toString : Test
toString =
    describe "ProjectShorthand.toString"
        [ test "Formats the shorthand to a string" <|
            \_ ->
                Expect.equal
                    "@unison/http"
                    (ProjectShorthand.toString projectShorthand)
        ]


fromString : Test
fromString =
    describe "ProjectShorthand.fromString"
        [ test "creates a ProjectShorthand from valid handle string and a valid slug string" <|
            \_ ->
                let
                    result =
                        ProjectShorthand.fromString "@unison" "http"
                            |> Maybe.map ProjectShorthand.toString
                            |> Maybe.withDefault "FAIL"
                in
                Expect.equal "@unison/http" result
        ]


unsafeFromString : Test
unsafeFromString =
    describe "ProjectShorthand.unsafeFromString"
        [ test "creates a ProjectShorthand from valid unprefixed handle string and a valid slug string" <|
            \_ ->
                let
                    result =
                        ProjectShorthand.unsafeFromString "unison" "http"
                            |> ProjectShorthand.toString
                in
                Expect.equal "@unison/http" result
        ]


handle : Test
handle =
    describe "ProjectShorthand.handle"
        [ test "Extracts the handle" <|
            \_ ->
                Expect.equal
                    "@unison"
                    (ProjectShorthand.handle projectShorthand |> UserHandle.toString)
        ]


slug : Test
slug =
    describe "ProjectShorthand.slug"
        [ test "Extracts the slug" <|
            \_ ->
                Expect.equal
                    "http"
                    (ProjectShorthand.slug projectShorthand |> ProjectSlug.toString)
        ]



-- Helpers


projectShorthand : ProjectShorthand
projectShorthand =
    let
        handle_ =
            UserHandle.unsafeFromString "unison"

        slug_ =
            ProjectSlug.unsafeFromString "http"
    in
    ProjectShorthand.projectShorthand handle_ slug_
