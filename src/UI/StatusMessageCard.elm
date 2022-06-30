module UI.StatusMessageCard exposing (..)

import Html exposing (Html, div, h2, text)
import Html.Attributes exposing (class)
import Maybe.Extra as MaybeE
import UI
import UI.Button as Button exposing (Button)
import UI.Card as Card
import UI.StatusIndicator as StatusIndicator exposing (StatusIndicator)


type alias StatusMessageCard msg =
    { status : StatusIndicator
    , title : String
    , body : List (Html msg)
    , cta : Maybe (Button msg)
    }


good : String -> List (Html msg) -> StatusMessageCard msg
good title body =
    { status = StatusIndicator.good
    , title = title
    , body = body
    , cta = Nothing
    }


bad : String -> List (Html msg) -> StatusMessageCard msg
bad title body =
    { status = StatusIndicator.bad
    , title = title
    , body = body
    , cta = Nothing
    }



-- MODIFY


withCta : Button msg -> StatusMessageCard msg -> StatusMessageCard msg
withCta cta statusMessageCard =
    { statusMessageCard | cta = Just cta }


view : StatusMessageCard msg -> Html msg
view { status, title, body, cta } =
    let
        content =
            [ div [ class "status-message-card" ]
                ([ status |> StatusIndicator.large |> StatusIndicator.view
                 , h2 [ class "status-message-card_title" ] [ text title ]
                 ]
                    ++ body
                    ++ [ MaybeE.unwrap UI.nothing Button.view cta ]
                )
            ]
    in
    Card.card content |> Card.view
