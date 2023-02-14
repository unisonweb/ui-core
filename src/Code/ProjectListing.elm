module Code.ProjectListing exposing (..)

import Code.Hashvatar as Hashvatar
import Code.Project exposing (Project)
import Code.Project.ProjectRef as ProjectRef
import Html exposing (Html, div)
import Html.Attributes exposing (class, classList)
import UI.Click as Click exposing (Click)


type ProjectListingSize
    = Medium
    | Large
    | Huge


type alias ProjectListing p msg =
    { project : Project p
    , click : Maybe (Click msg)
    , size : ProjectListingSize
    , subdued : Bool
    }



-- CREATE


projectListing : Project p -> ProjectListing p msg
projectListing project =
    { project = project, click = Nothing, size = Medium, subdued = False }



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


subdued : ProjectListing p msg -> ProjectListing p msg
subdued p =
    { p | subdued = True }



-- MAP


map : (aMsg -> bMsg) -> ProjectListing p aMsg -> ProjectListing p bMsg
map f p =
    { project = p.project
    , click = Maybe.map (Click.map f) p.click
    , size = p.size
    , subdued = p.subdued
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


viewSubdued : ProjectListing p msg -> Html msg
viewSubdued { project, size, click } =
    let
        attrs =
            [ class "project-listing project-listing_subdued", class (sizeClass size) ]

        content =
            [ Hashvatar.empty
            , ProjectRef.view project.ref
            ]
    in
    case click of
        Just c ->
            Click.view attrs content c

        Nothing ->
            div attrs content


view : ProjectListing p msg -> Html msg
view p =
    let
        attrs =
            [ class "project-listing"
            , class (sizeClass p.size)
            , classList [ ( "project-listing_subdued", p.subdued ) ]
            ]

        hashvatar =
            if p.subdued then
                Hashvatar.empty

            else
                ProjectRef.viewHashvatar p.project.ref

        content =
            [ hashvatar
            , ProjectRef.view p.project.ref
            ]
    in
    case p.click of
        Just c ->
            Click.view attrs content c

        Nothing ->
            div attrs content
