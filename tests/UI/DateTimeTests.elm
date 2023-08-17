module UI.DateTimeTests exposing (..)

import Expect
import Test exposing (..)
import UI.DateTime as DateTime


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
