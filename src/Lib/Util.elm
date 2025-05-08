module Lib.Util exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Extra exposing (when)
import Json.Decode.Pipeline exposing (optionalAt)
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


decodeMaybeAt : List String -> Decode.Decoder b -> Decode.Decoder (Maybe b -> c) -> Decode.Decoder c
decodeMaybeAt path decode =
    optionalAt path (Decode.map Just decode) Nothing


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


pipeMaybe : (b -> a -> a) -> Maybe b -> a -> a
pipeMaybe f may a =
    case may of
        Just b ->
            f b a

        Nothing ->
            a


pipeIf : (a -> a) -> Bool -> a -> a
pipeIf f cond a =
    if cond then
        f a

    else
        a


decodeTag : Decode.Decoder String
decodeTag =
    Decode.field "tag" Decode.string


whenTagIs : String -> Decode.Decoder String -> Decode.Decoder String
whenTagIs val =
    whenPathIs [ "tag" ] val


whenPathIs : List String -> String -> Decode.Decoder a -> Decode.Decoder a
whenPathIs path val =
    when (Decode.at path Decode.string) ((==) val)


whenFieldIs : String -> String -> Decode.Decoder a -> Decode.Decoder a
whenFieldIs fieldName val =
    when (Decode.field fieldName Decode.string) ((==) val)


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


ascending : (a -> a -> Order) -> a -> a -> Order
ascending comp a b =
    case comp a b of
        LT ->
            LT

        EQ ->
            EQ

        GT ->
            GT


descending : (a -> a -> Order) -> a -> a -> Order
descending comp a b =
    case comp a b of
        LT ->
            GT

        EQ ->
            EQ

        GT ->
            LT


sortByWith : (x -> a) -> (a -> a -> Order) -> List x -> List x
sortByWith get compare_ list =
    List.sortWith (\x1 x2 -> compare_ (get x1) (get x2)) list
