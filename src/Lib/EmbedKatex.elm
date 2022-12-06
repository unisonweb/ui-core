module Lib.EmbedKatex exposing (..)

import Html exposing (Html, node)
import Html.Attributes exposing (attribute, id)


type KatexDisplay
    = Inline
    | Block


type alias Katex =
    { markup : String
    , display : KatexDisplay
    }


katex : String -> Katex
katex markup =
    { markup = markup, display = Block }


withDisplay : KatexDisplay -> Katex -> Katex
withDisplay display k =
    { k | display = display }


asInline : Katex -> Katex
asInline k =
    { k | display = Inline }


asBlock : Katex -> Katex
asBlock k =
    { k | display = Block }


view : Katex -> Html msg
view k =
    let
        displayToString d =
            case d of
                Inline ->
                    "inline"

                Block ->
                    "block"
    in
    node "embed-katex"
        [ id "embed-katex"
        , attribute "markup" k.markup
        , attribute "display" (displayToString k.display)
        ]
        []
