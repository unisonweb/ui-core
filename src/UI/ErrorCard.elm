module UI.ErrorCard exposing (..)

import Html exposing (Html, div, h2, p, text)
import Html.Attributes exposing (class)
import Maybe.Extra as MaybeE
import UI
import UI.Button as Button exposing (Button)
import UI.Card as Card exposing (Card)


type alias ErrorCard msg =
    { title : Maybe String
    , text : Maybe String
    , action : Maybe (Button msg)
    }



-- CREATE


empty : ErrorCard msg
empty =
    { title = Nothing, text = Nothing, action = Nothing }


errorCard : String -> String -> ErrorCard msg
errorCard title txt =
    { title = Just title, text = Just txt, action = Nothing }


errorCard_ : String -> String -> Button msg -> ErrorCard msg
errorCard_ title txt action =
    { title = Just title, text = Just txt, action = Just action }



-- MODIFY


withText : String -> ErrorCard msg -> ErrorCard msg
withText txt errCard =
    { errCard | text = Just txt }


withTitle : String -> ErrorCard msg -> ErrorCard msg
withTitle title errCard =
    { errCard | title = Just title }


withAction : Button msg -> ErrorCard msg -> ErrorCard msg
withAction action errCard =
    { errCard | action = Just action }



-- TRANSFORM


toCard : ErrorCard msg -> Card msg
toCard errCard =
    let
        title =
            Maybe.withDefault "Oh no!" errCard.title

        txt =
            Maybe.withDefault "We're terribly sorry, but something unexpected happened with this page and we couldn't display it." errCard.text
    in
    Card.card
        [ div [ class "error-card" ]
            [ div [ class "emoji" ] [ text "😞" ]
            , h2 [] [ text title ]
            , p [] [ text txt ]
            , MaybeE.unwrap UI.nothing Button.view errCard.action
            ]
        ]



-- VIEW


view : ErrorCard msg -> Html msg
view =
    toCard >> Card.view
