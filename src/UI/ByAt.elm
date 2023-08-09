{-
   ByAt
   ====

   A small module to help consistently render when a user did something.

   For example:
     Release 2.1.3 - @hopper 2 days ago
                    ╰────────┬─────────╯
                  This module renders that
-}


module UI.ByAt exposing (ByAt, byAt, view)

import Html exposing (Html, span, strong, text)
import Html.Attributes exposing (class)
import Html.Keyed as Keyed
import Lib.UserHandle as UserHandle exposing (UserHandle)
import UI.DateTime as DateTime exposing (DateTime)


type ByAt
    = ByAt UserHandle DateTime


byAt : UserHandle -> DateTime -> ByAt
byAt =
    ByAt


view : ByAt -> Html msg
view (ByAt by at) =
    let
        handle =
            UserHandle.toString by
    in
    {-
       Q: Why is this using Keyed?
       A: Since DateTime.view uses a WebComponent under the hood to do the
          distance rendering, Elm freaks out when this page changes after a
          release is published an a runtime error happens. Keyed ensures that
          Elm treats new DOM nodes correctly.
    -}
    Keyed.node "div"
        [ class "by-at" ]
        [ ( handle, strong [] [ text handle ] )
        , ( DateTime.toISO8601 at, span [] [ DateTime.view DateTime.Distance at, text " ago" ] )
        ]
