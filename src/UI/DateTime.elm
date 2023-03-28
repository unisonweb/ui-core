module UI.DateTime exposing (DateTime, DateTimeFormat(..), decode, fromPosix, view)

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


fromPosix : Posix -> DateTime
fromPosix p =
    DateTime p


decode : Decode.Decoder DateTime
decode =
    Decode.map DateTime Iso8601.decoder


toISO8601 : DateTime -> String
toISO8601 (DateTime t) =
    Iso8601.fromTime t


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
    in
    node "format-date-time"
        [ attribute "format" (formatToString format) ]
        [ text (toISO8601 d) ]
