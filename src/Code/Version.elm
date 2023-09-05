module Code.Version exposing
    ( Version
    , ascending
    , clampToNextValid
    , compare
    , decode
    , descending
    , empty
    , equals
    , fromList
    , fromString
    , fromUrlString
    , greaterThan
    , isANextValid
    , lessThan
    , major
    , minor
    , nextMajor
    , nextMinor
    , nextPatch
    , patch
    , toList
    , toString
    , toUrlString
    , unsafeFromString
    , version
    , view
    )

import Html exposing (Html, span, text)
import Html.Attributes exposing (class)
import Json.Decode as Decode
import Lib.Util as Util
import Maybe.Extra as MaybeE


type Version
    = Version
        { major : Int
        , minor : Int
        , patch : Int
        }



-- CREATE


empty : Version
empty =
    version 0 0 0


version : Int -> Int -> Int -> Version
version major_ minor_ patch_ =
    Version { major = major_, minor = minor_, patch = patch_ }


fromList : List Int -> Maybe Version
fromList ns =
    case ns of
        [ major_, minor_, patch_ ] ->
            Just (version major_ minor_ patch_)

        _ ->
            Nothing


fromString : String -> Maybe Version
fromString s =
    s
        |> String.split "."
        |> List.map String.toInt
        |> MaybeE.combine
        |> Maybe.map fromList
        |> MaybeE.join


{-| ⚠️ Don't use outside of testing--defaults to 1.0.0
-}
unsafeFromString : String -> Version
unsafeFromString s =
    s
        |> String.split "."
        |> List.map String.toInt
        |> MaybeE.combine
        |> Maybe.map fromList
        |> MaybeE.join
        |> Maybe.withDefault (version 1 0 0)


fromUrlString : String -> Maybe Version
fromUrlString s =
    s
        |> String.split "."
        |> List.map String.toInt
        |> MaybeE.combine
        |> Maybe.map fromList
        |> MaybeE.join



-- COMPARE


compare : Version -> Version -> Order
compare (Version versionA) (Version versionB) =
    let
        compareIfEQ order comparison =
            case order of
                EQ ->
                    comparison ()

                _ ->
                    order
    in
    [ \() -> Basics.compare versionA.major versionB.major
    , \() -> Basics.compare versionA.minor versionB.minor
    , \() -> Basics.compare versionA.patch versionB.patch
    ]
        |> List.foldl (\b a -> compareIfEQ a b) EQ


ascending : Version -> Version -> Order
ascending =
    compare


descending : Version -> Version -> Order
descending =
    Util.descending compare


lessThan : Version -> Version -> Bool
lessThan versionA versionB =
    compare versionA versionB == LT


greaterThan : Version -> Version -> Bool
greaterThan versionA versionB =
    compare versionA versionB == GT



-- HELPERS


major : Version -> Int
major (Version v) =
    v.major


minor : Version -> Int
minor (Version v) =
    v.minor


patch : Version -> Int
patch (Version v) =
    v.patch


equals : Version -> Version -> Bool
equals (Version a) (Version b) =
    a.major == b.major && a.minor == b.minor && a.patch == b.patch


nextMajor : Version -> Version
nextMajor v =
    version (major v + 1) 0 0


nextMinor : Version -> Version
nextMinor (Version v) =
    version v.major (v.minor + 1) 0


nextPatch : Version -> Version
nextPatch (Version v) =
    version v.major v.minor (v.patch + 1)


isANextValid : Version -> Version -> Bool
isANextValid current candidate =
    let
        major_ =
            nextMajor current

        minor_ =
            nextMinor current

        patch_ =
            nextPatch current
    in
    equals major_ candidate || equals minor_ candidate || equals patch_ candidate


{-| Given a candidate, find the next and nearest valid version


## Examples:

  - clampToNextValid (Version 1 0 0) (Version 0 0 1)
    -> Version 2 0 0

  - clampToNextValid (Version 1 0 0) (Version 1.1.0)
    -> Version 1.1.0

  - clampToNextValid (Version 1 0 0) (Version 1.5.0)
    -> Version 1.1.0

  - clampToNextValid (Version 1 0 0) (Version 1.0.3)
    -> Version 1.0.1

-}
clampToNextValid : Version -> Version -> Version
clampToNextValid current candidate =
    let
        major_ =
            nextMajor current

        minor_ =
            nextMinor current

        patch_ =
            nextPatch current
    in
    if isANextValid current candidate then
        candidate

    else if greaterThan candidate major_ then
        major_

    else if greaterThan candidate minor_ then
        minor_

    else
        patch_



-- TRANSFORMS


toList : Version -> List Int
toList (Version v) =
    [ v.major, v.minor, v.patch ]


toString : Version -> String
toString v =
    toString_ "." v


toUrlString : Version -> String
toUrlString v =
    toString_ "." v


toNamespaceString : Version -> String
toNamespaceString v =
    toString_ "_" v


toString_ : String -> Version -> String
toString_ sep v =
    v
        |> toList
        |> List.map String.fromInt
        |> String.join sep



-- VIEW


view : Version -> Html msg
view v =
    span [ class "version" ] [ text (toString v) ]



-- DECODE


decode : Decode.Decoder Version
decode =
    Decode.map fromString Decode.string
        |> Decode.andThen (Util.decodeFailInvalid "Invalid Version")
