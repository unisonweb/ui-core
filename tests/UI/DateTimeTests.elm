module UI.DateTimeTests exposing (..)

import Expect
import Test exposing (..)
import Time
import UI.DateTime as DateTime exposing (DateTimeFormat(..))


fromString : Test
fromString =
    describe "DateTime.fromISO8601"
        [ test "Creates a DateTime from a valid ISO8601 string" <|
            \_ ->
                "2023-08-15T15:00:00.998Z"
                    |> DateTime.fromISO8601
                    |> Maybe.map DateTime.toISO8601
                    |> Expect.equal (Just "2023-08-15T15:00:00.998Z")
        , test "Fails to create from an invalid string" <|
            \_ ->
                DateTime.fromISO8601 "-----"
                    |> Expect.equal Nothing
        ]


toString : Test
toString =
    describe "DateTime.toString"
        [ test "with format FullDateTime" <|
            \_ ->
                "2023-08-15T15:00:00.998Z"
                    |> DateTime.fromISO8601
                    |> Maybe.map (DateTime.toString FullDateTime Time.utc)
                    |> Expect.equal (Just "Aug 15, 2023 - 15:00:00")
        ]


timeStamp : Test
timeStamp =
    describe "DateTime.toString with format TimeStamp"
        [ test "default: 12 hour, no seconds" <|
            \_ ->
                "2023-08-15T15:00:00.998Z"
                    |> DateTime.fromISO8601
                    |> Maybe.map (DateTime.toString DateTime.timeStamp Time.utc)
                    |> Expect.equal (Just "3:00pm")
        , test "with24HourClock True, no seconds" <|
            \_ ->
                "2023-08-15T15:00:00.998Z"
                    |> DateTime.fromISO8601
                    |> Maybe.map (DateTime.toString (DateTime.timeStamp |> DateTime.with24HourClock True) Time.utc)
                    |> Expect.equal (Just "15:00")
        , test "12 hour, withSeconds True" <|
            \_ ->
                "2023-08-15T15:00:00.998Z"
                    |> DateTime.fromISO8601
                    |> Maybe.map (DateTime.toString (DateTime.timeStamp |> DateTime.withSeconds True) Time.utc)
                    |> Expect.equal (Just "3:00:00pm")
        , test "with24HourClock True, withSeconds True" <|
            \_ ->
                "2023-08-15T15:00:00.998Z"
                    |> DateTime.fromISO8601
                    |> Maybe.map
                        (DateTime.toString
                            (DateTime.timeStamp |> DateTime.with24HourClock True |> DateTime.withSeconds True)
                            Time.utc
                        )
                    |> Expect.equal (Just "15:00:00")
        ]


duration : Test
duration =
    describe "DateTime.duration"
        [ test "returns a duration between 2 datetimes in hours, minutes, and seconds" <|
            \_ ->
                let
                    a =
                        DateTime.fromISO8601 "2023-08-15T15:00:00.998Z"

                    b =
                        DateTime.fromISO8601 "2023-08-15T18:23:12.998Z"
                in
                Maybe.map2 DateTime.duration a b
                    |> Expect.equal (Just { hours = 3, minutes = 23, seconds = 12 })
        ]


shortDate : Test
shortDate =
    let
        now =
            DateTime.unsafeFromISO8601 "2023-01-01T00:00:00.000Z"

        toShortDateString buildFormat d =
            d
                |> DateTime.fromISO8601
                |> Maybe.map (DateTime.toString (buildFormat now) Time.utc)
    in
    describe "DateTime.toString with format ShortDate"
        [ test "same year as now, hides year by default" <|
            \_ ->
                "2023-08-15T15:00:00.998Z"
                    |> toShortDateString DateTime.shortDate
                    |> Expect.equal (Just "Aug 15")
        , test "different year than now, includes year by default" <|
            \_ ->
                "2022-08-15T15:00:00.998Z"
                    |> toShortDateString DateTime.shortDate
                    |> Expect.equal (Just "Aug 15, 2022")
        , test "withHideCurrentYear False always shows the year" <|
            \_ ->
                "2023-08-15T15:00:00.998Z"
                    |> toShortDateString (\n -> DateTime.shortDate n |> DateTime.withHideCurrentYear False)
                    |> Expect.equal (Just "Aug 15, 2023")
        , test "withWeekday True, same year as now" <|
            \_ ->
                "2023-08-15T15:00:00.998Z"
                    |> toShortDateString (\n -> DateTime.shortDate n |> DateTime.withWeekday True)
                    |> Expect.equal (Just "Tue, Aug 15")
        , test "withWeekday True, withHideCurrentYear False" <|
            \_ ->
                "2023-08-15T15:00:00.998Z"
                    |> toShortDateString
                        (\n ->
                            DateTime.shortDate n
                                |> DateTime.withWeekday True
                                |> DateTime.withHideCurrentYear False
                        )
                    |> Expect.equal (Just "Tue, Aug 15, 2023")
        , test "withWeekday True, different year than now" <|
            \_ ->
                "2022-08-15T15:00:00.998Z"
                    |> toShortDateString (\n -> DateTime.shortDate n |> DateTime.withWeekday True)
                    |> Expect.equal (Just "Mon, Aug 15, 2022")
        , test "withTime True" <|
            \_ ->
                "2023-08-15T15:00:00.998Z"
                    |> toShortDateString (\n -> DateTime.shortDate n |> DateTime.withTime True)
                    |> Expect.equal (Just "Aug 15, 3:00pm")
        ]


longDate : Test
longDate =
    let
        now =
            DateTime.unsafeFromISO8601 "2023-01-01T00:00:00.000Z"

        toLongDateString buildFormat d =
            d
                |> DateTime.fromISO8601
                |> Maybe.map (DateTime.toString (buildFormat now) Time.utc)
    in
    describe "DateTime.toString with format LongDate"
        [ test "shows the year by default" <|
            \_ ->
                "2023-08-15T15:00:00.998Z"
                    |> toLongDateString DateTime.longDate
                    |> Expect.equal (Just "August 15, 2023")
        , test "withHideCurrentYear True, same year as now" <|
            \_ ->
                "2023-08-15T15:00:00.998Z"
                    |> toLongDateString (\n -> DateTime.longDate n |> DateTime.withHideCurrentYear True)
                    |> Expect.equal (Just "August 15")
        , test "withHideCurrentYear True, different year than now" <|
            \_ ->
                "2022-08-15T15:00:00.998Z"
                    |> toLongDateString (\n -> DateTime.longDate n |> DateTime.withHideCurrentYear True)
                    |> Expect.equal (Just "August 15, 2022")
        ]


dayRange : Test
dayRange =
    let
        now =
            DateTime.fromISO8601 "2023-01-01T00:00:00.000Z"

        pastNow =
            DateTime.fromISO8601 "2022-01-01T00:00:00.000Z"

        toDayRangeString n hideCurrentYear s e =
            Maybe.map3
                (\n_ s_ e_ ->
                    DateTime.toString
                        (DateTime.dayRange e_ n_ |> DateTime.withHideCurrentYear hideCurrentYear)
                        Time.utc
                        s_
                )
                n
                s
                e
    in
    describe "DateTime.toString with format DayRange"
        [ test "same month and year, withHideCurrentYear False" <|
            \_ ->
                let
                    start =
                        DateTime.fromISO8601 "2023-08-15T15:00:00.998Z"

                    end =
                        DateTime.fromISO8601 "2023-08-20T15:00:00.998Z"
                in
                toDayRangeString now False start end
                    |> Expect.equal (Just "Aug 15–20, 2023")
        , test "same year, different month, withHideCurrentYear False" <|
            \_ ->
                let
                    start =
                        DateTime.fromISO8601 "2023-08-15T15:00:00.998Z"

                    end =
                        DateTime.fromISO8601 "2023-09-20T15:00:00.998Z"
                in
                toDayRangeString now False start end
                    |> Expect.equal (Just "Aug 15–Sep 20, 2023")
        , test "different year, withHideCurrentYear False" <|
            \_ ->
                let
                    start =
                        DateTime.fromISO8601 "2023-12-15T15:00:00.998Z"

                    end =
                        DateTime.fromISO8601 "2024-01-05T15:00:00.998Z"
                in
                toDayRangeString now False start end
                    |> Expect.equal (Just "Dec 15, 2023–Jan 5, 2024")
        , test "same start and end date, withHideCurrentYear False" <|
            \_ ->
                let
                    start =
                        DateTime.fromISO8601 "2023-08-15T09:00:00.998Z"

                    end =
                        DateTime.fromISO8601 "2023-08-15T18:00:00.998Z"
                in
                toDayRangeString now False start end
                    |> Expect.equal (Just "Aug 15, 2023")
        , test "same month and year, withHideCurrentYear True (default), not a future year" <|
            \_ ->
                let
                    start =
                        DateTime.fromISO8601 "2023-08-15T15:00:00.998Z"

                    end =
                        DateTime.fromISO8601 "2023-08-20T15:00:00.998Z"
                in
                toDayRangeString now True start end
                    |> Expect.equal (Just "Aug 15–20")
        , test "same year, different month, withHideCurrentYear True (default), not a future year" <|
            \_ ->
                let
                    start =
                        DateTime.fromISO8601 "2023-08-15T15:00:00.998Z"

                    end =
                        DateTime.fromISO8601 "2023-09-20T15:00:00.998Z"
                in
                toDayRangeString now True start end
                    |> Expect.equal (Just "Aug 15–Sep 20")
        , test "same start and end date, withHideCurrentYear True (default), not a future year" <|
            \_ ->
                let
                    start =
                        DateTime.fromISO8601 "2023-08-15T09:00:00.998Z"

                    end =
                        DateTime.fromISO8601 "2023-08-15T18:00:00.998Z"
                in
                toDayRangeString now True start end
                    |> Expect.equal (Just "Aug 15")
        , test "different year, withHideCurrentYear True still shows year on both" <|
            \_ ->
                let
                    start =
                        DateTime.fromISO8601 "2023-12-15T15:00:00.998Z"

                    end =
                        DateTime.fromISO8601 "2024-01-05T15:00:00.998Z"
                in
                toDayRangeString now True start end
                    |> Expect.equal (Just "Dec 15, 2023–Jan 5, 2024")
        , test "same year, withHideCurrentYear True, but year is in the future compared to now" <|
            \_ ->
                let
                    start =
                        DateTime.fromISO8601 "2023-08-15T15:00:00.998Z"

                    end =
                        DateTime.fromISO8601 "2023-08-20T15:00:00.998Z"
                in
                toDayRangeString pastNow True start end
                    |> Expect.equal (Just "Aug 15–20, 2023")
        , test "same start and end date, withHideCurrentYear True, but year is in the future compared to now" <|
            \_ ->
                let
                    start =
                        DateTime.fromISO8601 "2023-08-15T09:00:00.998Z"

                    end =
                        DateTime.fromISO8601 "2023-08-15T18:00:00.998Z"
                in
                toDayRangeString pastNow True start end
                    |> Expect.equal (Just "Aug 15, 2023")
        ]
