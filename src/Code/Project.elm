module Code.Project exposing (..)

import Code.Project.ProjectShorthand as ProjectShorthand exposing (ProjectShorthand)
import Code.Project.ProjectSlug exposing (ProjectSlug)
import Json.Decode as Decode exposing (int, nullable, string)
import Json.Decode.Extra as DecodeE exposing (when)
import Json.Decode.Pipeline exposing (optional, required)
import Lib.UserHandle exposing (UserHandle)
import Set exposing (Set)


type alias Project a =
    { a | shorthand : ProjectShorthand }


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
        , numProjectDependents : Int
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



-- DECODE


decodeVisibility : Decode.Decoder ProjectVisibility
decodeVisibility =
    Decode.oneOf
        [ when Decode.string ((==) "public") (Decode.succeed Public)
        , when Decode.string ((==) "private") (Decode.succeed Private)
        ]


decodeDetails : ProjectShorthand -> Decode.Decoder ProjectDetails
decodeDetails shorthand_ =
    let
        projectDetails summary tags visibility numFavs numWeeklyDownloads numProjectDependents =
            { shorthand = shorthand_
            , summary = summary
            , tags = Set.fromList tags
            , visibility = visibility
            , numFavs = numFavs
            , numWeeklyDownloads = numWeeklyDownloads
            , numProjectDependents = numProjectDependents
            }
    in
    Decode.succeed projectDetails
        |> required "summary" (nullable string)
        |> required "tags" (Decode.list string)
        |> required "visibility" decodeVisibility
        |> optional "numFavs" int 0
        |> optional "numWeeklyDownloads" int 0
        |> optional "numProjectDependents" int 0
