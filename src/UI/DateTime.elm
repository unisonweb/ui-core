-- Include ui/FormatDateTime.js in the bundle to be able to call DateTime.view


module UI.DateTime exposing
    ( DateTime
    , DateTimeFormat(..)
    , decode
    , fromISO8601
    , fromPosix
    , isSameDay
    , millisSinceEpoch
    , secondsSinceEpoch
    , toISO8601
    , toPosix
    , toString
    , unsafeFromISO8601
    , view
    )

import Html exposing (Html, node, text)
import Html.Attributes exposing (attribute)
import Iso8601
import Json.Decode as Decode
import Time exposing (Posix)


type DateTime
    = DateTime Posix


type DateTimeFormat
    = ShortDate
    | LongDate
    | Distance
    | TimeWithSeconds


isSameDay : Time.Zone -> DateTime -> DateTime -> Bool
isSameDay zone (DateTime a) (DateTime b) =
    Time.toDay zone a == Time.toDay zone b && Time.toMonth zone a == Time.toMonth zone b && Time.toYear zone a == Time.toYear zone b


fromPosix : Posix -> DateTime
fromPosix p =
    DateTime p


toPosix : DateTime -> Posix
toPosix (DateTime p) =
    p


millisSinceEpoch : DateTime -> Int
millisSinceEpoch (DateTime p) =
    Time.posixToMillis p


secondsSinceEpoch : DateTime -> Int
secondsSinceEpoch d =
    millisSinceEpoch d // 1000


decode : Decode.Decoder DateTime
decode =
    Decode.map DateTime Iso8601.decoder


fromISO8601 : String -> Maybe DateTime
fromISO8601 s =
    s
        |> Iso8601.toTime
        |> Result.map DateTime
        |> Result.toMaybe


{-| !! Don't use outside of testing !!
-}
unsafeFromISO8601 : String -> DateTime
unsafeFromISO8601 s =
    let
        fallbackDateTime =
            fromPosix (Time.millisToPosix 1)
    in
    s
        |> fromISO8601
        |> Maybe.withDefault fallbackDateTime


toISO8601 : DateTime -> String
toISO8601 (DateTime t) =
    Iso8601.fromTime t


toString : DateTimeFormat -> Time.Zone -> DateTime -> String
toString format zone (DateTime p) =
    case format of
        TimeWithSeconds ->
            [ Time.toHour zone p
            , Time.toMinute zone p
            , Time.toSecond zone p
            ]
                |> List.map String.fromInt
                |> String.join ":"

        _ ->
            ""


{-| Note: requires the web component ui/FormatDateTime.js to
be part of the bundle
-}
view : DateTimeFormat -> DateTime -> Html msg
view format d =
    let
        formatToString f =
            case f of
                ShortDate ->
                    "shortDate"

                LongDate ->
                    "longDate"

                Distance ->
                    "distance"

                TimeWithSeconds ->
                    "timeWithSeconds"
    in
    node "format-date-time"
        [ attribute "format" (formatToString format) ]
        [ text (toISO8601 d) ]
