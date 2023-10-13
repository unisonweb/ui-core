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


asCard_ : Card.SurfaceBackgroundColor -> EmptyState msg -> Card msg
asCard_ surfaceBackground emptyState =
    Card.card
        [ div [ class "empty-state-card" ] [ EmptyState.view emptyState ]
        ]
        |> Card.asContainedWithFade_ surfaceBackground


view : EmptyState msg -> Html msg
view =
    asCard >> Card.view


view_ : Card.SurfaceBackgroundColor -> EmptyState msg -> Html msg
view_ surfaceBackground emptyState =
    emptyState |> asCard_ surfaceBackground |> Card.view
