module UI.Card exposing (..)

import Html exposing (Html, div, h3, text)
import Html.Attributes exposing (class)
import Maybe.Extra as MaybeE


type CardType
    = Contained
    | ContainedWithFade
    | Uncontained


type alias Card msg =
    { type_ : CardType
    , className : Maybe String
    , title : Maybe String
    , items : List (Html msg)
    }



-- CREATE


card : List (Html msg) -> Card msg
card items =
    { type_ = Uncontained, className = Nothing, title = Nothing, items = items }


titled : String -> List (Html msg) -> Card msg
titled title items =
    { type_ = Uncontained, className = Nothing, title = Just title, items = items }



-- MODIFY


withType : CardType -> Card msg -> Card msg
withType type_ card_ =
    { card_ | type_ = type_ }


withClassName : String -> Card msg -> Card msg
withClassName className card_ =
    { card_ | className = Just className }


asContained : Card msg -> Card msg
asContained card_ =
    { card_ | type_ = Contained }


asContainedWithFade : Card msg -> Card msg
asContainedWithFade card_ =
    { card_ | type_ = ContainedWithFade }


withTitle : String -> Card msg -> Card msg
withTitle title card_ =
    { card_ | title = Just title }


withItems : List (Html msg) -> Card msg -> Card msg
withItems items card_ =
    { card_ | items = items }


withItem : Html msg -> Card msg -> Card msg
withItem item card_ =
    { card_ | items = card_.items ++ [ item ] }



-- MAP


map : (a -> msg) -> Card a -> Card msg
map toMsg cardA =
    { type_ = cardA.type_
    , className = cardA.className
    , title = cardA.title
    , items = List.map (Html.map toMsg) cardA.items
    }



-- VIEW


view : Card msg -> Html msg
view card_ =
    let
        className_ =
            MaybeE.unwrap [] (\c -> [ class c ]) card_.className

        items =
            case card_.title of
                Just t ->
                    h3 [ class "card-title" ] [ text t ] :: card_.items

                Nothing ->
                    card_.items

        typeClass =
            case card_.type_ of
                Contained ->
                    "contained"

                ContainedWithFade ->
                    "contained-with-fade"

                Uncontained ->
                    "uncontained"
    in
    div ([ class "card", class typeClass ] ++ className_) items
