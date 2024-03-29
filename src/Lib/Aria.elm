module Lib.Aria exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (attribute)


role : String -> Attribute msg
role r =
    attribute "role" r


ariaLabel : String -> Attribute msg
ariaLabel l =
    attribute "aria-label" l
