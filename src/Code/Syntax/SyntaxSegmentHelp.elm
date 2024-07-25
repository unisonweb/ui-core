{- A collection of syntax help texts used in tooltips when hovering Unison
   syntax like `cases` or `match`
-}


module Code.Syntax.SyntaxSegmentHelp exposing (..)

import Html exposing (Html, text)



-- Literals


numericLiteral : Html msg
numericLiteral =
    text "Something something"


textLiteral : Html msg
textLiteral =
    text "Something something"


bytesLiteral : Html msg
bytesLiteral =
    text "Something something"


charLiteral : Html msg
charLiteral =
    text "Something something"



-- List


cons : Html msg
cons =
    text "Something something"


snoc : Html msg
snoc =
    text "Something something"



-- Types


typeKeyword : Html msg
typeKeyword =
    text "Something something"


typeParams : Html msg
typeParams =
    text "Something something"


typeOperator : Html msg
typeOperator =
    text "Something something"


typeAscriptionColon : Html msg
typeAscriptionColon =
    text "Something something"



-- Links


typeLink : Html msg
typeLink =
    text "Something something"


termLink : Html msg
termLink =
    text "Something something"



-- Pattern matching


matchWith : Html msg
matchWith =
    text "Something something pattern matching"


cases : Html msg
cases =
    text "Something something pattern matching"



-- Conditionals


ifElse : Html msg
ifElse =
    text ""



-- Use/Imports


use : Html msg
use =
    text "Similar to an import statement"



-- Abilities


abilityKeyword : Html msg
abilityKeyword =
    text "Ability"


abilityBraces : Html msg
abilityBraces =
    text "Ability"


handle : Html msg
handle =
    text "Handles an Ability"


thunkQuote : Html msg
thunkQuote =
    text "Denotes a thunk"


forceParens : Html msg
forceParens =
    text "Runs a thunk"



-- Misc


concat : Html msg
concat =
    text "Something something"


unit : Html msg
unit =
    text "Something something"


uniqueKeyword : Html msg
uniqueKeyword =
    text "Something something"
