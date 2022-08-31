module Code.Project exposing (..)

import Code.Hash as Hash
import Code.Hashvatar as Hashvatar
import Code.Project.ProjectShorthand as ProjectShorthand exposing (ProjectShorthand)
import Html exposing (Html, text)
import Html.Attributes exposing (class)
import Json.Decode as Decode exposing (field, string)
import Lib.Slug as Slug exposing (Slug)
import Lib.UserHandle as UserHandle exposing (UserHandle)
import UI.Click as Click


type alias Project a =
    { a | shorthand : ProjectShorthand, name : String }


type alias ProjectListing =
    Project {}


shorthand : Project a -> ProjectShorthand
shorthand project =
    project.shorthand


handle : Project a -> UserHandle
handle p =
    ProjectShorthand.handle p.shorthand


slug : Project a -> Slug
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



-- Decode


decodeListing : Decode.Decoder ProjectListing
decodeListing =
    let
        mk handle_ slug_ name =
            { shorthand = ProjectShorthand.projectShorthand handle_ slug_
            , name = name
            }
    in
    Decode.map3
        mk
        (field "owner" UserHandle.decodeUnprefixed)
        (field "name" Slug.decode)
        (field "name" string)


decodeListings : Decode.Decoder (List ProjectListing)
decodeListings =
    Decode.list decodeListing
