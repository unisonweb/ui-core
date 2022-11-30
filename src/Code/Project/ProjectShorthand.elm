module Code.Project.ProjectShorthand exposing
    ( ProjectShorthand
    , equals
    , fromString
    , handle
    , projectShorthand
    , slug
    , toString
    , toUrlPath
    , unsafeFromString
    , view
    )

import Html exposing (Html, label, span, text)
import Html.Attributes exposing (class)
import Lib.Slug as Slug exposing (Slug)
import Lib.UserHandle as UserHandle exposing (UserHandle)


type ProjectShorthand
    = ProjectShorthand { handle : UserHandle, slug : Slug }


fromString : String -> String -> Maybe ProjectShorthand
fromString rawHandle rawSlug =
    Maybe.map2 projectShorthand
        (UserHandle.fromString rawHandle)
        (Slug.fromString rawSlug)


{-| Don't use! It's meant for tests
-}
unsafeFromString : String -> String -> ProjectShorthand
unsafeFromString rawHandle rawSlug =
    projectShorthand
        (UserHandle.unsafeFromString rawHandle)
        (Slug.unsafeFromString rawSlug)


projectShorthand : UserHandle -> Slug -> ProjectShorthand
projectShorthand handle_ slug_ =
    ProjectShorthand { handle = handle_, slug = slug_ }


toString : ProjectShorthand -> String
toString (ProjectShorthand p) =
    UserHandle.toString p.handle ++ "/" ++ Slug.toString p.slug


toUrlPath : ProjectShorthand -> List String
toUrlPath (ProjectShorthand p) =
    [ UserHandle.toString p.handle, Slug.toString p.slug ]


handle : ProjectShorthand -> UserHandle
handle (ProjectShorthand p) =
    p.handle


slug : ProjectShorthand -> Slug
slug (ProjectShorthand p) =
    p.slug


equals : ProjectShorthand -> ProjectShorthand -> Bool
equals a b =
    toString a == toString b


view : ProjectShorthand -> Html msg
view (ProjectShorthand p) =
    label [ class "project-shorthand" ]
        [ span [ class "project-shorthand_handle" ] [ text (UserHandle.toString p.handle) ]
        , span [ class "project-shorthand_separator" ] [ text "/" ]
        , span [ class "project-shorthand_slug" ] [ text (Slug.toString p.slug) ]
        ]
