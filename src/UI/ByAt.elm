{-
   ByAt
   ====

   A small module to help consistently render when a user did something.

   For example:
     Release 2.1.3 - (H) @hopper 2 days ago
                    ╰──────────┬───────────╯
                    This module renders that
-}


module UI.ByAt exposing (ByAt, byAt, byUnknown, handleOnly, view)

import Html exposing (Html, div, em, span, text)
import Html.Attributes exposing (class)
import Lib.UserHandle as UserHandle exposing (UserHandle)
import Time
import UI.DateTime as DateTime exposing (DateTime)
import UI.ProfileSnippet as ProfileSnippet
import Url exposing (Url)


type alias User u =
    { u
        | handle : UserHandle
        , name : Maybe String
        , avatarUrl : Maybe Url
    }


type By u
    = ByUser (User u)
    | ByHandle UserHandle
    | ByUnknown


type ByAt u
    = ByAt (By u) DateTime



-- CREATE


byAt : User u -> DateTime -> ByAt u
byAt =
    ByUser >> ByAt


handleOnly : UserHandle -> DateTime -> ByAt {}
handleOnly handle dateTime =
    ByAt (ByHandle handle) dateTime


byUnknown : DateTime -> ByAt {}
byUnknown dateTime =
    ByAt ByUnknown dateTime



-- VIEW


view : Time.Zone -> DateTime -> ByAt u -> Html msg
view zone now (ByAt by at) =
    let
        profileSnippet =
            case by of
                ByUser u ->
                    u
                        |> ProfileSnippet.profileSnippet
                        |> ProfileSnippet.small
                        |> ProfileSnippet.view

                ByHandle h ->
                    text (UserHandle.toString h)

                ByUnknown ->
                    em [] [ text "Unknown user" ]
    in
    div
        [ class "by-at" ]
        [ profileSnippet
        , span [ class "by-at_at" ]
            [ text (DateTime.toString (DateTime.DistanceFrom now) zone at) ]
        ]
