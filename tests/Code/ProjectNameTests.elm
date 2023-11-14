module Code.ProjectNameTests exposing (..)

import Code.ProjectName as ProjectName exposing (ProjectName)
import Code.ProjectSlug as ProjectSlug
import Expect
import Lib.UserHandle as UserHandle
import Test exposing (..)


toString : Test
toString =
    describe "ProjectName.toString"
        [ test "Formats the ref to a string" <|
            \_ ->
                Expect.equal
                    "@unison/http"
                    (ProjectName.toString projectName)
        ]


fromString : Test
fromString =
    describe "ProjectName.fromString"
        [ test "creates a ProjectName from valid handle string and a valid slug string" <|
            \_ ->
                let
                    result =
                        ProjectName.fromString "@unison/http"
                            |> Maybe.map ProjectName.toString
                            |> Maybe.withDefault "FAIL"
                in
                Expect.equal "@unison/http" result
        ]


unsafeFromString : Test
unsafeFromString =
    describe "ProjectName.unsafeFromString"
        [ test "creates a ProjectName from valid unprefixed handle string and a valid slug string" <|
            \_ ->
                let
                    result =
                        ProjectName.unsafeFromString "unison/http"
                            |> ProjectName.toString
                in
                Expect.equal "@unison/http" result
        ]


handle : Test
handle =
    describe "ProjectName.handle"
        [ test "Extracts the handle" <|
            \_ ->
                Expect.equal
                    "@unison"
                    (ProjectName.handle projectName |> Maybe.map UserHandle.toString |> Maybe.withDefault "FAIL")
        ]


slug : Test
slug =
    describe "ProjectName.slug"
        [ test "Extracts the slug" <|
            \_ ->
                Expect.equal
                    "http"
                    (ProjectName.slug projectName |> ProjectSlug.toString)
        ]



-- Helpers


projectName : ProjectName
projectName =
    let
        handle_ =
            UserHandle.unsafeFromString "unison"

        slug_ =
            ProjectSlug.unsafeFromString "http"
    in
    ProjectName.projectName (Just handle_) slug_
