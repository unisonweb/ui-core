module Code.ProjectTests exposing (..)

import Code.Project as Project
import Code.Project.ProjectShorthand as ProjectShorthand
import Expect
import Lib.Slug as Slug
import Lib.UserHandle as UserHandle
import Test exposing (..)


shorthand : Test
shorthand =
    describe "Project.shorthand"
        [ test "Returns the shorthand of a project by handle and slug" <|
            \_ ->
                Expect.equal
                    "@unison/http"
                    (Project.shorthand project |> ProjectShorthand.toString)
        ]


handle : Test
handle =
    describe "Project.handle"
        [ test "Returns the handle of a project" <|
            \_ ->
                Expect.equal
                    "@unison"
                    (Project.handle project |> UserHandle.toString)
        ]


slug : Test
slug =
    describe "Project.slug"
        [ test "Returns the slug of a project" <|
            \_ ->
                Expect.equal
                    "http"
                    (Project.slug project |> Slug.toString)
        ]



-- Helpers


project : Project.ProjectListing
project =
    { shorthand =
        ProjectShorthand.projectShorthand
            (UserHandle.unsafeFromString "unison")
            (Slug.unsafeFromString "http")
    , name = "http"
    }
