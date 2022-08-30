module Code.ProjectTests exposing (..)

import Code.Project as Project
import Expect
import Lib.Slug as Slug
import Lib.UserHandle as UserHandle
import Test exposing (..)


shorthand : Test
shorthand =
    describe "Project.shorthand"
        [ test "Returns the shorthand of a project by owner and name" <|
            \_ ->
                Expect.equal
                    "@unison/http"
                    (Project.shorthand project)
        ]



-- Helpers


project : Project.ProjectListing
project =
    { handle = UserHandle.unsafeFromString "unison"
    , slug = Slug.unsafeFromString "http"
    , name = "http"
    }
