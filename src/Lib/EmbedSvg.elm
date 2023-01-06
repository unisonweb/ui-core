module Lib.EmbedSvg exposing (..)

import Html exposing (Html, node, text)
import Html.Attributes exposing (id)


type alias Svg =
    { markup : String
    }


svg : String -> Svg
svg markup =
    { markup = markup }


view : Svg -> Html msg
view { markup } =
    node "embed-svg" [ id "embed-svg" ] [ text markup ]
