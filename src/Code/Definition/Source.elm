module Code.Definition.Source exposing
    ( Source(..)
    , isBuiltin
    , numTermLines
    , numTermSignatureLines
    , numTypeLines
    , view
    , viewNamedTermSignature
    , viewTermSignature
    , viewTermSource
    , viewTypeSource
    )

import Code.Definition.Term as Term exposing (TermSignature(..), TermSource)
import Code.Definition.Type as Type exposing (TypeSource)
import Code.FullyQualifiedName as FQN exposing (FQN)
import Code.Source.SourceViewConfig as SourceViewConfig exposing (SourceViewConfig)
import Code.Syntax as Syntax
import Html exposing (Html, pre, span, text)
import Html.Attributes exposing (class)
import UI


type
    Source
    -- Term name source
    = Term FQN TermSource
    | Type TypeSource



-- HELPERS


isBuiltin : Source -> Bool
isBuiltin source =
    case source of
        Type Type.Builtin ->
            True

        Term _ (Term.Builtin _) ->
            True

        _ ->
            False


numTypeLines : TypeSource -> Int
numTypeLines source =
    case source of
        Type.Source syntax ->
            Syntax.numLines syntax

        Type.Builtin ->
            1


numTermLines : TermSource -> Int
numTermLines source =
    case source of
        Term.Source _ syntax ->
            Syntax.numLines syntax

        Term.Builtin (TermSignature signature) ->
            Syntax.numLines signature


numTermSignatureLines : TermSource -> Int
numTermSignatureLines source =
    case source of
        Term.Source (TermSignature signature) _ ->
            Syntax.numLines signature

        Term.Builtin (TermSignature signature) ->
            Syntax.numLines signature



-- VIEW


view : SourceViewConfig msg -> Source -> Html msg
view viewConfig source =
    case source of
        Type typeSource ->
            viewTypeSource viewConfig typeSource

        Term termName termSource ->
            viewTermSource viewConfig termName termSource


viewTypeSource : SourceViewConfig msg -> TypeSource -> Html msg
viewTypeSource viewConfig source =
    let
        content =
            case source of
                Type.Source syntax ->
                    viewSyntax viewConfig syntax

                Type.Builtin ->
                    span
                        []
                        [ span [ class "data-type-modifier" ] [ text "builtin " ]
                        , span [ class "data-type-keyword" ] [ text "type" ]
                        ]
    in
    viewCode viewConfig content


viewTermSignature : SourceViewConfig msg -> TermSignature -> Html msg
viewTermSignature viewConfig (TermSignature syntax) =
    viewCode viewConfig (viewSyntax viewConfig syntax)


viewNamedTermSignature : SourceViewConfig msg -> FQN -> TermSignature -> Html msg
viewNamedTermSignature viewConfig termName signature =
    viewCode viewConfig (viewNamedTermSignature_ viewConfig termName signature)


viewNamedTermSignature_ : SourceViewConfig msg -> FQN -> TermSignature -> Html msg
viewNamedTermSignature_ viewConfig termName (TermSignature syntax) =
    let
        name =
            FQN.toString termName

        rawLength =
            String.length (name ++ " : " ++ Syntax.toString syntax)

        syntax_ =
            if rawLength > 80 then
                span [] [ text "\n\t", viewSyntax viewConfig syntax ]

            else
                viewSyntax viewConfig syntax
    in
    pre
        []
        [ span [ class "hash-qualifier" ] [ text name ]
        , span [ class "type-ascription-colon" ] [ text " : " ]
        , syntax_
        ]


viewTermSource : SourceViewConfig msg -> FQN -> TermSource -> Html msg
viewTermSource viewConfig termName source =
    let
        content =
            case source of
                Term.Source _ syntax ->
                    viewSyntax viewConfig syntax

                Term.Builtin signature ->
                    viewNamedTermSignature viewConfig termName signature
    in
    viewCode viewConfig content



-- VIEW HELPERS


viewCode : SourceViewConfig msg -> Html msg -> Html msg
viewCode viewConfig content =
    UI.codeBlock
        [ class (SourceViewConfig.toClassName viewConfig) ]
        content


viewSyntax : SourceViewConfig msg -> (Syntax.Syntax -> Html msg)
viewSyntax viewConfig =
    Syntax.view (SourceViewConfig.toSyntaxConfig viewConfig)
