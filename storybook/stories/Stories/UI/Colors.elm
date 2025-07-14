module Stories.UI.Colors exposing (main)

import Browser
import Color as C
import Html exposing (..)
import Html.Attributes exposing (..)
import UI.Color as Color


main : Program () () Msg
main =
    Browser.element
        { init = \_ -> ( (), Cmd.none )
        , view = \_ -> view
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }


type alias Msg =
    ()


view : Html Msg
view =
    div [ class "colors" ]
        [ h1 [] [ text "Unison colors" ]
        , div []
            [ colorSection "Grays" Color.grays
            , colorSection "Pinks" Color.pinks
            , colorSection "Greens" Color.greens
            , colorSection "Blues" Color.blues
            , colorSection "Oranges" Color.oranges
            , colorSection "Purples" Color.purples
            ]
        ]


colorSection : String -> List Color.Color -> Html Msg
colorSection title colors =
    div [ class "color-section" ]
        [ h2 [] [ text title ]
        , div [ class "color-grid" ]
            (List.indexedMap (colorSwatch title) colors)
        ]


colorSwatch : String -> Int -> Color.Color -> Html Msg
colorSwatch sectionTitle index color =
    let
        colorName =
            String.toLower sectionTitle
                |> String.dropRight 1
                |> (\name -> name ++ "-" ++ String.fromInt index)

        rgbaValue =
            Color.toRgbaString color
    in
    div [ class "color-swatch" ]
        [ div
            [ class "color-preview"
            , style "background-color" rgbaValue
            ]
            []
        , div [ class "color-info" ]
            [ div [ class "color-name" ] [ text colorName ]
            , div [ class "color-value-section" ]
                [ div [ class "color-value" ] [ text ("var(--color-" ++ colorName ++ ")") ]
                , div [ class "color-value" ] [ text rgbaValue ]
                ]
            ]
        ]
