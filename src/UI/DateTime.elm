module UI.DateTime exposing
    ( DateTime
    , decode
    , formatDate
    , fromPosix
    )

import DateFormat
import Iso8601
import Json.Decode as Decode
import Time exposing (Posix)


type DateTime
    = DateTime Posix


fromPosix : Posix -> DateTime
fromPosix p =
    DateTime p


formatDate : DateTime -> String
formatDate (DateTime t) =
    -- TODO should pass in zone
    DateFormat.format "MMM d, yyyy" Time.utc t


decode : Decode.Decoder DateTime
decode =
    Decode.map DateTime Iso8601.decoder
