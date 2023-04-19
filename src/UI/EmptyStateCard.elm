module UI.EmptyStateCard exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import UI.Card as Card exposing (Card)
import UI.EmptyState as EmptyState exposing (EmptyState)



-- VIEW


asCard : EmptyState msg -> Card msg
asCard emptyState =
    Card.card
        [ div [ class "empty-state-card" ] [ EmptyState.view emptyState ]
        ]
        |> Card.asContainedWithFade


view : EmptyState msg -> Html msg
view =
    asCard >> Card.view
