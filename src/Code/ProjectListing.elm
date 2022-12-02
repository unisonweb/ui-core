module Code.ProjectListing exposing (..)

import Code.Hash as Hash
import Code.Hashvatar as Hashvatar
import Code.Project exposing (Project)
import Code.Project.ProjectShorthand as ProjectShorthand
import Html exposing (Html)
import Html.Attributes exposing (class)
import UI.Click as Click


type alias ProjectListing p =
    { project : Project p
    }


view : Click.Click msg -> ProjectListing p -> Html msg
view click { project } =
    let
        hash =
            Hash.unsafeFromString (ProjectShorthand.toString project.shorthand)
    in
    Click.view [ class "project-listing" ]
        [ Hashvatar.view hash
        , ProjectShorthand.view project.shorthand
        ]
        click
