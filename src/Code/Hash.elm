module Code.Hash exposing
    ( Hash
    , decode
    , equals
    , fromString
    , fromUrlString
    , isAbilityConstructorHash
    , isAssumedBuiltin
    , isDataConstructorHash
    , isRawHash
    , prefix
    , stripHashPrefix
    , toApiUrlString
    , toShortString
    , toString
    , toUnprefixedShortString
    , toUrlString
    , unsafeFromString
    , urlParser
    , urlPrefix
    , view
    )

import Html exposing (Html, span, text)
import Html.Attributes exposing (class)
import Json.Decode as Decode
import Lib.Util as Util
import Regex
import UI.Icon as Icon
import Url exposing (percentDecode, percentEncode)
import Url.Parser


type Hash
    = Hash
        { hash : String
        , isAssumedBuiltin : Bool
        , constructorSuffix : Maybe String
        }


equals : Hash -> Hash -> Bool
equals (Hash a) (Hash b) =
    a == b


toString_ : String -> (String -> String) -> Hash -> String
toString_ prefix_ encode (Hash h) =
    let
        p =
            if h.isAssumedBuiltin then
                prefix_ ++ prefix_

            else
                prefix_

        s =
            h.constructorSuffix
                |> Maybe.map (\s_ -> prefix_ ++ encode s_)
                |> Maybe.withDefault ""
    in
    p ++ encode h.hash ++ s


toString : Hash -> String
toString hash_ =
    toString_ prefix identity hash_


{-| Converts a Hash to a shortened (9 characters including the `#` character)
of the raw hash value.

Example:

  - Hash "#cv93ajol371idlcd47do5g3nmj7...4s829ofv57mi19pls3l630" -> "#cv93ajol"

Note, that it does not shorten hashes that are assumed to be builtins:

  - Hash "##Debug.watch" -> "##Debug.watch"
  - Hash "##IO.socketSend.impl" -> "##IO.SocketSend.impl"

-}
toShortString_ : String -> Hash -> String
toShortString_ p h =
    let
        shorten s =
            if isAssumedBuiltin h then
                s

            else
                String.left 9 s
    in
    h |> toString_ p identity |> shorten


toShortString : Hash -> String
toShortString h =
    toShortString_ prefix h


toUnprefixedShortString : Hash -> String
toUnprefixedShortString h =
    toShortString_ "" h


toUrlString : Hash -> String
toUrlString hash_ =
    toString_ urlPrefix percentEncode hash_


toApiUrlString : Hash -> String
toApiUrlString hash_ =
    toString_ apiPrefix percentEncode hash_


{-| Assuming a Hash string, it strips _any number_ of prefixes at the beginning
of the string

Examples:

  - "#abc123def456" -> "abc123def456"
  - "##IO.socketSend.impl" -> "IO.socketSend.impl"

This is often useful when rendering next to a Hash icon.

-}
stripHashPrefix : String -> String
stripHashPrefix s =
    let
        re =
            Maybe.withDefault Regex.never (Regex.fromString "^(#+)")
    in
    Regex.replace re (\_ -> "") s


fromString : String -> Maybe Hash
fromString raw =
    if String.startsWith prefix raw then
        fromString_ raw

    else
        Nothing


fromString_ : String -> Maybe Hash
fromString_ raw =
    let
        -- Checking a hash starts with 2 `#` characters is a weak heuristic for
        -- builtins, but sometimes useful.
        --
        --   * Hash "##IO.socketSend.impl" -> True
        --   * Hash "##Debug.watch" -> True
        --   * Hash "#abc123def456" -> False
        isAssumedBuiltin_ =
            String.startsWith (prefix ++ prefix) raw

        toSegments segments =
            case segments of
                [ h, c ] ->
                    Just ( h, Just c )

                [ h ] ->
                    Just ( h, Nothing )

                _ ->
                    Nothing

        toHash ( hash, constructorSuffix ) =
            Hash
                { isAssumedBuiltin = isAssumedBuiltin_
                , hash = hash
                , constructorSuffix = constructorSuffix
                }
    in
    raw
        |> stripHashPrefix
        |> String.split "#"
        |> List.filter (\s -> String.length s > 0)
        |> toSegments
        |> Maybe.map toHash


{-| !! Don't use this function outside of testing. It provides no guarantees
for the correctness of the Hash.
-}
unsafeFromString : String -> Hash
unsafeFromString raw =
    let
        fallback =
            Hash
                { hash = raw
                , isAssumedBuiltin = False
                , constructorSuffix = Nothing
                }
    in
    raw
        |> fromString_
        |> Maybe.withDefault fallback


isRawHash : String -> Bool
isRawHash str =
    String.startsWith prefix str || String.startsWith urlPrefix str


isAssumedBuiltin : Hash -> Bool
isAssumedBuiltin (Hash h) =
    h.isAssumedBuiltin


fromUrlString : String -> Maybe Hash
fromUrlString str =
    if String.startsWith urlPrefix str then
        str
            |> percentDecode
            |> Maybe.map (String.replace urlPrefix prefix)
            |> Maybe.andThen fromString

    else
        Nothing


prefix : String
prefix =
    "#"


urlPrefix : String
urlPrefix =
    "@"


apiPrefix : String
apiPrefix =
    "@"



-- HELPERS


isDataConstructorHash : Hash -> Bool
isDataConstructorHash hash =
    let
        dataConstructorSuffix =
            Maybe.withDefault Regex.never (Regex.fromString "#d(\\d+)$")
    in
    hash |> toString |> Regex.contains dataConstructorSuffix


isAbilityConstructorHash : Hash -> Bool
isAbilityConstructorHash hash =
    let
        abilityConstructorSuffix =
            Maybe.withDefault Regex.never (Regex.fromString "#a(\\d+)$")
    in
    hash |> toString |> Regex.contains abilityConstructorSuffix



-- VIEW


view : Hash -> Html msg
view hash_ =
    span [ class "hash" ]
        [ Icon.view Icon.hash
        , text (toUnprefixedShortString hash_)
        ]



-- PARSERS


urlParser : Url.Parser.Parser (Hash -> a) a
urlParser =
    Url.Parser.custom "HASH" fromUrlString


decode : Decode.Decoder Hash
decode =
    Decode.map fromString Decode.string
        |> Decode.andThen (Util.decodeFailInvalid "Invalid Hash")
