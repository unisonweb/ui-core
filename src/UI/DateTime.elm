module UI.DateTime exposing
    ( DateTime
    , DateTimeFormat(..)
    , decode
    , duration
    , fromISO8601
    , fromPosix
    , isAfter
    , isBefore
    , isSameDay
    , millisDiff
    , millisSinceEpoch
    , secondsSinceEpoch
    , toISO8601
    , toPosix
    , toString
    , unsafeFromISO8601
    , view
    )

import DateFormat
import DateFormat.Relative
import Html exposing (Html, span, text)
import Html.Attributes exposing (class)
import Iso8601
import Json.Decode as Decode
import Time exposing (Posix)
import UI.Tooltip as Tooltip


type DateTime
    = DateTime Posix


type DateTimeFormat
    = ShortDate
    | LongDate
    | DistanceFrom DateTime
    | TimeWithSeconds24Hour
    | TimeWithSeconds12Hour
    | FullDateTime


isSameDay : Time.Zone -> DateTime -> DateTime -> Bool
isSameDay zone (DateTime a) (DateTime b) =
    Time.toDay zone a == Time.toDay zone b && Time.toMonth zone a == Time.toMonth zone b && Time.toYear zone a == Time.toYear zone b


{-| is `b` (second arg) after `a` (first arg)
-}
isAfter : DateTime -> DateTime -> Bool
isAfter a b =
    millisSinceEpoch a < millisSinceEpoch b


{-| is `b` (second arg) before `a` (first arg)
-}
isBefore : DateTime -> DateTime -> Bool
isBefore a b =
    millisSinceEpoch a > millisSinceEpoch b


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


{-| TODO: This is kind of silly, but zone isn't needed for DistanceFrom', so maybe it
should be inside the format instead of a param. Changing that will not work
with the webcomponent. When the webcomponent can be deprecated, we can move to
that
-}
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

        DistanceFrom (DateTime from) ->
            DateFormat.Relative.relativeTime from p


{-| the diff between a and b in milliseconds
-}
millisDiff : DateTime -> DateTime -> Int
millisDiff a b =
    let
        a_ =
            millisSinceEpoch a

        b_ =
            millisSinceEpoch b
    in
    b_ - a_


type alias Duration =
    { hours : Int
    , minutes : Int
    , seconds : Int
    }


{-| the duration between a and b in an hours, minutes, and seconds
-}
duration : DateTime -> DateTime -> Duration
duration start end =
    let
        diff =
            millisDiff start end

        -- Convert to seconds
        totalSeconds =
            diff // 1000

        -- Calculate hours, minutes, seconds
        hours =
            totalSeconds // 3600

        minutes =
            modBy 3600 totalSeconds // 60

        seconds =
            modBy 60 totalSeconds
    in
    { hours = hours
    , minutes = minutes
    , seconds = seconds
    }


view : DateTimeFormat -> Time.Zone -> DateTime -> Html msg
view format zone d =
    let
        viewed =
            span [ class "date-time" ] [ text (toString format zone d) ]
    in
    case format of
        DistanceFrom _ ->
            Tooltip.text (toString FullDateTime zone d)
                |> Tooltip.tooltip
                |> Tooltip.view viewed

        _ ->
            viewed
