module UI.Sizing exposing (..)


type Rem
    = Rem Float


times : Int -> Rem -> Rem
times i (Rem r) =
    Rem (toFloat i * r)


multiply : Rem -> Rem -> Rem
multiply (Rem a) (Rem b) =
    Rem (a * b)


add : Rem -> Rem -> Rem
add (Rem a) (Rem b) =
    Rem (a + b)


subtract : Rem -> Rem -> Rem
subtract (Rem a) (Rem b) =
    Rem (a - b)


lt : Rem -> Rem -> Bool
lt (Rem a) (Rem b) =
    a < b


lteq : Rem -> Rem -> Bool
lteq (Rem a) (Rem b) =
    a <= b


gteq : Rem -> Rem -> Bool
gteq (Rem a) (Rem b) =
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
