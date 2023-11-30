module UI.StatusBanner exposing (..)

import Html exposing (Html, div, p, text)
import Html.Attributes exposing (class)
import UI.StatusIndicator as StatusIndicator


type StatusBanner msg
    = Good (Html msg)
    | Bad (Html msg)
    | Info (Html msg)
    | Working (Html msg)


good : String -> Html msg
good text_ =
    good_ (multilined text_)


good_ : Html msg -> Html msg
good_ content =
    view (Good content)


bad : String -> Html msg
bad text_ =
    bad_ (multilined text_)


bad_ : Html msg -> Html msg
bad_ content =
    view (Bad content)


info : String -> Html msg
info text_ =
    info_ (multilined text_)


info_ : Html msg -> Html msg
info_ content =
    view (Info content)


working : String -> Html msg
working text_ =
    working_ (multilined text_)


working_ : Html msg -> Html msg
working_ content =
    view (Working content)


multilined : String -> Html msg
multilined text_ =
    text_
        |> String.split "\n"
        |> List.map (\t -> p [] [ text t ])
        |> div []


view : StatusBanner msg -> Html msg
view banner =
    let
        ( className, indicator, content ) =
            case banner of
                Good c ->
                    ( "good", StatusIndicator.good, c )

                Bad c ->
                    ( "bad", StatusIndicator.bad, c )

                Info c ->
                    ( "info", StatusIndicator.info, c )

                Working c ->
                    ( "working", StatusIndicator.working, c )
    in
    div [ class ("status-banner status-banner_" ++ className) ]
        [ indicator |> StatusIndicator.view
        , div [ class "status-banner_content" ] [ content ]
        ]
