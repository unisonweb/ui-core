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
        name_ =
            case name of
                Just n ->
                    span [ class "user-name" ] [ text n ]

                Nothing ->
                    UI.nothing

        avatar =
            { text = Maybe.map (String.left 1) name
            , url = avatarUrl
            , fallbackIcon = Just Icon.user
            }
    in
    div
        [ class "user-summary" ]
        [ Avatar.view avatar
        , name_
        , span [ class "user-handle" ] [ text (UserHandle.toString handle) ]
        ]
