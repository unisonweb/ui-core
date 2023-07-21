module UI.Sizing exposing (..)


type Rem
    = Rem Float


oneRemInPx : Int
oneRemInPx =
    16


toPx : Rem -> Int
toPx (Rem r) =
    floor (r * toFloat oneRemInPx)
