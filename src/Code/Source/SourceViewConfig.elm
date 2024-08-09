module Code.Source.SourceViewConfig exposing
    ( SourceViewConfig
    , monochrome
    , plain
    , rich
    , rich_
    , toClassName
    , toSyntaxLinked
    )

import Code.Syntax.Linked exposing (Linked(..), LinkedWithTooltipConfig)


type SourceViewConfig msg
    = Rich (Linked msg)
    | Monochrome
    | Plain


rich : LinkedWithTooltipConfig msg -> SourceViewConfig msg
rich linkedWithTooltip =
    rich_ (LinkedWithTooltip linkedWithTooltip)


rich_ : Linked msg -> SourceViewConfig msg
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


toSyntaxLinked : SourceViewConfig msg -> Linked msg
toSyntaxLinked viewConfig =
    case viewConfig of
        Rich linked ->
            linked

        _ ->
            NotLinked
