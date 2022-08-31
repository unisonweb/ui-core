module Code.Project.ProjectShorthand exposing (..)

import Html exposing (Html, label, span, text)
import Html.Attributes exposing (class)
import Lib.Slug as Slug exposing (Slug)
import Lib.UserHandle as UserHandle exposing (UserHandle)


type ProjectShorthand
    = ProjectShorthand { handle : UserHandle, slug : Slug }


projectShorthand : UserHandle -> Slug -> ProjectShorthand
projectShorthand handle_ slug_ =
    ProjectShorthand { handle = handle_, slug = slug_ }


toString : ProjectShorthand -> String
toString (ProjectShorthand p) =
    UserHandle.toString p.handle ++ "/" ++ Slug.toString p.slug


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