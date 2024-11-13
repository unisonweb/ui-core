module UI.Switch exposing (..)

import UI.Icon as Icon exposing (Icon)


type SwitchState
    = Left
    | Right


type alias Switch msg =
    { state : SwitchState
    , iconLeft : Maybe (Icon msg)
    , iconRight : Maybe (Icon msg)
    }
