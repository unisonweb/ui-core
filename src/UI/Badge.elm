module UI.Badge exposing (..)

import UI.Icon as Icon exposing (Icon)


type BadgeColor
    = Plain
    | Black
    | Red
    | Green
    | Yellow
    | Blue
    | Purple


type alias Badge msg =
    { icon : Icon msg
    , label : String
    , color : BadgeColor
    }
