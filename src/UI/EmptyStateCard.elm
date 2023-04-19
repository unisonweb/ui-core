module UI.EmptyStateCard exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import UI.Card as Card exposing (Card)


type alias EmptyStateCard msg =
    { centerPiece : Html msg
    , content : Html msg
    }


asCard : EmptyStateCard msg -> Card msg
asCard { centerPiece, content } =
    Card.card
        [ div [ class "empty-state-card" ]
            [ div [ class "empty-state-card_icons" ]
                [ centerPiece ]
            , div
                [ class "empty-state-card_content" ]
                [ content ]
            ]
        ]
        |> Card.asContainedWithFade


view : EmptyStateCard msg -> Html msg
view =
    asCard >> Card.view
