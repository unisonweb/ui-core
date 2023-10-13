module UI.AppDocument exposing (AppDocument, appDocument, map, view, view_, withAnnouncement)

import Browser exposing (Document)
import Html exposing (Html, div)
import Html.Attributes exposing (class, id)
import Maybe.Extra as MaybeE
import UI
import UI.AppHeader as AppHeader exposing (AppHeader)
import UI.PageHeader as PageHeader exposing (PageHeader)



{-

   AppDocument
   ===========

   Very similar to Browser.Document, but includes a common app title and app
   frame, as well as slots for header, page, and modals.
-}


type alias AppDocument msg =
    { pageId : String
    , title : String
    , announcement : Maybe (Html msg)
    , appHeader : AppHeader msg
    , pageHeader : Maybe (PageHeader msg)
    , page : Html msg
    , modal : Maybe (Html msg)
    }



-- CREATE


appDocument : String -> String -> AppHeader msg -> Html msg -> AppDocument msg
appDocument pageId title appHeader page =
    { pageId = pageId
    , title = title
    , announcement = Nothing
    , appHeader = appHeader
    , pageHeader = Nothing
    , page = page
    , modal = Nothing
    }



-- MAP


map : (msgA -> msgB) -> AppDocument msgA -> AppDocument msgB
map toMsgB { pageId, title, announcement, appHeader, pageHeader, page, modal } =
    { pageId = pageId
    , title = title
    , announcement = Maybe.map (Html.map toMsgB) announcement
    , appHeader = AppHeader.map toMsgB appHeader
    , pageHeader = Maybe.map (PageHeader.map toMsgB) pageHeader
    , page = Html.map toMsgB page
    , modal = Maybe.map (Html.map toMsgB) modal
    }


withAnnouncement : Html msg -> AppDocument msg -> AppDocument msg
withAnnouncement announcement appDoc =
    { appDoc | announcement = Just announcement }



-- VIEW


viewAnnouncement : Html msg -> Html msg
viewAnnouncement content =
    div [ id "announcement" ] [ content ]


view : AppDocument msg -> Document msg
view appDoc =
    view_ appDoc []


view_ : AppDocument msg -> List (Html msg) -> Document msg
view_ { pageId, title, announcement, appHeader, pageHeader, page, modal } extra =
    { title = title ++ " | Unison Share"
    , body =
        div
            [ id "app"
            , class pageId
            ]
            [ MaybeE.unwrap UI.nothing viewAnnouncement announcement
            , AppHeader.view appHeader
            , MaybeE.unwrap UI.nothing PageHeader.view pageHeader
            , page
            , Maybe.withDefault UI.nothing modal
            ]
            :: extra
    }
