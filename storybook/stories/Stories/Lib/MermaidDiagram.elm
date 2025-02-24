module Stories.Lib.MermaidDiagram exposing (..)

import Browser
import Helpers.Layout exposing (columns)
import Html exposing (Html, text)
import Lib.MermaidDiagram as MermaidDiagram


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


diagram : String
diagram =
    """graph
   A-->B[Unison]
   B-->C[supports]
   C-->D[Mermaid]
  """


view : Html Msg
view =
    columns []
        [ text "Mermaid Diagram"
        , MermaidDiagram.mermaid diagram
            |> MermaidDiagram.view
        ]
