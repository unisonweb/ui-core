module Code.ProjectListing exposing (..)

import Code.Hash as Hash
import Code.Hashvatar as Hashvatar
import Code.Project exposing (Project)
import Code.Project.ProjectShorthand as ProjectShorthand
import Html exposing (Html, div)
import Html.Attributes exposing (class)
import UI.Click as Click exposing (Click)


type alias ProjectListing p msg =
    { project : Project p
    , click : Maybe (Click msg)
    }


withClick : Click msg -> ProjectListing p msg -> ProjectListing p msg
withClick click p =
    { p | click = Just click }


view : ProjectListing p msg -> Html msg
view { project, click } =
    let
        hash =
            Hash.unsafeFromString (ProjectShorthand.toString project.shorthand)
    in
    case click of
        Just c ->
            Click.view [ class "project-listing" ]
                [ Hashvatar.view hash
                , ProjectShorthand.view project.shorthand
                ]
                c

        Nothing ->
            div [ class "project-listing" ]
                [ Hashvatar.view hash
                , ProjectShorthand.view project.shorthand
                ]
