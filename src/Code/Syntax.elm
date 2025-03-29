module Code.Syntax exposing
    ( Syntax
    , Width(..)
    , decode
    , decodeSingleton
    , foldl
    , fromList
    , numLines
    , reference
    , toString
    , view
    )

import Code.Definition.Reference as Reference exposing (Reference)
import Code.HashQualified as HQ
import Code.Syntax.SyntaxConfig exposing (SyntaxConfig)
import Code.Syntax.SyntaxSegment as SyntaxSegment exposing (..)
import Html exposing (Html, span)
import Html.Attributes exposing (class)
import Json.Decode as Decode
import Lib.Util as Util
import List.Nonempty as NEL


type Width
    = Width Int


type Syntax
    = Syntax (NEL.Nonempty SyntaxSegment)



-- HELPERS


fromList : List SyntaxSegment -> Maybe Syntax
fromList segments =
    segments
        |> NEL.fromList
        |> Maybe.map Syntax


{-| TODO: Parse Syntax into a list of lines and this function can be removed
-}
numLines : Syntax -> Int
numLines (Syntax segments) =
    let
        count (SyntaxSegment _ segment) acc =
            if String.contains "\n" segment then
                acc + 1

            else
                acc
    in
    NEL.foldl count 1 segments


reference : SyntaxSegment -> Maybe Reference
reference (SyntaxSegment syntaxType _) =
    case syntaxType of
        TypeReference h fqn ->
            case fqn of
                Just n ->
                    Just (Reference.TypeReference (HQ.HashQualified n h))

                Nothing ->
                    Just (Reference.TypeReference (HQ.HashOnly h))

        TermReference h fqn ->
            case fqn of
                Just n ->
                    Just (Reference.TermReference (HQ.HashQualified n h))

                Nothing ->
                    Just (Reference.TermReference (HQ.HashOnly h))

        AbilityConstructorReference h fqn ->
            case fqn of
                Just n ->
                    Just (Reference.AbilityConstructorReference (HQ.HashQualified n h))

                Nothing ->
                    Just (Reference.AbilityConstructorReference (HQ.HashOnly h))

        DataConstructorReference h fqn ->
            case fqn of
                Just n ->
                    Just (Reference.DataConstructorReference (HQ.HashQualified n h))

                Nothing ->
                    Just (Reference.DataConstructorReference (HQ.HashOnly h))

        _ ->
            Nothing


foldl : (SyntaxSegment -> b -> b) -> b -> Syntax -> b
foldl f init (Syntax segments) =
    NEL.foldl f init segments


toString : Syntax -> String
toString (Syntax segments) =
    segments
        |> NEL.map SyntaxSegment.toString
        |> NEL.toList
        |> String.concat



-- VIEW


view : SyntaxConfig msg -> Syntax -> Html msg
view syntaxConfig (Syntax segments) =
    let
        renderedSegments =
            segments
                |> NEL.map (SyntaxSegment.view syntaxConfig)
                |> NEL.toList
    in
    span [ class "syntax" ] renderedSegments



-- DECODE


decodeSingleton : Decode.Decoder Syntax
decodeSingleton =
    Decode.map Syntax (Decode.map NEL.fromElement SyntaxSegment.decode)


decode : Decode.Decoder Syntax
decode =
    Decode.map Syntax
        (Util.decodeNonEmptyList SyntaxSegment.decode)
