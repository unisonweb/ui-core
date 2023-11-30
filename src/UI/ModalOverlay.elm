module UI.ModalOverlay exposing (modalOverlay)

import Html exposing (Html, node)
import Html.Events exposing (on)
import Json.Decode as Decode


modalOverlay : Maybe msg -> Html msg -> Html msg
modalOverlay onEscape content =
    let
        attrs =
            case onEscape of
                Just onEsc ->
                    [ on "escape" (Decode.succeed onEsc) ]

                Nothing ->
                    []
    in
    node "modal-overlay" attrs [ content ]
