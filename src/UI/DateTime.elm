module UI.DateTime exposing
    ( DateTime
    , DateTimeFormat(..)
    , decode
    , duration
    , dayRange
    , encode
    , fromISO8601
    , fromPosix
    , isAfter
    , isBefore
    , isSameDay
    , longDate
    , millisDiff
    , millisSinceEpoch
    , secondsSinceEpoch
    , shortDate
    , timeStamp
    , toISO8601
    , toPosix
    , toString
    , unsafeFromISO8601
    , view
    , with24HourClock
    , withHideCurrentYear
    , withSeconds
    , withTime
    , withWeekday
    )

import DateFormat
import DateFormat.Relative
import Html exposing (Html, span, text)
import Html.Attributes exposing (class)
import Iso8601
import Json.Decode as Decode
import Json.Encode as Encode
import Time exposing (Posix)
import UI.Tooltip as Tooltip


type DateTime
    = DateTime Posix


type DateTimeFormat
    {- `hideCurrentYear` controls whether the year is omitted when it matches
       the year of `now`. `weekday` prepends an abbreviated weekday name.
       `time` appends the time of day. Build with `shortDate` and customize
       with `withWeekday`/`withTime`/`withHideCurrentYear`.
    -}
    = ShortDate { now : DateTime, weekday : Bool, hideCurrentYear : Bool, time : Bool }
      {- `hideCurrentYear` controls whether the year is omitted when it
         matches the year of `now`. Build with `longDate` and customize with
         `withHideCurrentYear`.
      -}
    | LongDate { now : DateTime, hideCurrentYear : Bool }
    | DistanceFrom DateTime
      {- Build with `timeStamp` and customize with `with24HourClock`/`withSeconds`.
      -}
    | TimeStamp { hours24 : Bool, seconds : Bool }
    | FullDateTime
      {- Formats the date passed to `toString`/`view` as the start of a range
         ending at `end`. `hideCurrentYear` controls whether the year is
         omitted when start and end fall in the same year as `now`. When
         start and end fall in different years, the year is always included
         on both, regardless of `hideCurrentYear`. Build with `dayRange` and
         customize with `withHideCurrentYear`.
      -}
    | DayRange { end : DateTime, now : DateTime, hideCurrentYear : Bool }


shortDate : DateTime -> DateTimeFormat
shortDate now =
    ShortDate { now = now, weekday = False, hideCurrentYear = True, time = False }


longDate : DateTime -> DateTimeFormat
longDate now =
    LongDate { now = now, hideCurrentYear = False }


dayRange : DateTime -> DateTime -> DateTimeFormat
dayRange end now =
    DayRange { end = end, now = now, hideCurrentYear = True }


timeStamp : DateTimeFormat
timeStamp =
    TimeStamp { hours24 = False, seconds = False }


withWeekday : Bool -> DateTimeFormat -> DateTimeFormat
withWeekday weekday format =
    case format of
        ShortDate opts ->
            ShortDate { opts | weekday = weekday }

        _ ->
            format


withTime : Bool -> DateTimeFormat -> DateTimeFormat
withTime time format =
    case format of
        ShortDate opts ->
            ShortDate { opts | time = time }

        _ ->
            format


withHideCurrentYear : Bool -> DateTimeFormat -> DateTimeFormat
withHideCurrentYear hideCurrentYear format =
    case format of
        ShortDate opts ->
            ShortDate { opts | hideCurrentYear = hideCurrentYear }

        LongDate opts ->
            LongDate { opts | hideCurrentYear = hideCurrentYear }

        DayRange opts ->
            DayRange { opts | hideCurrentYear = hideCurrentYear }

        _ ->
            format


with24HourClock : Bool -> DateTimeFormat -> DateTimeFormat
with24HourClock hours24 format =
    case format of
        TimeStamp opts ->
            TimeStamp { opts | hours24 = hours24 }

        _ ->
            format


withSeconds : Bool -> DateTimeFormat -> DateTimeFormat
withSeconds seconds format =
    case format of
        TimeStamp opts ->
            TimeStamp { opts | seconds = seconds }

        _ ->
            format


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
        TimeStamp { hours24, seconds } ->
            let
                hour =
                    if hours24 then
                        DateFormat.hourMilitaryFixed

                    else
                        DateFormat.hourNumber

                secondsPart =
                    if seconds then
                        [ DateFormat.text ":", DateFormat.secondFixed ]

                    else
                        []

                amPmPart =
                    if hours24 then
                        []

                    else
                        [ DateFormat.amPmLowercase ]
            in
            DateFormat.format
                ([ hour, DateFormat.text ":", DateFormat.minuteFixed ]
                    ++ secondsPart
                    ++ amPmPart
                )
                zone
                p

        ShortDate { now, weekday, hideCurrentYear, time } ->
            let
                (DateTime nowPosix) =
                    now

                hideYear =
                    hideCurrentYear && Time.toYear zone p == Time.toYear zone nowPosix

                weekdayPart =
                    if weekday then
                        [ DateFormat.dayOfWeekNameAbbreviated, DateFormat.text ", " ]

                    else
                        []

                yearPart =
                    if hideYear then
                        []

                    else
                        [ DateFormat.text ", ", DateFormat.yearNumber ]

                timePart =
                    if time then
                        [ DateFormat.text ", "
                        , DateFormat.hourNumber
                        , DateFormat.text ":"
                        , DateFormat.minuteFixed
                        , DateFormat.amPmLowercase
                        ]

                    else
                        []
            in
            DateFormat.format
                (weekdayPart
                    ++ [ DateFormat.monthNameAbbreviated, DateFormat.text " ", DateFormat.dayOfMonthNumber ]
                    ++ yearPart
                    ++ timePart
                )
                zone
                p

        LongDate { now, hideCurrentYear } ->
            let
                (DateTime nowPosix) =
                    now

                hideYear =
                    hideCurrentYear && Time.toYear zone p == Time.toYear zone nowPosix

                yearPart =
                    if hideYear then
                        []

                    else
                        [ DateFormat.text ", ", DateFormat.yearNumber ]
            in
            DateFormat.format
                ([ DateFormat.monthNameFull, DateFormat.text " ", DateFormat.dayOfMonthNumber ] ++ yearPart)
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

        DayRange { end, now, hideCurrentYear } ->
            let
                (DateTime endPosix) =
                    end

                (DateTime nowPosix) =
                    now

                monthDay d =
                    DateFormat.format
                        [ DateFormat.monthNameAbbreviated, DateFormat.text " ", DateFormat.dayOfMonthNumber ]
                        zone
                        d

                monthDayYear d =
                    DateFormat.format
                        [ DateFormat.monthNameAbbreviated, DateFormat.text " ", DateFormat.dayOfMonthNumber, DateFormat.text ", ", DateFormat.yearNumber ]
                        zone
                        d

                year d =
                    DateFormat.format [ DateFormat.yearNumber ] zone d

                sameYear =
                    Time.toYear zone p == Time.toYear zone endPosix

                sameMonth =
                    sameYear && Time.toMonth zone p == Time.toMonth zone endPosix

                sameDay =
                    sameMonth && Time.toDay zone p == Time.toDay zone endPosix

                isFutureYear =
                    sameYear && Time.toYear zone p > Time.toYear zone nowPosix

                includeYear =
                    not hideCurrentYear || isFutureYear
            in
            if sameDay then
                if includeYear then
                    monthDayYear p

                else
                    monthDay p

            else if sameMonth then
                if includeYear then
                    monthDay p ++ "–" ++ String.fromInt (Time.toDay zone endPosix) ++ ", " ++ year endPosix

                else
                    monthDay p ++ "–" ++ String.fromInt (Time.toDay zone endPosix)

            else if sameYear then
                if includeYear then
                    monthDay p ++ "–" ++ monthDay endPosix ++ ", " ++ year endPosix

                else
                    monthDay p ++ "–" ++ monthDay endPosix

            else
                monthDayYear p ++ "–" ++ monthDayYear endPosix


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


-- ENCODE


encode : DateTime -> Encode.Value
encode d =
    Encode.string (toISO8601 d)



-- DECODE


decode : Decode.Decoder DateTime
decode =
    Decode.map DateTime Iso8601.decoder



-- VIEW


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
