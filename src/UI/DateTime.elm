-- Include ui/FormatDateTime.js in the bundle to be able to call DateTime.view


module UI.DateTime exposing
    ( DateTime
    , DateTimeFormat(..)
    , decode
    , fromPosix
    , fromString
    , isSameDay
    , toISO8601
    , toPosix
    , view
    )

import Html exposing (Html, node, text)
import Html.Attributes exposing (attribute)
import Iso8601
import Json.Decode as Decode
import Time exposing (Posix)
import Time.Extra as TimeE


type DateTime
    = DateTime Posix


type DateTimeFormat
    = ShortDate
    | LongDate
    | Distance
    | TimeWithSeconds


{-| TODO: Refactor this, and make a decision if this module should exist or
not, perhaps it should just be a posix alias...
-}
isSameDay : Time.Zone -> DateTime -> DateTime -> Bool
isSameDay zone (DateTime a) (DateTime b) =
    TimeE.diff TimeE.Day zone a b == 0


fromPosix : Posix -> DateTime
fromPosix p =
    DateTime p


toPosix : DateTime -> Posix
toPosix (DateTime p) =
    p


decode : Decode.Decoder DateTime
decode =
    Decode.map DateTime Iso8601.decoder


fromString : String -> Maybe DateTime
fromString s =
    s
        |> Decode.decodeString decode
        |> Result.toMaybe


toISO8601 : DateTime -> String
toISO8601 (DateTime t) =
    Iso8601.fromTime t


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
