module Code.Source.SourceViewConfig exposing
    ( SourceViewConfig
    , monochrome
    , plain
    , rich
    , rich_
    , toClassName
    , toSyntaxLinked
    )

import Code.Syntax as Syntax


type SourceViewConfig msg
    = Rich (Syntax.Linked msg)
    | Monochrome
    | Plain


rich : Syntax.LinkedWithTooltipConfig msg -> SourceViewConfig msg
rich linkedWithTooltip =
    rich_ (Syntax.LinkedWithTooltip linkedWithTooltip)


rich_ : Syntax.Linked msg -> SourceViewConfig msg
rich_ =
    Rich


monochrome : SourceViewConfig msg
monochrome =
    Monochrome


plain : SourceViewConfig msg
plain =
    Plain



-- HELPERS


toClassName : SourceViewConfig msg -> String
toClassName viewConfig =
    case viewConfig of
        Rich _ ->
            "rich"

        Monochrome ->
            "monochrome"

        Plain ->
            "plain"


toSyntaxLinked : SourceViewConfig msg -> Syntax.Linked msg
toSyntaxLinked viewConfig =
    case viewConfig of
        Rich linked ->
            linked

        _ ->
            Syntax.NotLinked
