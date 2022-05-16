module UI.UserSummary exposing (..)

import Html exposing (Html, div, span, text)
import Html.Attributes exposing (class)
import Lib.UserHandle as UserHandle exposing (UserHandle)
import UI
import UI.Avatar as Avatar
import UI.Icon as Icon
import Url exposing (Url)


type alias UserSummary u =
    { u
        | handle : UserHandle
        , name : Maybe String
        , avatarUrl : Maybe Url
    }


view : UserSummary u -> Html msg
view { avatarUrl, handle, name } =
    let
        ( name_, attrs ) =
            case name of
                Just n ->
                    ( span [ class "user-summary_name" ] [ text n ], [ class "user-summary" ] )

                Nothing ->
                    ( UI.nothing, [ class "user-summary user-summary_handle-only" ] )

        avatar =
            { text = Maybe.map (String.left 1) name
            , url = avatarUrl
            , fallbackIcon = Just Icon.user
            }
    in
    div
        attrs
        [ Avatar.view avatar
        , name_
        , span [ class "user-summary_handle" ] [ text (UserHandle.toString handle) ]
        ]
