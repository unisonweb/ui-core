module UI.StatusIndicator exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import UI.Icon as Icon


type Indicator
    = Good
    | Bad
    | Info
    | Working


type Size
    = Regular
    | Large


type alias StatusIndicator =
    { indicator : Indicator
    , size : Size
    }



-- CREATE


good : StatusIndicator
good =
    { indicator = Good, size = Regular }


bad : StatusIndicator
bad =
    { indicator = Bad, size = Regular }


info : StatusIndicator
info =
    { indicator = Bad, size = Regular }


working : StatusIndicator
working =
    { indicator = Bad, size = Regular }



-- MODIFY


withSize : Size -> StatusIndicator -> StatusIndicator
withSize size statusIndicator =
    { statusIndicator | size = size }


large : StatusIndicator -> StatusIndicator
large statusIndicator =
    withSize Large statusIndicator


regular : StatusIndicator -> StatusIndicator
regular statusIndicator =
    withSize Regular statusIndicator



-- VIEW


view : StatusIndicator -> Html msg
view { indicator, size } =
    let
        ( className, content ) =
            case indicator of
                Good ->
                    ( "good", Icon.view Icon.checkmark )

                Bad ->
                    ( "bad", Icon.view Icon.warn )

                Info ->
                    ( "info", Icon.view Icon.bulb )

                Working ->
                    ( "working", Icon.view Icon.largeDot )

        sizeClassName =
            case size of
                Regular ->
                    "status-indicator_regular"

                Large ->
                    "status-indicator_large"
    in
    div [ class ("status-indicator status-indicator_" ++ className ++ " " ++ sizeClassName) ]
        [ content ]
