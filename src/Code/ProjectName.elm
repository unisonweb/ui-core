module Code.ProjectName exposing (..)

import Code.Hash as Hash
import Code.Hashvatar as Hashvatar
import Code.ProjectSlug as ProjectSlug exposing (ProjectSlug)
import Html exposing (Html, span, text)
import Html.Attributes exposing (class, title)
import Json.Decode as Decode
import Lib.Decode.Helpers exposing (failInvalid)
import Lib.UserHandle as UserHandle exposing (UserHandle)
import UI
import UI.Click as Click exposing (Click)


type ProjectName
    = ProjectName (Maybe UserHandle) ProjectSlug



-- CREATE


projectName : Maybe UserHandle -> ProjectSlug -> ProjectName
projectName =
    ProjectName


{-| ProjectNames can include a handle when being parsed.

valid examples are:

  - "myproject", "myBranch", "mybr4nch"
  - "my-project", "my\_branch", "-my---branch", "\_my-branch"
    (for some reason elm-format wont allow having underscores without a backslash infront)
  - "@owner/my-project"

invalid examples

  - "my/project"
  - "my@project"
  - "@owner/my/project"
  - "@owner@my/project"
  - "@owner@my/project"
  - "my project"
  - "mybr%@#nch"

-}
fromString : String -> Maybe ProjectName
fromString raw =
    let
        parts =
            String.split "/" raw
    in
    case parts of
        [ h, s ] ->
            Maybe.map2
                (\h_ s_ -> ProjectName (Just h_) s_)
                (UserHandle.fromString h)
                (ProjectSlug.fromString s)

        [ s ] ->
            Maybe.map (ProjectName Nothing) (ProjectSlug.fromString s)

        _ ->
            Nothing


{-| !!! Don't use outside of of testing
-}
unsafeFromString : String -> ProjectName
unsafeFromString raw =
    let
        parts =
            String.split "/" raw
    in
    case parts of
        [ h, s ] ->
            ProjectName (h |> UserHandle.unsafeFromString |> Just) (ProjectSlug.unsafeFromString s)

        [ s ] ->
            ProjectName Nothing (ProjectSlug.unsafeFromString s)

        _ ->
            ProjectName Nothing (ProjectSlug.unsafeFromString raw)



-- HELPERS


slug : ProjectName -> ProjectSlug
slug (ProjectName _ slug_) =
    slug_


handle : ProjectName -> Maybe UserHandle
handle (ProjectName handle_ _) =
    handle_


equals : ProjectName -> ProjectName -> Bool
equals (ProjectName handleA slugA) (ProjectName handleB slugB) =
    case ( handleA, handleB ) of
        ( Just ha, Just hb ) ->
            UserHandle.equals ha hb && ProjectSlug.equals slugA slugB

        ( Nothing, Nothing ) ->
            -- if there are no handles, we only care about ProjectSlug equality
            ProjectSlug.equals slugA slugB

        _ ->
            False


toString : ProjectName -> String
toString (ProjectName handle_ slug_) =
    let
        handle__ =
            case handle_ of
                Just h ->
                    UserHandle.toString h ++ "/"

                Nothing ->
                    ""
    in
    handle__ ++ ProjectSlug.toString slug_


toApiString : ProjectName -> String
toApiString (ProjectName handle_ slug_) =
    let
        handle__ =
            case handle_ of
                Just h ->
                    UserHandle.toString h ++ "%2F"

                Nothing ->
                    ""
    in
    handle__ ++ ProjectSlug.toString slug_



-- VIEW


viewHashvatar : ProjectName -> Html msg
viewHashvatar ref =
    let
        hash =
            Hash.unsafeFromString (toString ref)
    in
    Hashvatar.view hash


view : ProjectName -> Html msg
view projectName_ =
    view_ Nothing Nothing projectName_


viewClickable : (UserHandle -> Click msg) -> (ProjectSlug -> Click msg) -> ProjectName -> Html msg
viewClickable handleClick slugClick projectName_ =
    view_ (Just handleClick) (Just slugClick) projectName_


view_ : Maybe (UserHandle -> Click msg) -> Maybe (ProjectSlug -> Click msg) -> ProjectName -> Html msg
view_ handleClick slugClick ((ProjectName handle_ slug_) as projectName_) =
    let
        handle__ =
            case ( handleClick, handle_ ) of
                ( Just c, Just h ) ->
                    Click.view [ class "project-name_handle" ] [ text (UserHandle.toString h) ] (c h)

                ( Nothing, Just h ) ->
                    span [ class "project-name_handle" ] [ text (UserHandle.toString h) ]

                _ ->
                    UI.nothing

        slug__ =
            case slugClick of
                Just c ->
                    Click.view [ class "project-name_slug" ] [ text (ProjectSlug.toString slug_) ] (c (slug projectName_))

                Nothing ->
                    span [ class "project-name_slug" ] [ text (ProjectSlug.toString slug_) ]
    in
    span [ class "project-name", title (toString projectName_) ]
        [ handle__
        , span [ class "project-name_separator" ] [ text "/" ]
        , slug__
        ]



-- DECODE


decode : Decode.Decoder ProjectName
decode =
    Decode.map fromString Decode.string
        |> Decode.andThen (failInvalid "Invalid ProjectName")
