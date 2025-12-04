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
                    |> Expect.equal (Just "3:00:00 pm")
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
