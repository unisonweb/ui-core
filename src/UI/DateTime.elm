-- Include ui/FormatDateTime.js in the bundle to be able to call DateTime.view


module UI.DateTime exposing
    ( DateTime
    , DateTimeFormat(..)
    , decode
    , fromPosix
    , fromString
    , toISO8601
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


fromPosix : Posix -> DateTime
fromPosix p =
    DateTime p


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
