module Lib.UnicodeSort exposing (compareUnicode)

{-
   Sort Strings by [RFC5051](http://www.rfc-editor.org/rfc/rfc5051.txt)

   Elm port of https://github.com/jgm/rfc5051
-}

import Char
import Dict
import Lib.UnicodeSort.UnicodeData exposing (decompositionMap)
import String


{-| Compare two strings using `unicode-casemap`
the simple unicode collation algorithm described in RFC 5051.
-}
compareUnicode : String -> String -> Order
compareUnicode x y =
    case ( String.uncons x, String.uncons y ) of
        ( Nothing, Nothing ) ->
            EQ

        ( Nothing, Just _ ) ->
            LT

        ( Just _, Nothing ) ->
            GT

        ( Just ( xc, x_ ), Just ( yc, y_ ) ) ->
            case compare (canonicalize xc) (canonicalize yc) of
                GT ->
                    GT

                LT ->
                    LT

                EQ ->
                    compareUnicode x_ y_


canonicalize : Char -> List Int
canonicalize =
    decompose << Char.toCode << Char.toUpper


decompose : Int -> List Int
decompose c =
    case decompose_ c of
        Nothing ->
            [ c ]

        Just xs ->
            List.concatMap decompose xs


decompose_ : Int -> Maybe (List Int)
decompose_ c =
    Dict.get c decompositionMap
