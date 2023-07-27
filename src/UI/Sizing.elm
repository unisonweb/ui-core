module UI.Sizing exposing (..)


type Rem
    = Rem Float


lt : Rem -> Rem -> Bool
lt (Rem a) (Rem b) =
    a < b


le : Rem -> Rem -> Bool
le (Rem a) (Rem b) =
    a <= b


ge : Rem -> Rem -> Bool
ge (Rem a) (Rem b) =
    a >= b


gt : Rem -> Rem -> Bool
gt (Rem a) (Rem b) =
    a > b


equals : Rem -> Rem -> Bool
equals (Rem a) (Rem b) =
    a == b


fromPx : Int -> Rem
fromPx px =
    Rem (toFloat oneRemInPx / toFloat px)


oneRemInPx : Int
oneRemInPx =
    16


toPx : Rem -> Int
toPx (Rem r) =
    floor (r * toFloat oneRemInPx)
