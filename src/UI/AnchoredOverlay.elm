module UI.AnchoredOverlay exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Lib.OnClickOutside exposing (onClickOutside)


type SheetState msg
    = Closed
    | OpenSheet (Sheet msg)


type Sheet msg
    = DefaultSheet (Html msg)
    | CustomSheet (Html msg)


type alias AnchoredOverlay msg =
    { closeSheetMsg : msg
    , anchor : Html msg
    , sheet : SheetState msg
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
    DefaultSheet content


customSheet : Html msg -> Sheet msg
customSheet content =
    CustomSheet content



-- MAP


mapOverlaySheet : (a -> b) -> SheetState a -> SheetState b
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


withSheet : Html msg -> AnchoredOverlay msg -> AnchoredOverlay msg
withSheet sheet_ anchoredOverlay_ =
    { anchoredOverlay_ | sheet = OpenSheet (DefaultSheet sheet_) }



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
                    let
                        ( sheet__, sheetCls ) =
                            case sheet_ of
                                DefaultSheet s ->
                                    ( s, class "anchored-overlay_sheet_default" )

                                CustomSheet s ->
                                    ( s, class "anchored-overlay_sheet_custom" )
                    in
                    [ onClickOutside
                        anchoredOverlay_.closeSheetMsg
                        (div
                            []
                            [ anchor
                            , div [ class "anchored-overlay_sheet", sheetCls ]
                                [ sheet__ ]
                            ]
                        )
                    ]
    in
    div [ class "anchored-overlay" ] content
