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

import DateFormat
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
    | TimeWithSeconds24Hour
    | TimeWithSeconds12Hour
    | FullDateTime


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
        TimeWithSeconds24Hour ->
            DateFormat.format
                [ DateFormat.hourMilitaryFixed
                , DateFormat.text ":"
                , DateFormat.minuteFixed
                , DateFormat.text ":"
                , DateFormat.secondFixed
                ]
                zone
                p

        TimeWithSeconds12Hour ->
            DateFormat.format
                [ DateFormat.hourNumber
                , DateFormat.text ":"
                , DateFormat.minuteFixed
                , DateFormat.text ":"
                , DateFormat.secondFixed
                , DateFormat.text " "
                , DateFormat.amPmLowercase
                ]
                zone
                p

        ShortDate ->
            DateFormat.format
                [ DateFormat.monthNameAbbreviated
                , DateFormat.text " "
                , DateFormat.dayOfMonthNumber
                , DateFormat.text ", "
                , DateFormat.yearNumber
                ]
                zone
                p

        LongDate ->
            DateFormat.format
                [ DateFormat.monthNameFull
                , DateFormat.text " "
                , DateFormat.dayOfMonthNumber
                , DateFormat.text ", "
                , DateFormat.yearNumber
                ]
                zone
                p

        FullDateTime ->
            DateFormat.format
                [ DateFormat.monthNameAbbreviated
                , DateFormat.text " "
                , DateFormat.dayOfMonthNumber
                , DateFormat.text ", "
                , DateFormat.yearNumber
                , DateFormat.text " - "
                , DateFormat.hourMilitaryFixed
                , DateFormat.text ":"
                , DateFormat.minuteFixed
                , DateFormat.text ":"
                , DateFormat.secondFixed
                ]
                zone
                p

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

                _ ->
                    "notSupported"
    in
    node "format-date-time"
        [ attribute "format" (formatToString format) ]
        [ text (toISO8601 d) ]
