module Code.Project exposing (..)

import Code.Hash as Hash
import Code.Hashvatar as Hashvatar
import Code.Project.ProjectShorthand as ProjectShorthand exposing (ProjectShorthand)
import Code.Project.ProjectSlug exposing (ProjectSlug)
import Html exposing (Html)
import Html.Attributes exposing (class)
import Lib.UserHandle exposing (UserHandle)
import Set exposing (Set)
import UI.Click as Click


type alias Project a =
    { a | shorthand : ProjectShorthand }


type ProjectVisibility
    = Public


type alias ProjectDetails =
    Project
        { summary : Maybe String
        , tags : Set String
        , visibility : ProjectVisibility
        }


shorthand : Project a -> ProjectShorthand
shorthand project =
    project.shorthand


handle : Project a -> UserHandle
handle p =
    ProjectShorthand.handle p.shorthand


slug : Project a -> ProjectSlug
slug p =
    ProjectShorthand.slug p.shorthand


equals : Project a -> Project b -> Bool
equals a b =
    ProjectShorthand.equals a.shorthand b.shorthand



-- View


viewProjectListing : Click.Click msg -> Project a -> Html msg
viewProjectListing click project =
    let
        hash =
            Hash.unsafeFromString (ProjectShorthand.toString project.shorthand)
    in
    Click.view [ class "project-listing" ]
        [ Hashvatar.view hash
        , ProjectShorthand.view project.shorthand
        ]
        click
