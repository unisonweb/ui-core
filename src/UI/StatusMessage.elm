module UI.StatusMessage exposing (..)

import Html exposing (Html, div, h2, text)
import Html.Attributes exposing (class)
import Maybe.Extra as MaybeE
import UI
import UI.Button as Button exposing (Button)
import UI.Card as Card exposing (Card)
import UI.StatusIndicator as StatusIndicator exposing (StatusIndicator)


type alias StatusMessage msg =
    { status : StatusIndicator
    , title : String
    , body : List (Html msg)
    , cta : Maybe (Button msg)
    }


good : String -> List (Html msg) -> StatusMessage msg
good title body =
    { status = StatusIndicator.good
    , title = title
    , body = body
    , cta = Nothing
    }


bad : String -> List (Html msg) -> StatusMessage msg
bad title body =
    { status = StatusIndicator.bad
    , title = title
    , body = body
    , cta = Nothing
    }



-- MODIFY


withCta : Button msg -> StatusMessage msg -> StatusMessage msg
withCta cta statusMessage =
    { statusMessage | cta = Just cta }


view : StatusMessage msg -> Html msg
view { status, title, body, cta } =
    div [ class "status-message" ]
        ([ status |> StatusIndicator.large |> StatusIndicator.view
         , h2 [ class "status-message_title" ] [ text title ]
         ]
            ++ body
            ++ [ MaybeE.unwrap UI.nothing Button.view cta ]
        )


asCard : StatusMessage msg -> Card msg
asCard statusMessage =
    Card.card [ view statusMessage ]
