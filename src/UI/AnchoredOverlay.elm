module UI.AnchoredOverlay exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Lib.OnClickOutside exposing (onClickOutside)


type Sheet msg
    = Closed
    | OpenSheet (Html msg)


type alias AnchoredOverlay msg =
    { anchor : Html msg
    , sheet : Sheet msg
    }



-- CREATE


sheet : Html msg -> Sheet msg
sheet content =
    OpenSheet content



-- MAP


mapOverlaySheet : (a -> b) -> Sheet a -> Sheet b
mapOverlaySheet f sheet_ =
    case sheet_ of
        Closed ->
            Closed

        OpenSheet content ->
            OpenSheet (Html.map f content)


map : (a -> b) -> AnchoredOverlay a -> AnchoredOverlay b
map f anchoredOverlay_ =
    { anchor = Html.map f anchoredOverlay_.anchor
    , sheet = mapOverlaySheet f anchoredOverlay_.sheet
    }



-- MODIFY


withSheet : Sheet msg -> AnchoredOverlay msg -> AnchoredOverlay msg
withSheet sheet_ anchoredOverlay_ =
    { anchoredOverlay_ | sheet = sheet_ }



-- VIEW


view : msg -> AnchoredOverlay msg -> Html msg
view closeSheetMsg anchoredOverlay_ =
    let
        content =
            case anchoredOverlay_.sheet of
                Closed ->
                    [ anchoredOverlay_.anchor ]

                OpenSheet sheet_ ->
                    [ anchoredOverlay_.anchor
                    , onClickOutside
                        closeSheetMsg
                        (div [ class "anchored-overlay_sheet" ] [ sheet_ ])
                    ]
    in
    div [ class "anchored-overlay" ] content
