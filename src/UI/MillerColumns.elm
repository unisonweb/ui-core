module UI.MillerColumns exposing (..)


type Selection a
    = Node { item : a, children : Column a }
    | Leaf a


type Column a
    = NoSelection (List a)
    | WithSelection
        { before : List a
        , selected : Selection a
        , after : List a
        }
