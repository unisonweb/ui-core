module UI.StatusBanner exposing (..)

import Html exposing (Html, div, label, text)
import Html.Attributes exposing (class)
import UI.StatusIndicator as StatusIndicator


type StatusBanner
    = Good String
    | Bad String
    | Info String
    | Working String


good : String -> Html msg
good text_ =
    view (Good text_)


bad : String -> Html msg
bad text_ =
    view (Bad text_)


info : String -> Html msg
info text_ =
    view (Info text_)


working : String -> Html msg
working text_ =
    view (Working text_)


view : StatusBanner -> Html msg
view banner =
    let
        ( className, indicator, text_ ) =
            case banner of
                Good t ->
                    ( "good", StatusIndicator.good, t )

                Bad t ->
                    ( "bad", StatusIndicator.bad, t )

                Info t ->
                    ( "info", StatusIndicator.info, t )

                Working t ->
                    ( "working", StatusIndicator.working, t )
    in
    div [ class ("status-banner status-banner_" ++ className) ]
        [ indicator
        , label [] [ text text_ ]
        ]
