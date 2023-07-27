module UI.Sizing exposing (..)


type Rem
    = Rem Float


fromPx : Int -> Rem
fromPx px =
    Rem (toFloat oneRemInPx / toFloat px)


oneRemInPx : Int
oneRemInPx =
    16


toPx : Rem -> Int
toPx (Rem r) =
    floor (r * toFloat oneRemInPx)
