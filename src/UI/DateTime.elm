module UI.DateTime exposing (..)

import DateFormat
import Iso8601
import Json.Decode as Decode
import Time exposing (Posix)


formatDate : Posix -> String
formatDate t =
    -- TODO should pass in zone
    DateFormat.format "MMM d, YYYY" Time.utc t


decode : Decode.Decoder Posix
decode =
    Iso8601.decoder
