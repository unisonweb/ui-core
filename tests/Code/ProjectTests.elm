module Code.ProjectTests exposing (..)

import Code.Project as Project exposing (Project)
import Code.Project.ProjectRef as ProjectRef
import Code.Project.ProjectSlug as ProjectSlug
import Expect
import Lib.UserHandle as UserHandle
import Set
import Test exposing (..)


ref : Test
ref =
    describe "Project.ref"
        [ test "Returns the ref of a project by handle and slug" <|
            \_ ->
                Expect.equal
                    "@unison/http"
                    (Project.ref project |> ProjectRef.toString)
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
                    (Project.slug project |> ProjectSlug.toString)
        ]


toggleFav : Test
toggleFav =
    let
        resultFor isFaved =
            let
                p =
                    Project.toggleFav (projectDetails isFaved 3)
            in
            ( p.isFaved, p.numFavs )
    in
    describe "Project.toggleFav"
        [ test "toggles Unknown to Unknown" <|
            \_ ->
                Expect.equal (resultFor Project.Unknown) ( Project.Unknown, 3 )
        , test "toggles Faved to NotFaved" <|
            \_ ->
                Expect.equal (resultFor Project.Faved) ( Project.NotFaved, 2 )
        , test "toggles JustFaved to NotFaved" <|
            \_ ->
                Expect.equal (resultFor Project.JustFaved) ( Project.NotFaved, 2 )
        , test "toggles NotFaved to JustFaved" <|
            \_ ->
                Expect.equal (resultFor Project.NotFaved) ( Project.JustFaved, 4 )
        ]



-- Helpers


project : Project {}
project =
    { ref =
        ProjectRef.projectRef
            (UserHandle.unsafeFromString "unison")
            (ProjectSlug.unsafeFromString "http")
    , visibility = Project.Public
    }


projectDetails : Project.IsFaved -> Int -> Project.ProjectDetails
projectDetails isFaved numFavs =
    { ref =
        ProjectRef.projectRef
            (UserHandle.unsafeFromString "unison")
            (ProjectSlug.unsafeFromString "http")
    , isFaved = isFaved
    , numFavs = numFavs
    , numWeeklyDownloads = 123
    , summary = Just "hi i'm a summary"
    , tags = Set.empty
    , visibility = Project.Public
    , latestVersion = Nothing
    , defaultBranch = Nothing
    }
