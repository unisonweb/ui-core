module Code.Project exposing (..)

import Code.Project.ProjectShorthand as ProjectShorthand exposing (ProjectShorthand)
import Code.Project.ProjectSlug as ProjectSlug exposing (ProjectSlug)
import Json.Decode as Decode exposing (bool, int, nullable, string)
import Json.Decode.Extra exposing (when)
import Json.Decode.Pipeline exposing (optional, required, requiredAt)
import Lib.UserHandle as UserHandle exposing (UserHandle)
import Set exposing (Set)


type alias Project a =
    { a | shorthand : ProjectShorthand }


type IsFaved
    = Unknown
    | Faved
    | NotFaved
    | JustFaved


type ProjectVisibility
    = Public
    | Private


type alias ProjectDetails =
    Project
        { summary : Maybe String
        , tags : Set String
        , visibility : ProjectVisibility
        , numFavs : Int
        , numWeeklyDownloads : Int
        , isFaved : IsFaved
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


isOwnedBy : UserHandle -> Project a -> Bool
isOwnedBy handle_ project =
    UserHandle.equals handle_ (handle project)


toggleFav : ProjectDetails -> ProjectDetails
toggleFav ({ numFavs } as project) =
    let
        ( isFaved_, numFavs_ ) =
            case project.isFaved of
                Faved ->
                    ( NotFaved, numFavs - 1 )

                JustFaved ->
                    ( NotFaved, numFavs - 1 )

                NotFaved ->
                    ( JustFaved, numFavs + 1 )

                Unknown ->
                    ( Unknown, numFavs )
    in
    { project | isFaved = isFaved_, numFavs = numFavs_ }


isFaved : ProjectDetails -> Bool
isFaved p =
    isFavedToBool p.isFaved


isFavedToBool : IsFaved -> Bool
isFavedToBool isFaved_ =
    isFaved_ == Faved || isFaved_ == JustFaved


isFavedFromBool : Bool -> IsFaved
isFavedFromBool b =
    if b then
        Faved

    else
        NotFaved


visibilityToString : ProjectVisibility -> String
visibilityToString pv =
    case pv of
        Public ->
            "public"

        Private ->
            "private"



-- DECODE


decodeVisibility : Decode.Decoder ProjectVisibility
decodeVisibility =
    Decode.oneOf
        [ when Decode.string ((==) "public") (Decode.succeed Public)
        , when Decode.string ((==) "private") (Decode.succeed Private)
        ]


decodeDetails : Decode.Decoder ProjectDetails
decodeDetails =
    let
        makeProjectDetails handle_ slug_ summary tags visibility numFavs numWeeklyDownloads isFaved_ =
            let
                shorthand_ =
                    ProjectShorthand.projectShorthand handle_ slug_
            in
            { shorthand = shorthand_
            , summary = summary
            , tags = Set.fromList tags
            , visibility = visibility
            , numFavs = numFavs
            , numWeeklyDownloads = numWeeklyDownloads
            , isFaved = isFaved_
            }

        decodeIsFaved : Decode.Decoder IsFaved
        decodeIsFaved =
            Decode.map isFavedFromBool bool
    in
    Decode.succeed makeProjectDetails
        |> requiredAt [ "owner", "handle" ] UserHandle.decodeUnprefixed
        |> required "slug" ProjectSlug.decode
        |> required "summary" (nullable string)
        |> required "tags" (Decode.list string)
        |> required "visibility" decodeVisibility
        |> optional "numFavs" int 0
        |> optional "numWeeklyDownloads" int 0
        |> optional "isFaved" decodeIsFaved Unknown
