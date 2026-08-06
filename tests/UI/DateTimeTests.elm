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
        , test "with format ShortDate" <|
            \_ ->
                "2023-08-15T15:00:00.998Z"
                    |> DateTime.fromISO8601
                    |> Maybe.map (DateTime.toString ShortDate Time.utc)
                    |> Expect.equal (Just "Aug 15, 2023")
        , test "with format LongDate" <|
            \_ ->
                "2023-08-15T15:00:00.998Z"
                    |> DateTime.fromISO8601
                    |> Maybe.map (DateTime.toString LongDate Time.utc)
                    |> Expect.equal (Just "August 15, 2023")
        , test "with format TimeWithSeconds24Hour" <|
            \_ ->
                "2023-08-15T15:00:00.998Z"
                    |> DateTime.fromISO8601
                    |> Maybe.map (DateTime.toString TimeWithSeconds24Hour Time.utc)
                    |> Expect.equal (Just "15:00:00")
        , test "with format TimeWithSeconds12Hour" <|
            \_ ->
                "2023-08-15T15:00:00.998Z"
                    |> DateTime.fromISO8601
                    |> Maybe.map (DateTime.toString TimeWithSeconds12Hour Time.utc)
                    |> Expect.equal (Just "3:00:00pm")
        , test "with format ShortWeekdayAndDate" <|
            \_ ->
                "2023-08-15T15:00:00.998Z"
                    |> DateTime.fromISO8601
                    |> Maybe.map (DateTime.toString ShortWeekdayAndDate Time.utc)
                    |> Expect.equal (Just "Tue, Aug 15, 2023")
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


shortDateHideCurrentYear : Test
shortDateHideCurrentYear =
    let
        now =
            DateTime.fromISO8601 "2023-01-01T00:00:00.000Z"

        toShortDateHideCurrentYearString n d =
            Maybe.map2
                (\n_ d_ -> DateTime.toString (ShortDateHideCurrentYear n_) Time.utc d_)
                n
                d
    in
    describe "DateTime.toString with format ShortDateHideCurrentYear"
        [ test "same year as now, omits year" <|
            \_ ->
                "2023-08-15T15:00:00.998Z"
                    |> DateTime.fromISO8601
                    |> toShortDateHideCurrentYearString now
                    |> Expect.equal (Just "Aug 15")
        , test "different year than now, includes year" <|
            \_ ->
                "2022-08-15T15:00:00.998Z"
                    |> DateTime.fromISO8601
                    |> toShortDateHideCurrentYearString now
                    |> Expect.equal (Just "Aug 15, 2022")
        ]


dayRange : Test
dayRange =
    let
        now =
            DateTime.fromISO8601 "2023-01-01T00:00:00.000Z"

        pastNow =
            DateTime.fromISO8601 "2022-01-01T00:00:00.000Z"

        toDayRangeString n showYear s e =
            Maybe.map3
                (\n_ s_ e_ -> DateTime.toString (DayRange e_ showYear n_) Time.utc s_)
                n
                s
                e
    in
    describe "DateTime.toString with format DayRange"
        [ test "same month and year, showYear True" <|
            \_ ->
                let
                    start =
                        DateTime.fromISO8601 "2023-08-15T15:00:00.998Z"

                    end =
                        DateTime.fromISO8601 "2023-08-20T15:00:00.998Z"
                in
                toDayRangeString now True start end
                    |> Expect.equal (Just "Aug 15–20, 2023")
        , test "same year, different month, showYear True" <|
            \_ ->
                let
                    start =
                        DateTime.fromISO8601 "2023-08-15T15:00:00.998Z"

                    end =
                        DateTime.fromISO8601 "2023-09-20T15:00:00.998Z"
                in
                toDayRangeString now True start end
                    |> Expect.equal (Just "Aug 15–Sep 20, 2023")
        , test "different year, showYear True" <|
            \_ ->
                let
                    start =
                        DateTime.fromISO8601 "2023-12-15T15:00:00.998Z"

                    end =
                        DateTime.fromISO8601 "2024-01-05T15:00:00.998Z"
                in
                toDayRangeString now True start end
                    |> Expect.equal (Just "Dec 15, 2023–Jan 5, 2024")
        , test "same start and end date, showYear True" <|
            \_ ->
                let
                    start =
                        DateTime.fromISO8601 "2023-08-15T09:00:00.998Z"

                    end =
                        DateTime.fromISO8601 "2023-08-15T18:00:00.998Z"
                in
                toDayRangeString now True start end
                    |> Expect.equal (Just "Aug 15, 2023")
        , test "same month and year, showYear False, not a future year" <|
            \_ ->
                let
                    start =
                        DateTime.fromISO8601 "2023-08-15T15:00:00.998Z"

                    end =
                        DateTime.fromISO8601 "2023-08-20T15:00:00.998Z"
                in
                toDayRangeString now False start end
                    |> Expect.equal (Just "Aug 15–20")
        , test "same year, different month, showYear False, not a future year" <|
            \_ ->
                let
                    start =
                        DateTime.fromISO8601 "2023-08-15T15:00:00.998Z"

                    end =
                        DateTime.fromISO8601 "2023-09-20T15:00:00.998Z"
                in
                toDayRangeString now False start end
                    |> Expect.equal (Just "Aug 15–Sep 20")
        , test "same start and end date, showYear False, not a future year" <|
            \_ ->
                let
                    start =
                        DateTime.fromISO8601 "2023-08-15T09:00:00.998Z"

                    end =
                        DateTime.fromISO8601 "2023-08-15T18:00:00.998Z"
                in
                toDayRangeString now False start end
                    |> Expect.equal (Just "Aug 15")
        , test "different year, showYear False still shows year on both" <|
            \_ ->
                let
                    start =
                        DateTime.fromISO8601 "2023-12-15T15:00:00.998Z"

                    end =
                        DateTime.fromISO8601 "2024-01-05T15:00:00.998Z"
                in
                toDayRangeString now False start end
                    |> Expect.equal (Just "Dec 15, 2023–Jan 5, 2024")
        , test "same year, showYear False, but year is in the future compared to now" <|
            \_ ->
                let
                    start =
                        DateTime.fromISO8601 "2023-08-15T15:00:00.998Z"

                    end =
                        DateTime.fromISO8601 "2023-08-20T15:00:00.998Z"
                in
                toDayRangeString pastNow False start end
                    |> Expect.equal (Just "Aug 15–20, 2023")
        , test "same start and end date, showYear False, but year is in the future compared to now" <|
            \_ ->
                let
                    start =
                        DateTime.fromISO8601 "2023-08-15T09:00:00.998Z"

                    end =
                        DateTime.fromISO8601 "2023-08-15T18:00:00.998Z"
                in
                toDayRangeString pastNow False start end
                    |> Expect.equal (Just "Aug 15, 2023")
        ]
