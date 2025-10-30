module Code.Syntax.SyntaxConfig exposing (..)

import Code.Definition.Reference exposing (Reference)
import UI.Click exposing (Click)
import UI.Tooltip exposing (Tooltip)


type alias TooltipConfig msg =
    { toHoverStart : Reference -> msg
    , toHoverEnd : Reference -> msg
    , toTooltip : Reference -> Maybe (Tooltip msg)
    }


type alias ToClick msg =
    Reference -> Click msg


type alias SyntaxConfig msg =
    { toClick : Maybe (ToClick msg)
    , dependencyTooltip : Maybe (TooltipConfig msg)
    , showSyntaxHelpTooltip : Bool
    }



-- CREATE


empty : SyntaxConfig msg
empty =
    { toClick = Nothing, dependencyTooltip = Nothing, showSyntaxHelpTooltip = False }


default : ToClick msg -> TooltipConfig msg -> SyntaxConfig msg
default toClick tooltipConfig =
    empty
        |> withToClick toClick
        |> withDependencyTooltip tooltipConfig
        |> withSyntaxHelp



-- MODIFY


withToClick : ToClick msg -> SyntaxConfig msg -> SyntaxConfig msg
withToClick toClick cfg =
    { cfg | toClick = Just toClick }


withDependencyTooltip : TooltipConfig msg -> SyntaxConfig msg -> SyntaxConfig msg
withDependencyTooltip tooltipConfig cfg =
    { cfg | dependencyTooltip = Just tooltipConfig }


withoutDependencyTooltip : SyntaxConfig msg -> SyntaxConfig msg
withoutDependencyTooltip cfg =
    { cfg | dependencyTooltip = Nothing }


withSyntaxHelp : SyntaxConfig msg -> SyntaxConfig msg
withSyntaxHelp cfg =
    { cfg | showSyntaxHelpTooltip = True }


withoutSyntaxHelp : SyntaxConfig msg -> SyntaxConfig msg
withoutSyntaxHelp cfg =
    { cfg | showSyntaxHelpTooltip = False }
