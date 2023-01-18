module Code.ProjectListing exposing (..)

import Code.Project exposing (Project)
import Code.Project.ProjectShorthand as ProjectShorthand
import Html exposing (Html, div)
import Html.Attributes exposing (class)
import UI.Click as Click exposing (Click)


type ProjectListingSize
    = Medium
    | Large
    | Huge


type alias ProjectListing p msg =
    { project : Project p
    , click : Maybe (Click msg)
    , size : ProjectListingSize
    }



-- CREATE


projectListing : Project p -> ProjectListing p msg
projectListing project =
    { project = project, click = Nothing, size = Medium }



-- MODIFY


withClick : Click msg -> ProjectListing p msg -> ProjectListing p msg
withClick click p =
    { p | click = Just click }


withSize : ProjectListingSize -> ProjectListing p msg -> ProjectListing p msg
withSize size p =
    { p | size = size }


medium : ProjectListing p msg -> ProjectListing p msg
medium p =
    withSize Medium p


large : ProjectListing p msg -> ProjectListing p msg
large p =
    withSize Large p


huge : ProjectListing p msg -> ProjectListing p msg
huge p =
    withSize Huge p



-- MAP


map : (aMsg -> bMsg) -> ProjectListing p aMsg -> ProjectListing p bMsg
map f p =
    { project = p.project
    , click = Maybe.map (Click.map f) p.click
    , size = p.size
    }



-- VIEW


sizeClass : ProjectListingSize -> String
sizeClass size =
    case size of
        Medium ->
            "project-listing-size_medium"

        Large ->
            "project-listing-size_large"

        Huge ->
            "project-listing-size_huge"


view : ProjectListing p msg -> Html msg
view { project, size, click } =
    let
        attrs =
            [ class "project-listing", class (sizeClass size) ]

        content =
            [ ProjectShorthand.viewHashvatar project.shorthand
            , ProjectShorthand.view project.shorthand
            ]
    in
    case click of
        Just c ->
            Click.view attrs content c

        Nothing ->
            div attrs content
