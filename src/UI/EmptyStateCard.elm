module UI.EmptyStateCard exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import UI.Card as Card exposing (Card)


type CenterPiece msg
    = CircleCenterPiece (Html msg)
    | CustomCenterPiece (Html msg)


type alias EmptyStateCard msg =
    { centerPiece : CenterPiece msg
    , content : Html msg
    }



-- CREATE


emptyStateCard : CenterPiece msg -> Html msg -> EmptyStateCard msg
emptyStateCard centerPiece content =
    { centerPiece = centerPiece, content = content }



-- MAP


mapCenterPiece : (msgA -> msgB) -> CenterPiece msgA -> CenterPiece msgB
mapCenterPiece f cp =
    case cp of
        CircleCenterPiece h ->
            CircleCenterPiece (Html.map f h)

        CustomCenterPiece h ->
            CustomCenterPiece (Html.map f h)


map : (msgA -> msgB) -> EmptyStateCard msgA -> EmptyStateCard msgB
map f esc =
    { centerPiece = mapCenterPiece f esc.centerPiece
    , content = Html.map f esc.content
    }



-- VIEW


viewCenterPiece : CenterPiece msg -> Html msg
viewCenterPiece cp =
    case cp of
        CircleCenterPiece h ->
            div [ class "center-piece center-piece_circle" ] [ h ]

        CustomCenterPiece h ->
            div [ class "center-piece center-piece_custom" ] [ h ]


asCard : EmptyStateCard msg -> Card msg
asCard { centerPiece, content } =
    Card.card
        [ div [ class "empty-state-card" ]
            [ div [ class "empty-state-card_icons" ]
                [ viewCenterPiece centerPiece ]
            , div
                [ class "empty-state-card_content" ]
                [ content ]
            ]
        ]
        |> Card.asContainedWithFade


view : EmptyStateCard msg -> Html msg
view =
    asCard >> Card.view
