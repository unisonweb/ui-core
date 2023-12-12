module UI.AnchoredOverlay exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Lib.OnClickOutside exposing (onClickOutside)
import UI.ModalOverlay exposing (modalOverlay)


type SheetState msg
    = Closed
    | OpenSheet (Sheet msg)


type Sheet msg
    = DefaultSheet (Html msg)
    | CustomSheet (Html msg)


type Position
    = BottomLeft
    | BottomRight


type alias AnchoredOverlay msg =
    { closeSheetMsg : msg
    , anchor : Html msg
    , sheet : SheetState msg
    , sheetPosition : Position
    }



-- CREATE


anchoredOverlay : msg -> Html msg -> AnchoredOverlay msg
anchoredOverlay closeSheetMsg anchor =
    { closeSheetMsg = closeSheetMsg
    , anchor = anchor
    , sheet = Closed
    , sheetPosition = BottomRight
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

        OpenSheet (DefaultSheet content) ->
            OpenSheet (DefaultSheet (Html.map f content))

        OpenSheet (CustomSheet content) ->
            OpenSheet (CustomSheet (Html.map f content))


map : (a -> b) -> AnchoredOverlay a -> AnchoredOverlay b
map f anchoredOverlay_ =
    { closeSheetMsg = f anchoredOverlay_.closeSheetMsg
    , anchor = Html.map f anchoredOverlay_.anchor
    , sheet = mapOverlaySheet f anchoredOverlay_.sheet
    , sheetPosition = anchoredOverlay_.sheetPosition
    }



-- MODIFY


withSheet : Sheet msg -> AnchoredOverlay msg -> AnchoredOverlay msg
withSheet sheet_ anchoredOverlay_ =
    { anchoredOverlay_ | sheet = OpenSheet sheet_ }


withSheet_ : Bool -> Sheet msg -> AnchoredOverlay msg -> AnchoredOverlay msg
withSheet_ isOpen sheet_ anchoredOverlay_ =
    if isOpen then
        { anchoredOverlay_ | sheet = OpenSheet sheet_ }

    else
        { anchoredOverlay_ | sheet = Closed }


withSheetPosition : Position -> AnchoredOverlay msg -> AnchoredOverlay msg
withSheetPosition position anchoredOverlay_ =
    { anchoredOverlay_ | sheetPosition = position }



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
                        positionCls =
                            case anchoredOverlay_.sheetPosition of
                                BottomLeft ->
                                    class "anchored-overlay_sheet_position_bottom-left"

                                BottomRight ->
                                    class "anchored-overlay_sheet_position_bottom-right"

                        ( sheet__, sheetCls ) =
                            case sheet_ of
                                DefaultSheet s ->
                                    ( s, class "anchored-overlay_sheet_default" )

                                CustomSheet s ->
                                    ( s, class "anchored-overlay_sheet_custom" )
                    in
                    -- TODO: onClickOutside should be inside of modalOverlay...
                    [ onClickOutside
                        anchoredOverlay_.closeSheetMsg
                        (modalOverlay (Just anchoredOverlay_.closeSheetMsg)
                            (div
                                []
                                [ anchor
                                , div [ class "anchored-overlay_sheet", sheetCls, positionCls ]
                                    [ sheet__ ]
                                ]
                            )
                        )
                    ]
    in
    div [ class "anchored-overlay" ] content
