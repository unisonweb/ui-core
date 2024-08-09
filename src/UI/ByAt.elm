{-
   ByAt
   ====

   A small module to help consistently render when a user did something.

   For example:
     Release 2.1.3 - (H) @hopper 2 days ago
                    ╰──────────┬───────────╯
                    This module renders that
-}


module UI.ByAt exposing (ByAt, byAt, byUnknown, view, withToClick)

import Html exposing (Html, div, span, strong, text)
import Html.Attributes exposing (class)
import Lib.UserHandle as UserHandle exposing (UserHandle)
import Time
import UI.Click as Click exposing (Click)
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


type ByAt u msg
    = ByAt
        { by : By u
        , at : DateTime
        , toClick : Maybe (UserHandle -> Click msg)
        }



-- CREATE


byAt : User u -> DateTime -> ByAt u msg
byAt by at =
    ByAt { by = ByUser by, at = at, toClick = Nothing }


byUnknown : DateTime -> ByAt u msg
byUnknown at =
    ByAt { by = ByUnknown, at = at, toClick = Nothing }



-- MODIFY


withToClick : (UserHandle -> Click msg) -> ByAt u msg -> ByAt u msg
withToClick toClick (ByAt byAt_) =
    ByAt { byAt_ | toClick = Just toClick }



-- VIEW


view : Time.Zone -> DateTime -> ByAt u msg -> Html msg
view zone now (ByAt { by, at, toClick }) =
    let
        ( profileSnippet, click_ ) =
            case by of
                ByUser u ->
                    ( u
                        |> ProfileSnippet.profileSnippet
                        |> ProfileSnippet.small
                        |> ProfileSnippet.view
                    , Maybe.map (\f -> f u.handle) toClick
                    )

                ByHandle h ->
                    ( strong [] [ text (UserHandle.toString h) ], Maybe.map (\f -> f h) toClick )

                ByUnknown ->
                    ( strong [] [ text "Unknown user" ], Nothing )

        attrs =
            [ class "by-at" ]

        content =
            [ profileSnippet
            , span [ class "by-at_at" ]
                [ DateTime.view (DateTime.DistanceFrom now) zone at ]
            ]
    in
    case click_ of
        Nothing ->
            div attrs content

        Just c ->
            Click.view attrs content c
