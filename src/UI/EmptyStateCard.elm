module UI.EmptyStateCard exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import UI.Card as Card exposing (Card)


type alias EmptyStateCard msg =
    { centerPiece : Html msg
    , content : Html msg
    }



-- CREATE


emptyStateCard : Html msg -> Html msg -> EmptyStateCard msg
emptyStateCard centerPiece content =
    { centerPiece = centerPiece, content = content }



-- MAP


map : (msgA -> msgB) -> EmptyStateCard msgA -> EmptyStateCard msgB
map f esc =
    { centerPiece = Html.map f esc.centerPiece
    , content = Html.map f esc.content
    }



-- VIEW


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
