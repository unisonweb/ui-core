module Lib.Util exposing (..)

import Http
import Json.Decode as Decode
import List.Nonempty as NEL
import Process
import Task
import Url exposing (Url)



-- Various utility functions and helpers


{-| A unicode aware string length
-}
unicodeStringLength : String -> Int
unicodeStringLength s =
    s |> String.toList |> List.length


pluralize : String -> String -> Int -> String
pluralize singular plural num =
    if num == 1 then
        singular

    else
        plural


possessive : String -> String
possessive s =
    if String.endsWith "s" s then
        s ++ "'"

    else
        s ++ "'s"


delayMsg : Float -> msg -> Cmd msg
delayMsg delay msg =
    Task.perform (\_ -> msg) (Process.sleep delay)


decodeNonEmptyList : Decode.Decoder a -> Decode.Decoder (NEL.Nonempty a)
decodeNonEmptyList =
    Decode.list
        >> Decode.andThen
            (\list ->
                case NEL.fromList list of
                    Just nel ->
                        Decode.succeed nel

                    Nothing ->
                        Decode.fail "Decoded an empty list"
            )


decodeFailInvalid : String -> Maybe a -> Decode.Decoder a
decodeFailInvalid failMessage m =
    case m of
        Nothing ->
            Decode.fail failMessage

        Just a ->
            Decode.succeed a


decodeTag : Decode.Decoder String
decodeTag =
    Decode.field "tag" Decode.string


decodeUrl : Decode.Decoder Url
decodeUrl =
    let
        decodeUrl_ s =
            case Url.fromString s of
                Just u ->
                    Decode.succeed u

                Nothing ->
                    Decode.fail "Could not parse as URL"
    in
    Decode.andThen decodeUrl_ Decode.string


httpErrorToString : Http.Error -> String
httpErrorToString err =
    case err of
        Http.Timeout ->
            "Timeout exceeded"

        Http.NetworkError ->
            "Network error"

        Http.BadStatus status ->
            "Bad status: " ++ String.fromInt status

        Http.BadBody text ->
            "Unexpected response from api: " ++ text

        Http.BadUrl url ->
            "Malformed url: " ++ url
