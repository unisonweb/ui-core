module UI.Click exposing (..)

import Html exposing (Attribute, Html, a)
import Html.Attributes as Attrs exposing (class, rel, target)
import Html.Events as Events
import Html.Events.Extra exposing (onClickPreventDefault, onClickPreventDefaultAndStopPropagation, onClickStopPropagation)


type alias OnClickSettings =
    { stopPropagation : Bool, preventDefault : Bool }


type Click msg
    = ExternalHref String
    | Href String -- Internal route
    | OnClick msg OnClickSettings
    | Disabled


defaultOnClickSettings : OnClickSettings
defaultOnClickSettings =
    { stopPropagation = False, preventDefault = False }



-- CREATE


onClick : msg -> Click msg
onClick msg =
    OnClick msg defaultOnClickSettings


externalHref : String -> Click msg
externalHref href_ =
    ExternalHref href_


href : String -> Click msg
href href_ =
    Href href_


disabled : Click msg
disabled =
    Disabled



-- TRANSFORM


map : (a -> msg) -> Click a -> Click msg
map toMsg click_ =
    case click_ of
        ExternalHref href_ ->
            ExternalHref href_

        Href href_ ->
            Href href_

        OnClick a settings ->
            OnClick (toMsg a) settings

        Disabled ->
            Disabled



-- ALTER


stopPropagation : Click msg -> Click msg
stopPropagation click =
    case click of
        OnClick msg settings ->
            let
                newSettings =
                    { settings | stopPropagation = True }
            in
            OnClick msg newSettings

        _ ->
            click


preventDefault : Click msg -> Click msg
preventDefault click =
    case click of
        OnClick msg settings ->
            let
                newSettings =
                    { settings | preventDefault = True }
            in
            OnClick msg newSettings

        _ ->
            click


withOnClickSettings : OnClickSettings -> Click msg -> Click msg
withOnClickSettings settings click =
    case click of
        OnClick msg _ ->
            OnClick msg settings

        _ ->
            click



-- VIEW


attrs : Click msg -> List (Attribute msg)
attrs click =
    case click of
        ExternalHref href_ ->
            [ Attrs.href href_, rel "noopener", target "_blank" ]

        Href href_ ->
            [ Attrs.href href_ ]

        OnClick msg settings ->
            let
                click_ =
                    if settings.stopPropagation && settings.preventDefault then
                        onClickPreventDefaultAndStopPropagation

                    else if settings.stopPropagation then
                        onClickStopPropagation

                    else if settings.preventDefault then
                        onClickPreventDefault

                    else
                        Events.onClick
            in
            [ click_ msg ]

        Disabled ->
            [ class "disabled" ]


view : List (Attribute msg) -> List (Html msg) -> Click msg -> Html msg
view attrs_ content click =
    a (attrs_ ++ attrs click) content
