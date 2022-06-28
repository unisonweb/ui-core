module UI.Steps exposing (Step, Steps, singleton, step, steps, view, withStep)

import Html exposing (Html, div, h3, text)
import Html.Attributes exposing (class)
import List.Nonempty as Nonempty exposing (Nonempty)


type alias Step msg =
    { title : String, content : List (Html msg) }


type alias Steps msg =
    Nonempty (Step msg)



-- CREATE


step : String -> List (Html msg) -> Step msg
step title content =
    { title = title, content = content }


steps : Step msg -> List (Step msg) -> Steps msg
steps step_ steps_ =
    Nonempty.Nonempty step_ steps_


singleton : Step msg -> Steps msg
singleton step_ =
    Nonempty.fromElement step_


withStep : Step msg -> Steps msg -> Steps msg
withStep step_ steps_ =
    Nonempty.append steps_ (Nonempty.singleton step_)



-- VIEW


viewStep : Int -> Step msg -> Html msg
viewStep index step_ =
    let
        stepNumber =
            div [ class "step-number" ] [ text (String.fromInt (index + 1)) ]

        details =
            div [ class "step-details" ]
                [ h3 [ class "step-title" ] [ text step_.title ]
                , div [ class "step-content" ] step_.content
                ]
    in
    div [ class "step" ]
        [ stepNumber
        , details
        ]


view : Steps msg -> Html msg
view steps_ =
    let
        steps__ =
            steps_ |> Nonempty.toList |> List.indexedMap viewStep
    in
    div [ class "steps" ] steps__
