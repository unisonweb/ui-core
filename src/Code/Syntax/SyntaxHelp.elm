module Code.Syntax.SyntaxHelp exposing (..)

{-
   SyntaxHelp is a module that provides a function to get help for a given syntax segment.
-}

import Code.Syntax.SyntaxSegment exposing (..)
import Html exposing (Html, text)


{-| get returns the help for a given syntax segment.
-}
get : SyntaxSegment -> Maybe (Html msg)
get (SyntaxSegment type_ word) =
    case ( type_, word ) of
        ( BytesLiteral, _ ) ->
            Just bytesLiteral

        ( DataTypeKeyword, "type" ) ->
            Just typeKeyword

        _ ->
            Nothing



-- HELP


typeKeyword : Html msg
typeKeyword =
    text "Types are declared with the keyword type."


bytesLiteral : Html msg
bytesLiteral =
    text "This is how Bytes literals are represented in Unison."
