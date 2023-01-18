module Code.Project.ProjectShorthand exposing
    ( ProjectShorthand
    , equals
    , fromString
    , handle
    , projectShorthand
    , slug
    , toApiStringParts
    , toParts
    , toString
    , toStringParts
    , toUrlPath
    , unsafeFromString
    , view
    )

import Code.Hash as Hash
import Code.Hashvatar as Hashvatar
import Code.Project.ProjectSlug as ProjectSlug exposing (ProjectSlug)
import Html exposing (Html, label, span, text)
import Html.Attributes exposing (class)
import Lib.UserHandle as UserHandle exposing (UserHandle)


type ProjectShorthand
    = ProjectShorthand { handle : UserHandle, slug : ProjectSlug }


fromString : String -> String -> Maybe ProjectShorthand
fromString rawHandle rawSlug =
    Maybe.map2 projectShorthand
        (UserHandle.fromString rawHandle)
        (ProjectSlug.fromString rawSlug)


{-| Don't use! It's meant for tests
-}
unsafeFromString : String -> String -> ProjectShorthand
unsafeFromString rawHandle rawSlug =
    projectShorthand
        (UserHandle.unsafeFromString rawHandle)
        (ProjectSlug.unsafeFromString rawSlug)


projectShorthand : UserHandle -> ProjectSlug -> ProjectShorthand
projectShorthand handle_ slug_ =
    ProjectShorthand { handle = handle_, slug = slug_ }


toString : ProjectShorthand -> String
toString (ProjectShorthand p) =
    UserHandle.toString p.handle ++ "/" ++ ProjectSlug.toString p.slug


toUrlPath : ProjectShorthand -> List String
toUrlPath (ProjectShorthand p) =
    [ UserHandle.toString p.handle, ProjectSlug.toString p.slug ]


handle : ProjectShorthand -> UserHandle
handle (ProjectShorthand p) =
    p.handle


slug : ProjectShorthand -> ProjectSlug
slug (ProjectShorthand p) =
    p.slug


toParts : ProjectShorthand -> ( UserHandle, ProjectSlug )
toParts (ProjectShorthand p) =
    ( p.handle, p.slug )


toStringParts : ProjectShorthand -> ( String, String )
toStringParts (ProjectShorthand p) =
    ( UserHandle.toString p.handle, ProjectSlug.toString p.slug )


toApiStringParts : ProjectShorthand -> ( String, String )
toApiStringParts (ProjectShorthand p) =
    ( UserHandle.toUnprefixedString p.handle, ProjectSlug.toString p.slug )


equals : ProjectShorthand -> ProjectShorthand -> Bool
equals a b =
    toString a == toString b


viewHashvatar : ProjectShorthand -> Html msg
viewHashvatar shorthand =
    let
        hash =
            Hash.unsafeFromString (toString shorthand)
    in
    Hashvatar.view hash


view : ProjectShorthand -> Html msg
view (ProjectShorthand p) =
    label [ class "project-shorthand" ]
        [ span [ class "project-shorthand_handle" ] [ text (UserHandle.toString p.handle) ]
        , span [ class "project-shorthand_separator" ] [ text "/" ]
        , span [ class "project-shorthand_slug" ] [ text (ProjectSlug.toString p.slug) ]
        ]
