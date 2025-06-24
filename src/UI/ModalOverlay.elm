module UI.ModalOverlay exposing (modalOverlay)

import Html exposing (Html, node)
import Html.Events exposing (on)
import Json.Decode as Decode
import Maybe.Extra as MaybeE


modalOverlay : Maybe msg -> Maybe msg -> Html msg -> Html msg
modalOverlay onEscape onEnter content =
    let
        attrs =
            [ onEscape |> Maybe.map (\onEsc -> on "escape" (Decode.succeed onEsc))
            , onEnter |> Maybe.map (\onEnt -> on "enter" (Decode.succeed onEnt))
            ]
    in
    node "modal-overlay" (MaybeE.values attrs) [ content ]
