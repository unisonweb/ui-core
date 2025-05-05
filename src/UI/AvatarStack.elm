module UI.AvatarStack exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import UI.Avatar as Avatar exposing (Avatar)


view : List (Avatar msg) -> Html msg
view avatars =
    div [ class "avatar-stack" ] (List.map Avatar.view avatars)
