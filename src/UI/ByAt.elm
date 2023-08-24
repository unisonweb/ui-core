{-
   ByAt
   ====

   A small module to help consistently render when a user did something.

   For example:
     Release 2.1.3 - (H) @hopper 2 days ago
                    ╰──────────┬───────────╯
                    This module renders that
-}


module UI.ByAt exposing (ByAt, byAt, handleOnly, view)

import Html exposing (Html, span, text)
import Html.Attributes exposing (class)
import Html.Keyed as Keyed
import Lib.UserHandle as UserHandle exposing (UserHandle)
import UI.DateTime as DateTime exposing (DateTime)
import UI.ProfileSnippet as ProfileSnippet
import Url exposing (Url)


type alias User u =
    { u
        | handle : UserHandle
        , name : Maybe String
        , avatarUrl : Maybe Url
    }


type ByAt u
    = ByAt (User u) DateTime



-- CREATE


byAt : User u -> DateTime -> ByAt u
byAt =
    ByAt


handleOnly : UserHandle -> DateTime -> ByAt {}
handleOnly handle dateTime =
    ByAt { handle = handle, name = Nothing, avatarUrl = Nothing } dateTime



-- VIEW


view : ByAt u -> Html msg
view (ByAt by at) =
    let
        handle =
            UserHandle.toString by.handle

        profileSnippet =
            by
                |> ProfileSnippet.profileSnippet
                |> ProfileSnippet.small
                |> ProfileSnippet.view

        by_ =
            ( handle, profileSnippet )
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
        [ by_
        , ( DateTime.toISO8601 at, span [] [ DateTime.view DateTime.Distance at, text " ago" ] )
        ]
