module Lib.EmbedVegaLite exposing (..)

import Html exposing (Html, node)
import Html.Attributes exposing (attribute, id)


type alias VegaLite =
    { markup : String }


vegaLite : String -> VegaLite
vegaLite markup =
    { markup = markup }


view : VegaLite -> Html msg
view v =
    node "embed-vega-lite"
        [ id "embed-vega-lite"
        , attribute "markup" v.markup
        ]
        []
