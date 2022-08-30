module Code.Project exposing (..)

import Code.Hash as Hash
import Code.Hashvatar as Hashvatar
import Html exposing (Html, text)
import Html.Attributes exposing (class)
import Json.Decode as Decode exposing (field, string)
import Lib.Slug as Slug exposing (Slug)
import Lib.UserHandle as UserHandle exposing (UserHandle)
import UI.Click as Click


type alias Project a =
    { a | slug : Slug, handle : UserHandle, name : String }


type alias ProjectListing =
    Project {}


shorthand : Project a -> String
shorthand project =
    UserHandle.toString project.handle ++ "/" ++ Slug.toString project.slug


equals : Project a -> Project b -> Bool
equals a b =
    shorthand a == shorthand b



-- View


viewProjectListing : Click.Click msg -> Project a -> Html msg
viewProjectListing click project =
    let
        hash =
            Hash.unsafeFromString (shorthand project)
    in
    Click.view [ class "project-listing" ]
        [ Hashvatar.view hash
        , text (shorthand project)
        ]
        click



-- Decode


decodeListing : Decode.Decoder ProjectListing
decodeListing =
    let
        mk handle slug name =
            { handle = handle, slug = slug, name = name }
    in
    Decode.map3
        mk
        (field "owner" UserHandle.decodeUnprefixed)
        (field "name" Slug.decode)
        (field "name" string)


decodeListings : Decode.Decoder (List ProjectListing)
decodeListings =
    Decode.list decodeListing
