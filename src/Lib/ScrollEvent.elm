module Lib.ScrollEvent exposing (..)

import Json.Decode as Decode exposing (int)
import Json.Decode.Pipeline exposing (requiredAt)


type alias ScrollEvent =
    { scrollHeight : Int
    , scrollLeft : Int
    , scrollTop : Int
    , scrollWidth : Int
    , clientHeight : Int
    , clientLeft : Int
    , clientTop : Int
    , clientWidth : Int
    }


decode : Decode.Decoder ScrollEvent
decode =
    Decode.succeed ScrollEvent
        |> requiredAt [ "currentTarget", "scrollHeight" ] int
        |> requiredAt [ "currentTarget", "scrollLeft" ] int
        |> requiredAt [ "currentTarget", "scrollTop" ] int
        |> requiredAt [ "currentTarget", "scrollWidth" ] int
        |> requiredAt [ "currentTarget", "clientHeight" ] int
        |> requiredAt [ "currentTarget", "clientLeft" ] int
        |> requiredAt [ "currentTarget", "clientTop" ] int
        |> requiredAt [ "currentTarget", "clientWidth" ] int


decodeToMsg : (ScrollEvent -> msg) -> Decode.Decoder msg
decodeToMsg toMsg =
    Decode.map toMsg decode
