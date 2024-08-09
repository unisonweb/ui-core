module Code.Source.SourceViewConfig exposing
    ( SourceViewConfig
    , monochrome
    , plain
    , rich
    , rich_
    , toClassName
    , toSyntaxConfig
    )

import Code.Syntax.SyntaxConfig as SyntaxConfig exposing (SyntaxConfig)


type SourceViewConfig msg
    = Rich (SyntaxConfig msg)
    | Monochrome
    | Plain


rich : SyntaxConfig msg -> SourceViewConfig msg
rich syntaxConfig =
    rich_ syntaxConfig


rich_ : SyntaxConfig msg -> SourceViewConfig msg
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


toSyntaxConfig : SourceViewConfig msg -> SyntaxConfig msg
toSyntaxConfig viewConfig =
    case viewConfig of
        Rich syntaxConfig ->
            syntaxConfig

        _ ->
            SyntaxConfig.empty
