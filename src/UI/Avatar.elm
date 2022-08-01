module UI.Avatar exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (alt, class, style)
import Maybe.Extra as MaybeE
import UI
import UI.Icon as Icon exposing (Icon)
import Url exposing (Url)


type AvatarSize
    = Small
    | Medium
    | Large
    | Huge


type alias Avatar msg =
    { url : Maybe Url
    , text : Maybe String
    , fallbackIcon : Maybe (Icon msg)
    , size : AvatarSize
    }



-- CREATE


empty : Avatar msg
empty =
    { url = Nothing, text = Nothing, fallbackIcon = Nothing, size = Medium }


avatar : Maybe Url -> Maybe String -> Avatar msg
avatar url text =
    avatar_ url text (Just Icon.user)


avatar_ : Maybe Url -> Maybe String -> Maybe (Icon msg) -> Avatar msg
avatar_ url text fallbackIcon =
    { url = url, text = text, fallbackIcon = fallbackIcon, size = Medium }



-- MODIFY


withUrl : Url -> Avatar msg -> Avatar msg
withUrl url avatar__ =
    { avatar__ | url = Just url }


withText : String -> Avatar msg -> Avatar msg
withText text avatar__ =
    { avatar__ | text = Just text }


withIcon : Icon msg -> Avatar msg -> Avatar msg
withIcon fallbackIcon avatar__ =
    { avatar__ | fallbackIcon = Just fallbackIcon }


withSize : AvatarSize -> Avatar msg -> Avatar msg
withSize size avatar__ =
    { avatar__ | size = size }


small : Avatar msg -> Avatar msg
small avatar__ =
    withSize Small avatar__


medium : Avatar msg -> Avatar msg
medium avatar__ =
    withSize Medium avatar__


large : Avatar msg -> Avatar msg
large avatar__ =
    withSize Large avatar__


huge : Avatar msg -> Avatar msg
huge avatar__ =
    withSize Huge avatar__



-- VIEW


view : Avatar msg -> Html msg
view { url, text, size, fallbackIcon } =
    let
        sizeClass =
            case size of
                Small ->
                    "small"

                Medium ->
                    "medium"

                Large ->
                    "large"

                Huge ->
                    "huge"
    in
    case ( url, text ) of
        ( Nothing, Just n ) ->
            div
                [ class "avatar avatar_text"
                , class sizeClass
                ]
                [ Html.text (String.left 1 n) ]

        ( Just a, _ ) ->
            div
                [ class "avatar avatar_image"
                , class sizeClass
                , style "background-image" ("url(" ++ Url.toString a ++ ")")
                , alt "Avatar"
                ]
                []

        _ ->
            div
                [ class "avatar avatar_blank-icon"
                , class sizeClass
                , alt "Avatar"
                ]
                [ MaybeE.unwrap UI.nothing Icon.view fallbackIcon ]
