module UI.ProfileSnippet exposing (..)

import Html exposing (Html, div, span, text)
import Html.Attributes exposing (class)
import Lib.UserHandle as UserHandle exposing (UserHandle)
import UI
import UI.Avatar as Avatar
import UI.PlaceholderShape as PlaceholderShape
import Url exposing (Url)


type Size
    = Small
    | Medium
    | Large
    | Huge


type alias User u =
    { u
        | handle : UserHandle
        , name : Maybe String
        , avatarUrl : Maybe Url
    }


type Profile u
    = Loading
    | ProfileUser (User u)


type alias ProfileSnippet u =
    { profile : Profile u
    , size : Size
    }



-- CREATE


profileSnippet : User u -> ProfileSnippet u
profileSnippet user =
    { profile = ProfileUser user, size = Medium }


loading : ProfileSnippet u
loading =
    { profile = Loading, size = Medium }



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


huge : ProfileSnippet u -> ProfileSnippet u
huge p =
    withSize Huge p


withSize : Size -> ProfileSnippet u -> ProfileSnippet u
withSize size p =
    { p | size = size }



-- VIEW


view : ProfileSnippet u -> Html msg
view { size, profile } =
    let
        cfg =
            case profile of
                Loading ->
                    { avatar = Avatar.empty
                    , name = PlaceholderShape.text |> PlaceholderShape.view
                    , handle = PlaceholderShape.text |> PlaceholderShape.small |> PlaceholderShape.view
                    , attrs = [ class "profile-snippet" ]
                    }

                ProfileUser user ->
                    let
                        cfg_ n class_ =
                            { avatar = Avatar.avatar user.avatarUrl (Maybe.map (String.left 1) user.name)
                            , name = n
                            , handle = span [ class "profile-snippet_handle" ] [ text (UserHandle.toString user.handle) ]
                            , attrs = [ class class_ ]
                            }
                    in
                    case user.name of
                        Just n ->
                            cfg_ (span [ class "profile-snippet_name" ] [ text n ]) "profile-snippet"

                        Nothing ->
                            cfg_ UI.nothing "profile-snippet profile-snippet_handle-only"

        ( attrs, avatar, profileText ) =
            case size of
                Small ->
                    ( class "profile-snippet_size_small" :: cfg.attrs, cfg.avatar |> Avatar.small, [ cfg.name ] )

                Medium ->
                    ( class "profile-snippet_size_medium" :: cfg.attrs, cfg.avatar |> Avatar.medium, [ cfg.name, cfg.handle ] )

                Large ->
                    ( class "profile-snippet_size_large" :: cfg.attrs, cfg.avatar |> Avatar.large, [ cfg.name, cfg.handle ] )

                Huge ->
                    ( class "profile-snippet_size_huge" :: cfg.attrs, cfg.avatar |> Avatar.huge, [ cfg.name, cfg.handle ] )
    in
    div
        attrs
        [ Avatar.view avatar
        , div [ class "profile-snippet_text" ] profileText
        ]
