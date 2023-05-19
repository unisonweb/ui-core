module Code.ProjectListing exposing (..)

import Code.Hashvatar as Hashvatar
import Code.Project as Project exposing (Project)
import Code.Project.ProjectRef as ProjectRef
import Html exposing (Html, div)
import Html.Attributes exposing (class, classList)
import UI
import UI.Click as Click exposing (Click)
import UI.Icon as Icon


type ProjectListingSize
    = Medium
    | Large
    | Huge


type ProjectListingClick msg
    = NoClick
    | ProjectClick (Click msg)
    | ProjectAndHandleClick { ref : Click msg, handle : Click msg }


type alias ProjectListing p msg =
    { project : Project p
    , click : ProjectListingClick msg
    , size : ProjectListingSize
    , subdued : Bool
    }



-- CREATE


projectListing : Project p -> ProjectListing p msg
projectListing project =
    { project = project, click = NoClick, size = Medium, subdued = False }



-- MODIFY


withClick : Click msg -> Click msg -> ProjectListing p msg -> ProjectListing p msg
withClick projectClick handleClick p =
    { p | click = ProjectAndHandleClick { ref = projectClick, handle = handleClick } }


withProjectClick : Click msg -> ProjectListing p msg -> ProjectListing p msg
withProjectClick click p =
    { p | click = ProjectClick click }


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


mapClick : (aMsg -> bMsg) -> ProjectListingClick aMsg -> ProjectListingClick bMsg
mapClick f click =
    case click of
        NoClick ->
            NoClick

        ProjectClick c ->
            ProjectClick (Click.map f c)

        ProjectAndHandleClick c ->
            ProjectAndHandleClick
                { ref = Click.map f c.ref
                , handle = Click.map f c.handle
                }


map : (aMsg -> bMsg) -> ProjectListing p aMsg -> ProjectListing p bMsg
map f p =
    { project = p.project
    , click = mapClick f p.click
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
    in
    case click of
        NoClick ->
            div attrs
                [ Hashvatar.empty
                , ProjectRef.view project.ref
                ]

        ProjectClick c ->
            Click.view attrs
                [ Hashvatar.empty
                , ProjectRef.view project.ref
                ]
                c

        ProjectAndHandleClick c ->
            div attrs
                [ Click.view [] [ Hashvatar.empty ] c.ref
                , ProjectRef.viewClickable c.handle c.ref project.ref
                ]


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

        privateIcon =
            case p.project.visibility of
                Project.Private ->
                    div [ class "project-listing_private-icon" ] [ Icon.view Icon.eyeSlash ]

                _ ->
                    UI.nothing
    in
    case p.click of
        NoClick ->
            div attrs
                [ hashvatar
                , ProjectRef.view p.project.ref
                , privateIcon
                ]

        ProjectClick c ->
            Click.view attrs
                [ hashvatar
                , ProjectRef.view p.project.ref
                , privateIcon
                ]
                c

        ProjectAndHandleClick c ->
            div attrs
                [ Click.view [] [ hashvatar ] c.ref
                , ProjectRef.viewClickable c.handle c.ref p.project.ref
                , privateIcon
                ]
