module Lib.MermaidDiagram exposing (..)

import Html exposing (Html, node)
import Html.Attributes exposing (attribute)


type alias ThemeConfig =
    {}


type Theme
    = Predefined String
    | Custom ThemeConfig


type alias Mermaid =
    { diagram : String, theme : Theme }



-- CREATE


mermaid : String -> Mermaid
mermaid diagram =
    { diagram = diagram, theme = Predefined "neutral" }



-- MODIFY


withTheme : String -> Mermaid -> Mermaid
withTheme themeName m =
    withTheme_ (Predefined themeName) m


withCustomTheme : ThemeConfig -> Mermaid -> Mermaid
withCustomTheme themeCfg m =
    withTheme_ (Custom themeCfg) m


withTheme_ : Theme -> Mermaid -> Mermaid
withTheme_ theme m =
    { m | theme = theme }



-- VIEW


view : Mermaid -> Html msg
view { diagram, theme } =
    let
        themeAttr =
            case theme of
                Predefined themeName ->
                    attribute "theme-name" themeName

                Custom cfg ->
                    attribute "custom-theme" "custom"
    in
    node "mermaid-diagram" [ attribute "diagram" diagram, themeAttr ] []
