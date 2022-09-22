module Code.Definition.Readme exposing (..)

import Code.Definition.Doc as Doc exposing (Doc, DocFoldToggles, FoldId)
import Code.Syntax as Syntax
import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Json.Decode as Decode


{-| Represent the Readme Doc definition of a namespace. This is typically
rendered slightly different than other docs when viewed from a Namespace
landing page point of view.
-}
type Readme
    = Readme Doc



-- VIEW


view :
    Syntax.LinkedWithTooltipConfig msg
    -> (FoldId -> msg)
    -> DocFoldToggles
    -> Readme
    -> Html msg
view syntaxCfg toggleFoldMsg docFoldToggles (Readme doc) =
    div [ class "readme" ]
        [ Doc.view syntaxCfg toggleFoldMsg docFoldToggles doc ]



-- DECODE


decode : Decode.Decoder Readme
decode =
    Decode.map Readme Doc.decode
