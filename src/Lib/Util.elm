module Lib.Util exposing (..)

import Html exposing (Attribute, Html)
import Html.Attributes
import Http
import Json.Decode as Decode
import List.Nonempty as NEL
import Process
import Task
import Url exposing (Url)



-- Various utility functions and helpers


col : List (Attribute msg) -> List (Html msg) -> Html msg
col attrs children =
    Html.div (Html.Attributes.class "col" :: attrs) children


possessive : String -> String
possessive s =
    if String.endsWith "s" s then
        s ++ "'"

    else
        s ++ "'s"


delayMsg : Float -> msg -> Cmd msg
delayMsg delay msg =
    Task.perform (\_ -> msg) (Process.sleep delay)


{-| Sometimes requests don't have a response body, this turns the body into Unit
-}
decodeEmptyBody : Decode.Decoder ()
decodeEmptyBody =
    Decode.succeed ()


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
