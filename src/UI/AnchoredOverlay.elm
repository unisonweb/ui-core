module UI.AnchoredOverlay exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Lib.OnClickOutside exposing (onClickOutside)


type Sheet msg
    = Closed
    | OpenSheet (Html msg)


type alias AnchoredOverlay msg =
    { closeSheetMsg : msg
    , anchor : Html msg
    , sheet : Sheet msg
    }



-- CREATE


anchoredOverlay : msg -> Html msg -> AnchoredOverlay msg
anchoredOverlay closeSheetMsg anchor =
    { closeSheetMsg = closeSheetMsg
    , anchor = anchor
    , sheet = Closed
    }


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
    { closeSheetMsg = f anchoredOverlay_.closeSheetMsg
    , anchor = Html.map f anchoredOverlay_.anchor
    , sheet = mapOverlaySheet f anchoredOverlay_.sheet
    }



-- MODIFY


withSheet : Sheet msg -> AnchoredOverlay msg -> AnchoredOverlay msg
withSheet sheet_ anchoredOverlay_ =
    { anchoredOverlay_ | sheet = sheet_ }



-- VIEW


view : AnchoredOverlay msg -> Html msg
view anchoredOverlay_ =
    let
        anchor =
            div [ class "anchored-overlay_anchor" ] [ anchoredOverlay_.anchor ]

        content =
            case anchoredOverlay_.sheet of
                Closed ->
                    [ anchor ]

                OpenSheet sheet_ ->
                    [ anchor
                    , onClickOutside
                        anchoredOverlay_.closeSheetMsg
                        (div [ class "anchored-overlay_sheet" ] [ sheet_ ])
                    ]
    in
    div [ class "anchored-overlay" ] content
