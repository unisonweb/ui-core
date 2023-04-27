module UI.Modal exposing
    ( Content(..)
    , Modal
    , content
    , customContent
    , modal
    , modal_
    , view
    , withAttributes
    , withHeader
    )

import Html exposing (Attribute, Html, a, div, h2, header, section, text)
import Html.Attributes exposing (class, id, tabindex)
import Html.Events exposing (on, onClick)
import Json.Decode as Decode
import UI
import UI.Icon as Icon


type Content msg
    = Content (Html msg)
    | CustomContent (Html msg)


type alias Modal msg =
    { id : String
    , closeMsg : Maybe msg
    , attributes : List (Attribute msg)
    , header : Maybe (Html msg)
    , content : Content msg
    }


modal : String -> msg -> Content msg -> Modal msg
modal id closeMsg content_ =
    modal_ id content_ |> withClose closeMsg


modal_ : String -> Content msg -> Modal msg
modal_ id content_ =
    { id = id
    , closeMsg = Nothing
    , attributes = []
    , header = Nothing
    , content = content_
    }


content : Html msg -> Content msg
content =
    Content


customContent : Html msg -> Content msg
customContent =
    CustomContent


withClose : msg -> Modal msg -> Modal msg
withClose closeMsg modal__ =
    { modal__ | closeMsg = Just closeMsg }


withHeader : String -> Modal msg -> Modal msg
withHeader title modal__ =
    { modal__ | header = Just (text title) }


withAttributes : List (Attribute msg) -> Modal msg -> Modal msg
withAttributes attrs modal__ =
    { modal__ | attributes = modal__.attributes ++ attrs }


view : Modal msg -> Html msg
view modal__ =
    let
        header_ =
            modal__.header
                |> Maybe.map
                    (\title ->
                        header [ class "modal-header" ]
                            [ h2 [] [ title ]
                            , modal__.closeMsg
                                |> Maybe.map
                                    (\msg ->
                                        a [ class "close-modal", onClick msg ]
                                            [ Icon.view Icon.x ]
                                    )
                                |> Maybe.withDefault UI.nothing
                            ]
                    )
                |> Maybe.withDefault UI.nothing

        content_ =
            case modal__.content of
                Content c ->
                    section [ class "modal-content" ] [ c ]

                CustomContent c ->
                    c
    in
    view_ modal__.closeMsg (id modal__.id :: modal__.attributes) [ header_, content_ ]



-- INTERNALS


view_ : Maybe msg -> List (Attribute msg) -> List (Html msg) -> Html msg
view_ closeMsg attrs content_ =
    case closeMsg of
        Just closeMsg_ ->
            div [ id overlayId, on "click" (decodeOverlayClick closeMsg_) ]
                [ div (tabindex 0 :: class "modal" :: attrs) content_
                ]

        Nothing ->
            div [ id overlayId ]
                [ div (tabindex 0 :: class "modal" :: attrs) content_
                ]


overlayId : String
overlayId =
    "modal-overlay"


decodeOverlayClick : msg -> Decode.Decoder msg
decodeOverlayClick closeMsg =
    Decode.at [ "target", "id" ] Decode.string
        |> Decode.andThen
            (\c ->
                if String.contains overlayId c then
                    Decode.succeed closeMsg

                else
                    Decode.fail "ignoring"
            )
