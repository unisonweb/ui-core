module Lib.Decode.Helpers exposing (..)

import Json.Decode as Decode
import Json.Decode.Extra exposing (when)
import Json.Decode.Pipeline exposing (optionalAt)
import List.Nonempty as NEL
import Url exposing (Url)


listWithoutFailures : Decode.Decoder a -> Decode.Decoder (List a)
listWithoutFailures decodeA =
    let
        decodeMaybeA =
            Decode.oneOf
                [ decodeA |> Decode.map Just
                , Decode.succeed Nothing
                ]
    in
    Decode.list decodeMaybeA
        |> Decode.map (List.filterMap identity)


maybeAt : List String -> Decode.Decoder b -> Decode.Decoder (Maybe b -> c) -> Decode.Decoder c
maybeAt path decode =
    optionalAt path (Decode.map Just decode) Nothing


nonEmptyList : Decode.Decoder a -> Decode.Decoder (NEL.Nonempty a)
nonEmptyList =
    Decode.list
        >> Decode.andThen
            (\list ->
                case NEL.fromList list of
                    Just nel ->
                        Decode.succeed nel

                    Nothing ->
                        Decode.fail "Decoded an empty list"
            )


failInvalid : String -> Maybe a -> Decode.Decoder a
failInvalid failMessage m =
    case m of
        Nothing ->
            Decode.fail failMessage

        Just a ->
            Decode.succeed a


tag : Decode.Decoder String
tag =
    Decode.field "tag" Decode.string


kind : Decode.Decoder String
kind =
    Decode.field "tag" Decode.string


whenTagIs : String -> Decode.Decoder a -> Decode.Decoder a
whenTagIs val =
    whenPathIs [ "tag" ] val


whenKindIs : String -> Decode.Decoder a -> Decode.Decoder a
whenKindIs val =
    whenPathIs [ "kind" ] val


whenPathIs : List String -> String -> Decode.Decoder a -> Decode.Decoder a
whenPathIs path val =
    when (Decode.at path Decode.string) ((==) val)


whenFieldIs : String -> String -> Decode.Decoder a -> Decode.Decoder a
whenFieldIs fieldName val =
    when (Decode.field fieldName Decode.string) ((==) val)


url : Decode.Decoder Url
url =
    let
        decodeUrl_ s =
            case Url.fromString s of
                Just u ->
                    Decode.succeed u

                Nothing ->
                    Decode.fail "Could not parse as URL"
    in
    Decode.andThen decodeUrl_ Decode.string
