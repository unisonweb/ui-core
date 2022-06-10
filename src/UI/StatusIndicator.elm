module UI.StatusIndicator exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import UI.Icon as Icon


type StatusIndicator
    = Good
    | Bad
    | Info
    | Working


good : Html msg
good =
    view Good


bad : Html msg
bad =
    view Bad


info : Html msg
info =
    view Info


working : Html msg
working =
    view Working


view : StatusIndicator -> Html msg
view indicator =
    let
        ( className, content ) =
            case indicator of
                Good ->
                    ( "good", Icon.view Icon.checkmark )

                Bad ->
                    ( "working", Icon.view Icon.warn )

                Info ->
                    ( "working", Icon.view Icon.bulb )

                Working ->
                    ( "working", Icon.view Icon.largeDot )
    in
    div [ class ("status-indicator status-indicator_" ++ className) ] [ content ]
