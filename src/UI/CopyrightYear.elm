{- Displays the copyright symbol and the current year: "© 2023" -}


module UI.CopyrightYear exposing (..)

import Html exposing (Html, node)


view : Html msg
view =
    node "copyright-year" [] []
