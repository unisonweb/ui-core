module Code.ProjectVersion exposing
    ( ProjectVersion
    , ascending
    , compare
    , decode
    , descending
    , equals
    , fromList
    , fromString
    , fromUrlString
    , greaterThan
    , lessThan
    , major
    , minor
    , nextMajor
    , nextMinor
    , nextPatch
    , patch
    , projectVersion
    , toList
    , toString
    , toUrlString
    , urlParser
    )

import Json.Decode as Decode
import Lib.Util as Util
import Maybe.Extra as MaybeE
import Url.Parser


type ProjectVersion
    = ProjectVersion
        { major : Int
        , minor : Int
        , patch : Int
        }



-- CREATE


projectVersion : Int -> Int -> Int -> ProjectVersion
projectVersion major_ minor_ patch_ =
    ProjectVersion { major = major_, minor = minor_, patch = patch_ }


fromList : List Int -> Maybe ProjectVersion
fromList ns =
    case ns of
        [ major_, minor_, patch_ ] ->
            Just (projectVersion major_ minor_ patch_)

        _ ->
            Nothing


fromString : String -> Maybe ProjectVersion
fromString s =
    s
        |> String.split "."
        |> List.map String.toInt
        |> MaybeE.combine
        |> Maybe.map fromList
        |> MaybeE.join


fromUrlString : String -> Maybe ProjectVersion
fromUrlString s =
    s
        |> String.split "_"
        |> List.map String.toInt
        |> MaybeE.combine
        |> Maybe.map fromList
        |> MaybeE.join



-- COMPARE


compare : ProjectVersion -> ProjectVersion -> Order
compare (ProjectVersion versionA) (ProjectVersion versionB) =
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


ascending : ProjectVersion -> ProjectVersion -> Order
ascending =
    compare


descending : ProjectVersion -> ProjectVersion -> Order
descending =
    Util.descending compare


lessThan : ProjectVersion -> ProjectVersion -> Bool
lessThan versionA versionB =
    compare versionA versionB == LT


greaterThan : ProjectVersion -> ProjectVersion -> Bool
greaterThan versionA versionB =
    compare versionA versionB == GT



-- HELPERS


major : ProjectVersion -> Int
major (ProjectVersion pv) =
    pv.major


minor : ProjectVersion -> Int
minor (ProjectVersion pv) =
    pv.minor


patch : ProjectVersion -> Int
patch (ProjectVersion pv) =
    pv.patch


equals : ProjectVersion -> ProjectVersion -> Bool
equals (ProjectVersion a) (ProjectVersion b) =
    a.major == b.major && a.minor == b.minor && b.patch == b.patch


nextMajor : ProjectVersion -> ProjectVersion
nextMajor pv =
    projectVersion (major pv + 1) 0 0


nextMinor : ProjectVersion -> ProjectVersion
nextMinor (ProjectVersion pv) =
    projectVersion pv.major (pv.minor + 1) 0


nextPatch : ProjectVersion -> ProjectVersion
nextPatch (ProjectVersion pv) =
    projectVersion pv.major pv.minor (pv.patch + 1)



-- TRANSFORMS


toList : ProjectVersion -> List Int
toList (ProjectVersion pv) =
    [ pv.major, pv.minor, pv.patch ]


toString : ProjectVersion -> String
toString pv =
    toString_ "." pv


toUrlString : ProjectVersion -> String
toUrlString pv =
    toString_ "_" pv


toString_ : String -> ProjectVersion -> String
toString_ sep pv =
    pv
        |> toList
        |> List.map String.fromInt
        |> String.join sep



-- DECODE


urlParser : Url.Parser.Parser (ProjectVersion -> a) a
urlParser =
    Url.Parser.custom "PROJECT_VERSION" fromUrlString


decode : Decode.Decoder ProjectVersion
decode =
    Decode.map fromString Decode.string
        |> Decode.andThen (Util.decodeFailInvalid "Invalid Project Version")
