module UI.ErrorCard exposing (..)

import Html exposing (Html, div, h3, p, text)
import Html.Attributes exposing (class)
import Maybe.Extra as MaybeE
import UI
import UI.Button as Button exposing (Button)
import UI.Card as Card exposing (Card)


type alias ErrorCard msg =
    { text : String
    , action : Maybe (Button msg)
    }



-- CREATE


empty : ErrorCard msg
empty =
    { text = "", action = Nothing }


errorCard : String -> ErrorCard msg
errorCard txt =
    { text = txt, action = Nothing }


errorCard_ : String -> Button msg -> ErrorCard msg
errorCard_ txt action =
    { text = txt, action = Just action }



-- MODIFY


withText : String -> ErrorCard msg -> ErrorCard msg
withText txt errCard =
    { errCard | text = txt }


withDefaultText : ErrorCard msg -> ErrorCard msg
withDefaultText errCard =
    { errCard | text = "We're terribly sorry, but something unexpected happened with this page and we couldn't display it." }


withAction : Button msg -> ErrorCard msg -> ErrorCard msg
withAction action errCard =
    { errCard | action = Just action }



-- TRANSFORM


toCard : ErrorCard msg -> Card msg
toCard errCard =
    Card.card
        [ div [ class "error-card" ]
            [ h3 []
                [ text "😞 Oh no!" ]
            , p
                []
                [ text errCard.text ]
            , MaybeE.unwrap UI.nothing Button.view errCard.action
            ]
        ]



-- VIEW


view : ErrorCard msg -> Html msg
view =
    toCard >> Card.view
