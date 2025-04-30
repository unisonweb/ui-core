{-

   UrlParsers
   =============

   Various parsing helpers to grab structured data like FQNs and Hashes out of
   routes
-}


module Code.UrlParsers exposing (..)

import Code.BranchRef as BranchRef exposing (BranchRef, BranchSlug)
import Code.Definition.Reference exposing (Reference(..))
import Code.FullyQualifiedName as FQN exposing (FQN)
import Code.Hash as Hash exposing (Hash)
import Code.HashQualified exposing (HashQualified(..))
import Code.Perspective exposing (PerspectiveParams(..), RootPerspective(..))
import Code.ProjectSlug as ProjectSlug exposing (ProjectSlug)
import Code.Version as Version exposing (Version)
import Lib.UserHandle as UserHandle exposing (UserHandle)
import Parser exposing ((|.), (|=), Parser, backtrackable, keyword, succeed)



-- Parsers --------------------------------------------------------------------


{-| FQN example url segments: "base/List/map"
-}
fqn : Parser FQN
fqn =
    let
        segment =
            Parser.oneOf
                -- Special case ;. which is an escaped . (dot), since we also use
                -- ';' as the separator character between namespace FQNs and
                -- definition FQNs. (';' is not a valid character in FQNs and is
                -- safe as a separator/escape character).
                [ b (succeed "." |. s ";.")
                , b chompSegment
                ]

        chompSegment =
            Parser.getChompedString <|
                Parser.succeed ()
                    |. Parser.chompWhile FQN.isValidUrlSegmentChar
    in
    Parser.map FQN.fromUrlList
        (Parser.sequence
            { start = ""
            , separator = "/"
            , end = ""
            , spaces = Parser.spaces
            , item = segment
            , trailing = Parser.Forbidden
            }
        )


fqnEnd : Parser ()
fqnEnd =
    Parser.symbol ";"


userHandle_ : (String -> Maybe UserHandle) -> Parser UserHandle
userHandle_ fromString =
    let
        parseMaybe mhandle =
            case mhandle of
                Just u ->
                    Parser.succeed u

                Nothing ->
                    Parser.problem "Invalid handle"
    in
    Parser.chompUntilEndOr "/"
        |> Parser.getChompedString
        |> Parser.map fromString
        |> Parser.andThen parseMaybe


userHandle : Parser UserHandle
userHandle =
    userHandle_ UserHandle.fromString


unprefixedUserHandle : Parser UserHandle
unprefixedUserHandle =
    userHandle_ UserHandle.fromUnprefixedString


version : Parser Version
version =
    let
        parseMaybe mversion =
            case mversion of
                Just s_ ->
                    Parser.succeed s_

                Nothing ->
                    Parser.problem "Invalid Version"
    in
    Parser.chompUntilEndOr "/"
        |> Parser.getChompedString
        |> Parser.map Version.fromUrlString
        |> Parser.andThen parseMaybe


branchRef : Parser BranchRef
branchRef =
    Parser.oneOf
        [ b (succeed BranchRef.releaseDraftBranchRef |. s "releases" |. slash |. s "drafts" |. slash |= version)
        , b (succeed BranchRef.releaseBranchRef |. s "releases" |. slash |= version)
        , b (succeed BranchRef.contributorBranchRef |= userHandle |. slash |= branchSlug)
        , b (succeed BranchRef.projectBranchRef |= branchSlug)
        ]


branchSlug : Parser BranchSlug
branchSlug =
    let
        parseMaybe mslug =
            case mslug of
                Just s_ ->
                    Parser.succeed s_

                Nothing ->
                    Parser.problem "Invalid Slug"
    in
    Parser.chompUntilEndOr "/"
        |> Parser.getChompedString
        |> Parser.map BranchRef.branchSlugFromString
        |> Parser.andThen parseMaybe


projectSlug : Parser ProjectSlug
projectSlug =
    let
        parseMaybe mslug =
            case mslug of
                Just s_ ->
                    Parser.succeed s_

                Nothing ->
                    Parser.problem "Invalid slug"
    in
    Parser.chompUntilEndOr "/"
        |> Parser.getChompedString
        |> Parser.map ProjectSlug.fromString
        |> Parser.andThen parseMaybe


{-| Hash example url segment: "@asd123".
contextual positioning in the url makes this different than a UserHandle
-}
hash : Parser Hash
hash =
    let
        handleMaybe mHash =
            case mHash of
                Just h ->
                    Parser.succeed h

                Nothing ->
                    Parser.problem "Invalid hash"
    in
    Parser.chompUntilEndOr "/"
        |> Parser.getChompedString
        |> Parser.map Hash.fromUrlString
        |> Parser.andThen handleMaybe


hq : Parser HashQualified
hq =
    Parser.oneOf
        [ b (succeed HashOnly |= hash)
        , b (succeed NameOnly |= fqn)
        ]


reference : Parser Reference
reference =
    Parser.oneOf
        [ b (succeed TermReference |. s "terms" |. slash |= hq)
        , b (succeed TypeReference |. s "types" |. slash |= hq)
        , b (succeed AbilityConstructorReference |. s "ability-constructors" |. slash |= hq)
        , b (succeed DataConstructorReference |. s "data-constructors" |. slash |= hq)
        ]


codebaseRef : Parser RootPerspective
codebaseRef =
    Parser.oneOf
        [ b (succeed Relative |. s "latest")
        , b (succeed Absolute |= hash)
        , b (succeed Relative)
        ]


perspectiveParams : Parser PerspectiveParams
perspectiveParams =
    Parser.oneOf
        [ b (succeed ByNamespace |= codebaseRef |. slash |. s "namespaces" |. slash |= fqn |. fqnEnd)
        , b (succeed ByNamespace |= codebaseRef |. slash |. s "namespaces" |. slash |= fqn)
        , b (succeed ByRoot |= codebaseRef)
        ]



-- Helpers --------------------------------------------------------------------


slash : Parser ()
slash =
    Parser.symbol "/"


{-| Support ending the route "bare": like `/foo`, or with a with a trailing
slash: `/foo/`.
-}
end : Parser ()
end =
    Parser.oneOf [ b slash |. Parser.end, b Parser.end ]


b : Parser a -> Parser a
b =
    backtrackable


s : String -> Parser ()
s =
    keyword
