module Code.EmptyState exposing (..)

import Html exposing (Html, div, h2, header, p, text)
import Html.Attributes exposing (class)
import UI.Button as Button
import UI.Click exposing (Click)
import UI.Icon as Icon
import UI.PlaceholderShape as PlaceholderShape


viewFauxDefinition : Html msg
viewFauxDefinition =
    div [ class "code_empty-state_faux-definition" ]
        [ PlaceholderShape.text |> PlaceholderShape.withLength PlaceholderShape.Medium |> PlaceholderShape.view
        , PlaceholderShape.text |> PlaceholderShape.view
        ]


view : String -> Click msg -> Html msg
view title click =
    div [ class "code_empty-state" ]
        [ div [ class "code_empty-state_content" ]
            [ header []
                [ h2 [] [ text title ]
                , p [] [ text "Browse, search, read docs, open definition, and explore." ]
                ]
            , viewFauxDefinition
            , viewFauxDefinition
            , Button.iconThenLabel_ click Icon.search "Find Definitions" |> Button.primary |> Button.view
            ]
        ]