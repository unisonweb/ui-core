module Code.Syntax.Linked exposing (..)

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


type alias LinkedWithTooltipConfig msg =
    { toClick : ToClick msg
    , tooltip : TooltipConfig msg
    }


type Linked msg
    = Linked (ToClick msg)
    | LinkedWithTooltip (LinkedWithTooltipConfig msg)
    | NotLinked


linkedWithTooltipConfig :
    ToClick msg
    -> TooltipConfig msg
    -> LinkedWithTooltipConfig msg
linkedWithTooltipConfig toClick tooltipConfig =
    { toClick = toClick, tooltip = tooltipConfig }
