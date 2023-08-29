module UI.Card exposing (..)

import Html exposing (Html, div, h3, text)
import Html.Attributes exposing (class)


type SurfaceBackgroundColor
    = SurfaceBackground
    | SurfaceBackgroundSubdued


type CardType
    = Contained
    | ContainedWithFade SurfaceBackgroundColor
    | Uncontained


type alias Card msg =
    { type_ : CardType
    , classNames : List String
    , title : Maybe String
    , items : List (Html msg)
    }



-- CREATE


card : List (Html msg) -> Card msg
card items =
    { type_ = Uncontained, classNames = [], title = Nothing, items = items }


titled : String -> List (Html msg) -> Card msg
titled title items =
    { type_ = Uncontained, classNames = [], title = Just title, items = items }



-- MODIFY


withType : CardType -> Card msg -> Card msg
withType type_ card_ =
    { card_ | type_ = type_ }


withClassName : String -> Card msg -> Card msg
withClassName className card_ =
    { card_ | classNames = className :: card_.classNames }


withTightPadding : Card msg -> Card msg
withTightPadding card_ =
    withClassName "card_tight-padding" card_


asContained : Card msg -> Card msg
asContained card_ =
    { card_ | type_ = Contained }


asContainedWithFade : Card msg -> Card msg
asContainedWithFade card_ =
    asContainedWithFade_ SurfaceBackgroundSubdued card_


asContainedWithFade_ : SurfaceBackgroundColor -> Card msg -> Card msg
asContainedWithFade_ surfaceBg card_ =
    { card_ | type_ = ContainedWithFade surfaceBg }


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
    , classNames = cardA.classNames
    , title = cardA.title
    , items = List.map (Html.map toMsg) cardA.items
    }



-- VIEW


view : Card msg -> Html msg
view card_ =
    let
        classNames =
            card_.classNames
                |> List.map class

        ( items, hasTitleClass ) =
            case card_.title of
                Just t ->
                    ( h3 [ class "card-title" ] [ text t ] :: card_.items, [ class "has_card-title" ] )

                Nothing ->
                    ( card_.items, [] )

        typeClass =
            case card_.type_ of
                Contained ->
                    "contained"

                ContainedWithFade SurfaceBackground ->
                    "contained-with-fade contained-with-fade_surface-background"

                ContainedWithFade SurfaceBackgroundSubdued ->
                    "contained-with-fade contained-with-fade_surface-background-subdued"

                Uncontained ->
                    "uncontained"
    in
    div ([ class "card", class typeClass ] ++ classNames ++ hasTitleClass) items
