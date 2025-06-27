module UI.ModalOverlay exposing (modalOverlay)

import Html exposing (Html, node)
import Html.Attributes exposing (attribute)
import Html.Events exposing (on)
import Json.Decode as Decode


modalOverlay : Maybe msg -> Maybe msg -> Html msg -> Html msg
modalOverlay onEscape onEnter content =
    let
        escHandler =
            onEscape
                |> Maybe.map
                    (\onEsc ->
                        [ on "escape" (Decode.succeed onEsc)
                        , attribute "has-escape-handler" "true"
                        ]
                    )
                |> Maybe.withDefault []

        enterHandler =
            onEnter
                |> Maybe.map
                    (\onEnt ->
                        [ on "enter" (Decode.succeed onEnt)
                        , attribute "has-enter-handler" "true"
                        ]
                    )
                |> Maybe.withDefault []

        attrs =
            escHandler ++ enterHandler
    in
    node "modal-overlay" attrs [ content ]
