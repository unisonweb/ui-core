module Code.Project.ProjectShorthandTests exposing (..)

import Code.Project.ProjectShorthand as ProjectShorthand exposing (ProjectShorthand)
import Expect
import Lib.Slug as Slug
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
                    (ProjectShorthand.slug projectShorthand |> Slug.toString)
        ]



-- Helpers


projectShorthand : ProjectShorthand
projectShorthand =
    let
        handle_ =
            UserHandle.unsafeFromString "unison"

        slug_ =
            Slug.unsafeFromString "http"
    in
    ProjectShorthand.projectShorthand handle_ slug_
