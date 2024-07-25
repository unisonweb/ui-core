{- A collection of syntax help texts used in tooltips when hovering Unison
   syntax like `cases` or `match`
-}


module Code.Syntax.SyntaxSegmentHelp exposing (..)

import Html exposing (Html, code, div, text)
import Html.Attributes exposing (class)


inlineCode : String -> Html msg
inlineCode code_ =
    code [ class "inline-code" ] [ text code_ ]


help : List (Html msg) -> Html msg
help content =
    div [] content



-- Literals


numericLiteral : Html msg
numericLiteral =
    help
        [ text "A numeric literal. Some common numeric types are "
        , inlineCode "Nat"
        , text ": "
        , inlineCode "24"
        , text ", "
        , inlineCode "Float"
        , text ": "
        , inlineCode "4.5"
        , text ", and  "
        , inlineCode "Int"
        , text ": "
        , inlineCode "-60"
        , text "."
        ]


textLiteral : Html msg
textLiteral =
    help
        [ text "The value inside of the double quotes is a ", inlineCode "Text", text "literal." ]


textLiteralMultiline : Html msg
textLiteralMultiline =
    help
        [ text "A multi-line ", inlineCode "Text", text " literal. These values preserve whitespace and line breaks. " ]


bytesLiteral : Html msg
bytesLiteral =
    help
        [ text "A ", inlineCode "Bytes", text " literal. An arbitrary-length 8-bit byte sequence." ]


charLiteral : Html msg
charLiteral =
    help [ text "A ", inlineCode "Char", text " literal: ", inlineCode "Char", text " is the type for a single Unicode character." ]



-- List


cons : Html msg
cons =
    help [ text "Extracts the head element of a list from its tail and binds each to a variable, for example: ", inlineCode "head +: tail", text ". " ]


snoc : Html msg
snoc =
    help [ text "Extracts the last element of a list and binds the two segments to variables, for example: ", inlineCode "prefix :+ last", text "." ]



-- Types


typeKeyword : Html msg
typeKeyword =
    help [ text "Introduces a type definition. By default, ", inlineCode "type", text " introduces a unique type: one which will be referenced by its name." ]


typeParams : Html msg
typeParams =
    help [ text "A lowercase value in a type signature introduces a type parameter " ]


typeForall : Html msg
typeForall =
    help [ inlineCode "forall", text " describes a type that is universally quantified." ]


typeAscriptionColon : Html msg
typeAscriptionColon =
    help [ text "In a type signature, the colon separates the name of a function from its type. The colon can be read as \"has type\"." ]


uniqueKeyword : Html msg
uniqueKeyword =
    help [ text "Introduces a nominal type: one which will be referenced by its name, as opposed to one which is identified by its structure." ]


structuralKeyword : Html msg
structuralKeyword =
    help [ text "Introduces a structural type: one which is identified and unique to its structure, not by its name." ]



-- Links


typeLink : Html msg
typeLink =
    help
        [ inlineCode "typeLink"
        , text " takes a Unison type as an argument and turns it into a value of "
        , inlineCode "Link.Type"
        , text ". Most commonly used in error messages or the "
        , inlineCode "Doc"
        , text " type."
        ]


termLink : Html msg
termLink =
    help
        [ inlineCode "termLink"
        , text " takes a Unison term as an argument and creates a value of "
        , inlineCode "Link.Term"
        , text "."
        ]



-- Pattern matching


matchWith : Html msg
matchWith =
    help
        [ text "Introduces a way to check a value against a pattern. The expression to the right of "
        , inlineCode "match"
        , text " is the target value of the match, and the statement(s) following "
        , inlineCode "with"
        , text "are the potential patterns."
        ]


cases : Html msg
cases =
    help
        [ text "It's common to pattern match on a function argument, like "
        , inlineCode "(a -> match a with a1 -> ... )"
        , text ". "
        , inlineCode "cases"
        , text "shortens this to"
        , inlineCode "cases a1 -> ..."
        , text "."
        ]


asPattern : Html msg
asPattern =
    help
        [ text "In a pattern match, "
        , inlineCode "@"
        , text "is an \"as-pattern\". It is a way of binding a variable to an element in the pattern match. The value to the left of the "
        , inlineCode "@"
        , text " is the variable name and the value to the right is what the variable references."
        ]



-- Conditionals


ifElse : Html msg
ifElse =
    help
        [ text "A conditional statement. If the "
        , inlineCode "Boolean"
        , text "expression argument is "
        , inlineCode "true"
        , text ", the first branch of the statement will be executed, if it is "
        , inlineCode "false"
        , text ", the second branch will be run instead."
        ]



-- Use/Imports


use : Html msg
use =
    help
        [ text "A "
        , inlineCode "use"
        , text " clause tells Unison to allow identifiers from a given namespace to be used without prefixing in the lexical scope where the use clause appears."
        ]



-- Abilities


abilityWhere : Html msg
abilityWhere =
    help
        [ text "Introduces an ability definition. The name of the ability follows the keyword and the operations that the ability can perform are listed as function signatures after the "
        , inlineCode "where"
        , text " keyword. "
        ]


abilityBraces : Html msg
abilityBraces =
    help [ text "Defines the set of abilities that a function can perform. The abilities will appear in a comma-delimited list. " ]


handleWith : Html msg
handleWith =
    help
        [ text "The "
        , inlineCode "handle"
        , text " keyword indicates that a function is an ability handler. The first argument is an expression performing a particular ability to handle and what follows dictates how the ability should be handled."
        ]


doKeyword : Html msg
doKeyword =
    help
        [ inlineCode "do"
        , text " introduces a delayed computation, something with the form "
        , inlineCode "() -> a"
        , text "."
        ]


delayed : Html msg
delayed =
    help
        [ text "In a type signature, "
        , inlineCode "'"
        , text "indicates an argument is delayed,  so "
        , inlineCode "'a"
        , text " means "
        , inlineCode "() -> a"
        , text ". In a function body, "
        , inlineCode "'"
        , text " indicates that the term immediately to the right is delayed. "
        ]


forceParens : Html msg
forceParens =
    help
        [ inlineCode "()"
        , text "forces the evaluation of a delayed computation."
        ]



-- Misc


concat : Html msg
concat =
    help
        [ text "Matches a list that is composed of the concatenation of two sub-lists. At least one of the sub-lists must be a pattern with a known length, commonly indicated by square brackets: "
        , inlineCode "[a, b] ++ tail"
        , text "."
        ]


unit : Html msg
unit =
    help
        [ text "Unit is the type which represents a no-argument tuple "
        , inlineCode "()"
        , text ". Its one data constructor is also written "
        , inlineCode "()"
        , text "."
        ]
