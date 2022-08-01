module UI.ProfileSnippet exposing (..)

import Html exposing (Html, div, span, text)
import Html.Attributes exposing (class)
import Lib.UserHandle as UserHandle exposing (UserHandle)
import UI
import UI.Avatar as Avatar
import Url exposing (Url)


type Size
    = Small
    | Medium
    | Large


type alias User u =
    { u
        | handle : UserHandle
        , name : Maybe String
        , avatarUrl : Maybe Url
    }


type alias ProfileSnippet u =
    { user : User u
    , size : Size
    }



-- CREATE


profileSnippet : User u -> ProfileSnippet u
profileSnippet user =
    { user = user, size = Medium }



-- MODIFY


small : ProfileSnippet u -> ProfileSnippet u
small p =
    withSize Small p


medium : ProfileSnippet u -> ProfileSnippet u
medium p =
    withSize Medium p


large : ProfileSnippet u -> ProfileSnippet u
large p =
    withSize Large p


withSize : Size -> ProfileSnippet u -> ProfileSnippet u
withSize size p =
    { p | size = size }



-- VIEW


view : ProfileSnippet u -> Html msg
view { size, user } =
    let
        { avatarUrl, handle, name } =
            user

        avatar_ =
            Avatar.avatar avatarUrl (Maybe.map (String.left 1) name)

        ( sizeClass, avatar ) =
            case size of
                Small ->
                    ( class "small", avatar_ |> Avatar.small )

                Medium ->
                    ( class "medium", avatar_ |> Avatar.medium )

                Large ->
                    ( class "large", avatar_ |> Avatar.large )

        ( name_, attrs ) =
            case name of
                Just n ->
                    ( span [ class "profile-snippet_name" ] [ text n ], [ class "profile-snippet", sizeClass ] )

                Nothing ->
                    ( UI.nothing, [ class "profile-snippet profile-snippet_handle-only", sizeClass ] )

        profileText =
            case size of
                Small ->
                    [ name_ ]

                Medium ->
                    [ name_
                    , span [ class "profile-snippet_handle" ] [ text (UserHandle.toString handle) ]
                    ]

                Large ->
                    [ name_
                    , span [ class "profile-snippet_handle" ] [ text (UserHandle.toString handle) ]
                    ]
    in
    div
        attrs
        [ Avatar.view avatar
        , div [ class "profile-snippet_text" ] profileText
        ]
