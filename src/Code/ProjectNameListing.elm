module Code.ProjectNameListing exposing (..)

import Code.Hashvatar as Hashvatar
import Code.ProjectName as ProjectName exposing (ProjectName)
import Code.ProjectSlug exposing (ProjectSlug)
import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Lib.Aria exposing (ariaLabel)
import Lib.UserHandle exposing (UserHandle)
import UI.Click as Click exposing (Click)


type ProjectNameListingSize
    = Medium
    | Large
    | Huge


type ProjectNameListingColor
    = FullColor
    | Subdued
    | VerySubdued


type ProjectNameListingClick msg
    = NoClick
    | ProjectClick (ProjectName -> Click msg)
    | ProjectAndHandleClick
        { handle : UserHandle -> Click msg
        , slug : ProjectSlug -> Click msg
        }


type alias ProjectNameListing msg =
    { projectName : ProjectName
    , click : ProjectNameListingClick msg
    , size : ProjectNameListingSize
    , color : ProjectNameListingColor
    }



-- CREATE


projectNameListing : ProjectName -> ProjectNameListing msg
projectNameListing projectName =
    { projectName = projectName, click = NoClick, size = Medium, color = FullColor }



-- MODIFY


withClick : (UserHandle -> Click msg) -> (ProjectSlug -> Click msg) -> ProjectNameListing msg -> ProjectNameListing msg
withClick handleClick projectSlugClick p =
    { p
        | click =
            ProjectAndHandleClick
                { handle = handleClick, slug = projectSlugClick }
    }


withProjectClick : (ProjectName -> Click msg) -> ProjectNameListing msg -> ProjectNameListing msg
withProjectClick click p =
    { p | click = ProjectClick click }


withSize : ProjectNameListingSize -> ProjectNameListing msg -> ProjectNameListing msg
withSize size p =
    { p | size = size }


medium : ProjectNameListing msg -> ProjectNameListing msg
medium p =
    withSize Medium p


large : ProjectNameListing msg -> ProjectNameListing msg
large p =
    withSize Large p


huge : ProjectNameListing msg -> ProjectNameListing msg
huge p =
    withSize Huge p


subdued : ProjectNameListing msg -> ProjectNameListing msg
subdued p =
    { p | color = Subdued }


verySubdued : ProjectNameListing msg -> ProjectNameListing msg
verySubdued p =
    { p | color = VerySubdued }



-- MAP


mapClick : (aMsg -> bMsg) -> ProjectNameListingClick aMsg -> ProjectNameListingClick bMsg
mapClick f click =
    case click of
        NoClick ->
            NoClick

        ProjectClick c ->
            ProjectClick (c >> Click.map f)

        ProjectAndHandleClick c ->
            ProjectAndHandleClick
                { handle = c.handle >> Click.map f
                , slug = c.slug >> Click.map f
                }


map : (aMsg -> bMsg) -> ProjectNameListing aMsg -> ProjectNameListing bMsg
map f p =
    { projectName = p.projectName
    , click = mapClick f p.click
    , size = p.size
    , color = p.color
    }



-- VIEW


sizeClass : ProjectNameListingSize -> String
sizeClass size =
    case size of
        Medium ->
            "project-name-listing-size_medium"

        Large ->
            "project-name-listing-size_large"

        Huge ->
            "project-name-listing-size_huge"


viewSubdued : ProjectNameListing msg -> Html msg
viewSubdued { projectName, size, click } =
    let
        attrs =
            [ class "project-name-listing project-name-listing_subdued", class (sizeClass size) ]
    in
    case click of
        NoClick ->
            div attrs
                [ Hashvatar.empty
                , ProjectName.view projectName
                ]

        ProjectClick c ->
            Click.view attrs
                [ Hashvatar.empty
                , ProjectName.view projectName
                ]
                (c projectName)

        ProjectAndHandleClick c ->
            div attrs
                [ Click.view [] [ Hashvatar.empty ] (c.slug (ProjectName.slug projectName))
                , ProjectName.viewClickable c.handle c.slug projectName
                ]


view : ProjectNameListing msg -> Html msg
view p =
    let
        ( colorClass, hashvatar ) =
            case p.color of
                FullColor ->
                    ( "project-name-listing_fullColor"
                    , ProjectName.viewHashvatar p.projectName
                    )

                Subdued ->
                    ( "project-name-listing_subdued"
                    , ProjectName.viewHashvatar p.projectName
                    )

                VerySubdued ->
                    ( "project-name-listing_very-subdued"
                    , Hashvatar.empty
                    )

        attrs =
            [ class "project-name-listing"
            , class (sizeClass p.size)
            , class colorClass
            ]

        ariaLabel_ =
            ariaLabel (ProjectName.toString p.projectName)
    in
    case p.click of
        NoClick ->
            div attrs
                [ hashvatar
                , ProjectName.view p.projectName
                ]

        ProjectClick c ->
            Click.view (ariaLabel_ :: attrs)
                [ hashvatar
                , ProjectName.view p.projectName
                ]
                (c p.projectName)

        ProjectAndHandleClick c ->
            div attrs
                [ Click.view [ ariaLabel_ ] [ hashvatar ] (c.slug (ProjectName.slug p.projectName))
                , ProjectName.viewClickable c.handle c.slug p.projectName
                ]
