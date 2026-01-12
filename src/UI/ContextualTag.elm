module UI.ContextualTag exposing (..)

import Html exposing (Html, div, span, text)
import Html.Attributes exposing (class)
import UI
import UI.Icon as Icon exposing (Icon)
import UI.Tooltip as Tooltip


type TagColor
    = Subdued
    | DecorativePurple
    | DecorativeBlue


type alias ContextualTag msg =
    { icon : Icon msg
    , label : Html msg
    , secondaryLabel : Maybe (Html msg)
    , color : TagColor
    , tooltipText : Maybe String
    }



-- CREATE


contextualTag : Icon msg -> String -> ContextualTag msg
contextualTag icon label =
    contextualTag_ icon (text label) Nothing


contextualTag_ : Icon msg -> Html msg -> Maybe (Html msg) -> ContextualTag msg
contextualTag_ icon label secondaryLabel =
    { icon = icon
    , label = label
    , secondaryLabel = secondaryLabel
    , color = Subdued
    , tooltipText = Nothing
    }



-- MODIFY


subdued : ContextualTag msg -> ContextualTag msg
subdued tag =
    { tag | color = Subdued }


decorativePurple : ContextualTag msg -> ContextualTag msg
decorativePurple tag =
    { tag | color = DecorativePurple }


decorativeBlue : ContextualTag msg -> ContextualTag msg
decorativeBlue tag =
    { tag | color = DecorativeBlue }


withTooltipText : String -> ContextualTag msg -> ContextualTag msg
withTooltipText text tag =
    { tag | tooltipText = Just text }


withSecondaryLabel : String -> ContextualTag msg -> ContextualTag msg
withSecondaryLabel secondaryLabel tag =
    withSecondaryLabel_ (text secondaryLabel) tag


withSecondaryLabel_ : Html msg -> ContextualTag msg -> ContextualTag msg
withSecondaryLabel_ secondaryLabel tag =
    { tag | secondaryLabel = Just secondaryLabel }


when : Bool -> (ContextualTag msg -> ContextualTag msg) -> ContextualTag msg -> ContextualTag msg
when condition f tag =
    whenElse condition f identity tag


whenElse :
    Bool
    -> (ContextualTag msg -> ContextualTag msg)
    -> (ContextualTag msg -> ContextualTag msg)
    -> ContextualTag msg
    -> ContextualTag msg
whenElse condition f g tag =
    if condition then
        f tag

    else
        g tag


whenNot : Bool -> (ContextualTag msg -> ContextualTag msg) -> ContextualTag msg -> ContextualTag msg
whenNot condition f tag =
    when (not condition) f tag



-- VIEW


view : ContextualTag msg -> Html msg
view tag =
    let
        color =
            case tag.color of
                Subdued ->
                    "subdued"

                DecorativePurple ->
                    "decorative-purple"

                DecorativeBlue ->
                    "decorative-blue"

        tag_ =
            div
                [ class "contextual-tag", class color ]
                [ Icon.view tag.icon
                , span [ class "contextual-tag_label" ] [ tag.label ]
                , tag.secondaryLabel
                    |> Maybe.map (\l -> span [ class "contextual-tag_secondary-label" ] [ l ])
                    |> Maybe.withDefault UI.nothing
                ]
    in
    case tag.tooltipText of
        Just t ->
            Tooltip.text t
                |> Tooltip.tooltip
                |> Tooltip.below
                |> Tooltip.withArrow Tooltip.Start
                |> Tooltip.view tag_

        Nothing ->
            tag_
