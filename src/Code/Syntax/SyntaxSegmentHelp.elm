{- A collection of syntax help texts used in tooltips when hovering Unison
   syntax like `cases` or `match`
-}


module Code.Syntax.SyntaxSegmentHelp exposing (..)

import Html exposing (Html, text)



-- Literals


numericLiteral : Html msg
numericLiteral =
    text "A numeric literal. Some common numeric types are `Nat`: `24`, `Float`: `4.5`, and `Int`: `-60`."


textLiteral : Html msg
textLiteral =
    text "The value inside of the double quotes is a `Text` literal."


textLiteralMultiline : Html msg
textLiteralMultiline =
    text "A multi-line `Text` literal. These values preserve whitespace and line breaks. "


bytesLiteral : Html msg
bytesLiteral =
    text "A `Bytes` literal. An arbitrary-length 8-bit byte sequence."


charLiteral : Html msg
charLiteral =
    text "A `Char` literal: `Char` is the type for a single Unicode character."



-- List


cons : Html msg
cons =
    text "Extracts the head element of a list from its tail and binds each to a variable, for example: `head +: tail`. "


snoc : Html msg
snoc =
    text "Extracts the last element of a list and binds the two segments to variables, for example: `prefix :+ last`."



-- Types


typeKeyword : Html msg
typeKeyword =
    text "Introduces a type definition. By default, `type` introduces a unique type: one which will be referenced by its name."


typeParams : Html msg
typeParams =
    text "A lowercase value in a type signature introduces a type parameter "


typeForall : Html msg
typeForall =
    text "`forall` describes a type that is universally quantified."


typeAscriptionColon : Html msg
typeAscriptionColon =
    text "In a type signature, the colon separates the name of a function from its type. The colon can be read as \"has type\"."


uniqueKeyword : Html msg
uniqueKeyword =
    text "Introduces a nominal type: one which will be referenced by its name, as opposed to one which is identified by its structure."


structuralKeyword : Html msg
structuralKeyword =
    text "Introduces a structural type: one which is identified and unique to its structure, not by its name."



-- Links


typeLink : Html msg
typeLink =
    text "`typeLink` takes a Unison type as an argument and turns it into a value of `Link.Type`. Most commonly used in error messages or the `Doc` type."


termLink : Html msg
termLink =
    text "`termLink` takes a Unison term as an argument and creates a value of `Link.Term`."



-- Pattern matching


matchWith : Html msg
matchWith =
    text "Introduces a way to check a value against a pattern. The expression to the right of `match` is the target value of the match, and the statement(s) following `with` are the potential patterns."


cases : Html msg
cases =
    text "`cases` is syntactic sugar for a `match statement`. For example, `match a with a1` could be shortened `cases a1`."


asPattern : Html msg
asPattern =
    text "In a pattern match,`@` is an \"as-pattern\". It is a way of binding a variable to an element in the pattern match. The value to the left of the `@` is the variable name and the value to the right is what the variable references."



-- Conditionals


ifElse : Html msg
ifElse =
    text "A conditional statement. If the `Boolean` expression argument is `true`, the first branch of the statement will be executed, if it is `false`, the second branch will be run instead. "



-- Use/Imports


use : Html msg
use =
    text "A `use` clause tells Unison to allow identifiers from a given namespace to be used without prefixing in the lexical scope where the use clause appears."



-- Abilities


abilityWhere : Html msg
abilityWhere =
    text "Introduces an ability definition. The name of the ability follows the keyword and the operations that the ability can perform are listed as function signatures after the `where` keyword. "


abilityBraces : Html msg
abilityBraces =
    text "Defines the set of abilities that a function can perform. The abilities will appear in a comma-delimited list. "


handleWith : Html msg
handleWith =
    text "The `handle` keyword indicates that a function is an ability handler. The first argument is an expression performing a particular ability to handle and what follows dictates how the ability should be handled."


doKeyword : Html msg
doKeyword =
    text "`do` introduces a delayed computation, something with the form `() -> a`."


delayed : Html msg
delayed =
    text "In a type signature, `'` indicates an argument is delayed,  so `'`a means `() -> a`.  In a function body, `'` indicates that the term immediately to the right is delayed. "


forceParens : Html msg
forceParens =
    text "`()` forces the evaluation of a delayed computation."



-- Misc


concat : Html msg
concat =
    text "Matches a list that is composed of the concatenation of two sub-lists. At least one of the sub-lists must be a pattern with a known length, commonly indicated by square brackets: `[a, b] ++ tail`."


unit : Html msg
unit =
    text "Unit is the type which represents a no-argument tuple `()`. Its one data constructor is also written `()`."
