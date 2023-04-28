module Code.FullyQualifiedName exposing
    ( FQN
    , append
    , cons
    , decode
    , decodeFromParent
    , dropLast
    , equals
    , extend
    , fromList
    , fromParent
    , fromString
    , fromUrlList
    , fromUrlString
    , isSuffixOf
    , isValidSegmentChar
    , isValidUrlSegmentChar
    , namespace
    , namespaceOf
    , numSegments
    , segments
    , snoc
    , stripPrefix
    , toApiUrlString
    , toQueryString
    , toQueryString_
    , toString
    , toUrlSegments
    , toUrlString
    , unqualifiedName
    , urlParser
    , view
    , viewClickable
    )

import Html exposing (Html, span, text)
import Html.Attributes exposing (class)
import Json.Decode as Decode
import List.Extra as ListE
import List.Nonempty as NEL
import String.Extra as StringE
import UI.Click as Click exposing (Click)
import Url
import Url.Builder exposing (QueryParameter, string)
import Url.Parser


type FQN
    = FQN (NEL.Nonempty String)



-- HELPERS


{-| Turn a string, like "base.List.map" into FQN ["base", "List", "map"]

    Split text into segments. A smarter version of `Text.split` that handles
    the name `.` properly.

-}
fromString : String -> FQN
fromString rawFqn =
    let
        go s =
            case s of
                [] ->
                    []

                "" :: "" :: z ->
                    "." :: go z

                "" :: z ->
                    go z

                x :: y ->
                    x :: go y
    in
    rawFqn
        |> String.split "."
        |> go
        |> fromList


fromList : List String -> FQN
fromList segments_ =
    segments_
        |> List.map String.trim
        |> List.filter (String.isEmpty >> not)
        |> NEL.fromList
        |> Maybe.withDefault (NEL.singleton ".")
        |> FQN


fromUrlString : String -> FQN
fromUrlString str =
    str
        |> String.split "/"
        |> fromUrlList


fromUrlList : List String -> FQN
fromUrlList segments_ =
    let
        urlDecode s =
            -- Let invalid % encoding fall through, since it then must be valid
            -- strings
            Maybe.withDefault s (Url.percentDecode s)
    in
    segments_
        |> List.map (urlDecode >> urlDecodeSegmentDot)
        |> fromList


toString : FQN -> String
toString (FQN nameParts) =
    let
        -- Absolute FQNs start with a dot, so when also
        -- joining parts using a dot, we get dot dot (..),
        -- which we don't want.
        -- TODO: this does mean that we don't support . as a term name on the root...
        trimLeadingDot str =
            if String.startsWith ".." str then
                String.dropLeft 1 str

            else
                str
    in
    nameParts
        |> NEL.toList
        |> String.join "."
        |> trimLeadingDot


toUrlSegments : FQN -> NEL.Nonempty String
toUrlSegments fqn =
    fqn
        |> segments
        |> NEL.map (Url.percentEncode >> urlEncodeSegmentDot)


toQueryString : FQN -> QueryParameter
toQueryString =
    toQueryString_ "name"


{-| This is intended to be used with elm/url's query param builder, which adds
the percentEncoded, which is why we don't do that here
-}
toQueryString_ : String -> FQN -> QueryParameter
toQueryString_ paramName fqn =
    string paramName (toString fqn)


toApiUrlString : FQN -> String
toApiUrlString fqn =
    fqn |> toString |> Url.percentEncode


toUrlString : FQN -> String
toUrlString fqn =
    fqn
        |> toUrlSegments
        |> NEL.toList
        |> String.join "/"


segments : FQN -> NEL.Nonempty String
segments (FQN segments_) =
    segments_


numSegments : FQN -> Int
numSegments (FQN segments_) =
    NEL.length segments_


{-| Drops the last segment of the FQN, unless there's only 1
-}
dropLast : FQN -> FQN
dropLast (FQN segments_) =
    FQN
        (NEL.Nonempty
            (NEL.head segments_)
            (Maybe.withDefault [] (ListE.init (NEL.tail segments_)))
        )


fromParent : FQN -> String -> FQN
fromParent (FQN parentParts) childName =
    FQN (NEL.append parentParts (NEL.fromElement childName))


unqualifiedName : FQN -> String
unqualifiedName (FQN nameParts) =
    NEL.last nameParts


namespace : FQN -> Maybe FQN
namespace (FQN segments_) =
    let
        namespace_ nsSegments =
            case nsSegments of
                [] ->
                    Nothing

                segments__ ->
                    Just (fromList segments__)
    in
    segments_
        |> NEL.toList
        |> ListE.init
        |> Maybe.andThen namespace_


equals : FQN -> FQN -> Bool
equals a b =
    toString a == toString b


append : FQN -> FQN -> FQN
append (FQN a) (FQN b) =
    FQN (NEL.append a b)


{-| Remove the prefix (if present)
-}
stripPrefix : FQN -> FQN -> FQN
stripPrefix (FQN prefix) (FQN fqn_) =
    let
        prefix_ =
            NEL.toList prefix

        fqn__ =
            NEL.toList fqn_

        potentialPrefix =
            List.take (List.length prefix_) fqn__
    in
    if prefix_ == potentialPrefix then
        fromList (List.drop (List.length prefix_) fqn__)

    else
        fromList fqn__


{-| Extend a FQN with another, removing exact overlaps in the right side list.

Examples:

  - extend (FQN "a.b.c") (FQN "a.b.c.d.e.f") -> FQN "ab.c.d.e.f"
  - extend (FQN "a.b.c") (FQN "a.k.e.f") -> FQN "a.b.c.a.k.e.f"
  - extend (FQN "a.b.c") (FQN "e.f") -> FQN "a.b.c.e.f"

-}
extend : FQN -> FQN -> FQN
extend a b =
    b
        |> stripPrefix a
        |> append a


cons : String -> FQN -> FQN
cons s (FQN segments_) =
    FQN (NEL.cons s segments_)


snoc : FQN -> String -> FQN
snoc (FQN segments_) s =
    FQN (NEL.append segments_ (NEL.fromElement s))


{-| This is passed through a string as a suffix name can include
namespaces like List.map (where the FQN would be
base.List.map)
-}
isSuffixOf : FQN -> FQN -> Bool
isSuffixOf suffixName fqn =
    String.endsWith (toString suffixName) (toString fqn)


{-| TODO: We should distinquish between FQN, Namespace and SuffixName on a type
level, or rename the FQN type to Name
-}
namespaceOf : FQN -> FQN -> Maybe String
namespaceOf suffixName fqn =
    let
        dropLastDot s =
            if String.endsWith "." s then
                String.dropRight 1 s

            else
                s
    in
    if isSuffixOf suffixName fqn then
        fqn
            |> toString
            |> String.dropRight (String.length (toString suffixName))
            |> StringE.nonEmpty
            |> Maybe.map dropLastDot

    else
        Nothing



-- VIEW


viewSegment : String -> Html msg
viewSegment seg =
    span [ class "fully-qualified-name_segment" ] [ text seg ]


viewClickableSegment : Click msg -> String -> Html msg
viewClickableSegment click seg =
    Click.view [ class "fully-qualified-name_segment clickable" ] [ text seg ] click


viewSeparator : Html msg
viewSeparator =
    span [ class "fully-qualified-name_separator" ] [ text "." ]


{-| viewClickable
Each FQN segment is clickable.
The `toClick`argument is called with the current segment and all preceeding segments.

Given `FQN "foo.bar.baz"` and "bar" is clicked, the `toClick` is called with `FQN "foo.bar"`.
If "baz" is clicked, `toClick` is called with `FQN "foo.bar.baz"`.

-}
viewClickable : (FQN -> Click msg) -> FQN -> Html msg
viewClickable toClick fqn =
    let
        clickable seg ( prevSegments, clickableSegments ) =
            let
                next =
                    prevSegments ++ [ seg ]
            in
            ( next
            , clickableSegments ++ [ ( toClick (fromList next), seg ) ]
            )
    in
    fqn
        |> segments
        |> NEL.toList
        |> List.foldl clickable ( [], [] )
        |> Tuple.second
        |> List.map (\( c, s ) -> viewClickableSegment c s)
        |> List.intersperse viewSeparator
        |> span [ class "fully-qualified-name" ]


view : FQN -> Html msg
view fqn =
    fqn
        |> segments
        |> NEL.toList
        |> List.map viewSegment
        |> List.intersperse viewSeparator
        |> span [ class "fully-qualified-name" ]



-- PARSERS


urlParser : Url.Parser.Parser (FQN -> a) a
urlParser =
    Url.Parser.custom "FQN" (fromUrlString >> Just)


decodeFromParent : FQN -> Decode.Decoder FQN
decodeFromParent parentFqn =
    Decode.map (fromParent parentFqn) Decode.string


decode : Decode.Decoder FQN
decode =
    Decode.map fromString Decode.string


isValidSegmentChar : Char -> Bool
isValidSegmentChar c =
    let
        validSymbols =
            String.toList "!$%^&*-=+<>.~\\/:_'"
    in
    Char.isAlphaNum c || List.member c validSymbols


isValidUrlSegmentChar : Char -> Bool
isValidUrlSegmentChar c =
    -- '/' is a segment separator in Urls and
    -- should be escaped to %2F, so when
    -- unescaped, its not a valid segment
    -- character when parsing URLs.
    c /= '/' && isValidSegmentChar c



-- INTERNAL HELPERS


{-| URLs can't include a single dot in a path segment like so "base/./docs",
but this is a valid definition name in Unison, the composition operator for
example is named "." To get around this we encode dots as ";." in segments such
that "base...doc" becomes "base/;./doc"
-}
urlEncodeSegmentDot : String -> String
urlEncodeSegmentDot s =
    if s == "." then
        ";."

    else
        s


urlDecodeSegmentDot : String -> String
urlDecodeSegmentDot s =
    if s == ";." then
        "."

    else
        s
