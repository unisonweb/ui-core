module UI.Modal exposing
    ( Content(..)
    , Modal
    , confirm
    , content
    , customContent
    , map
    , modal
    , modal_
    , view
    , withAccept
    , withActions
    , withActionsIf
    , withAttributes
    , withDimOverlay
    , withHeader
    , withHeaderIf
    , withLeftSideFooter
    )

import Html exposing (Attribute, Html, a, div, footer, h2, header, section, text)
import Html.Attributes as Attributes exposing (class, classList, id, tabindex)
import Html.Events exposing (onClick)
import Lib.OnClickOutside exposing (onClickOutside)
import UI
import UI.Button as Button exposing (Button)
import UI.Icon as Icon
import UI.ModalOverlay exposing (modalOverlay)


type Content msg
    = Content (Html msg)
    | CustomContent (Html msg)


type alias Modal msg =
    { id : String
    , closeMsg : Maybe msg
    , acceptMsg : Maybe msg
    , attributes : List (Attribute msg)
    , header : Maybe (Html msg)
    , footer :
        { leftSide : List (Html msg)
        , actions : List (Button msg)
        }
    , content : Content msg
    , dimOverlay : Bool
    }



-- CREATE


modal : String -> msg -> Content msg -> Modal msg
modal id closeMsg content_ =
    modal_ id content_ |> withClose closeMsg


modal_ : String -> Content msg -> Modal msg
modal_ id content_ =
    { id = id
    , closeMsg = Nothing
    , acceptMsg = Nothing
    , attributes = []
    , header = Nothing
    , footer = { leftSide = [], actions = [] }
    , content = content_
    , dimOverlay = False
    }


content : Html msg -> Content msg
content =
    Content


customContent : Html msg -> Content msg
customContent =
    CustomContent


{-| Create a confirmation modal with a short message, a cancel and a confirm button
-}
confirm : String -> msg -> msg -> Modal msg
confirm message cancelMsg confirmMsg =
    content (text message)
        |> modal "confirmation-modal" cancelMsg
        |> withActions
            [ Button.button cancelMsg "Cancel"
                |> Button.subdued
            , Button.button confirmMsg "Confirm"
                |> Button.critical
            ]



-- MAP


mapContent : (a -> b) -> Content a -> Content b
mapContent f content_ =
    case content_ of
        Content h ->
            Content (Html.map f h)

        CustomContent h ->
            CustomContent (Html.map f h)


map : (a -> b) -> Modal a -> Modal b
map f m =
    { id = m.id
    , closeMsg = Maybe.map f m.closeMsg
    , acceptMsg = Maybe.map f m.acceptMsg
    , attributes = List.map (Attributes.map f) m.attributes
    , header = Maybe.map (Html.map f) m.header
    , footer =
        { leftSide = List.map (Html.map f) m.footer.leftSide
        , actions = List.map (Button.map f) m.footer.actions
        }
    , content = mapContent f m.content
    , dimOverlay = m.dimOverlay
    }



-- MODIFY


withClose : msg -> Modal msg -> Modal msg
withClose closeMsg modal__ =
    { modal__ | closeMsg = Just closeMsg }


withAccept : msg -> Modal msg -> Modal msg
withAccept acceptMsg modal__ =
    { modal__ | acceptMsg = Just acceptMsg }


withHeader : String -> Modal msg -> Modal msg
withHeader title modal__ =
    { modal__ | header = Just (text title) }


withHeaderIf : String -> Bool -> Modal msg -> Modal msg
withHeaderIf title showHeader modal__ =
    if showHeader then
        { modal__ | header = Just (text title) }

    else
        modal__


withLeftSideFooter : List (Html msg) -> Modal msg -> Modal msg
withLeftSideFooter leftSide modal__ =
    let
        footer_ =
            modal__.footer
    in
    { modal__ | footer = { footer_ | leftSide = leftSide } }


withDimOverlay : Bool -> Modal msg -> Modal msg
withDimOverlay dimOverlay_ modal__ =
    { modal__ | dimOverlay = dimOverlay_ }


withActions : List (Button msg) -> Modal msg -> Modal msg
withActions actions modal__ =
    let
        footer_ =
            modal__.footer
    in
    { modal__ | footer = { footer_ | actions = actions } }


withActionsIf : List (Button msg) -> Bool -> Modal msg -> Modal msg
withActionsIf actions showActions modal__ =
    if showActions then
        let
            footer_ =
                modal__.footer
        in
        { modal__ | footer = { footer_ | actions = actions } }

    else
        modal__


withAttributes : List (Attribute msg) -> Modal msg -> Modal msg
withAttributes attrs modal__ =
    { modal__ | attributes = modal__.attributes ++ attrs }



-- VIEW


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

        footer_ =
            if List.isEmpty modal__.footer.actions && List.isEmpty modal__.footer.leftSide then
                UI.nothing

            else
                footer [ class "modal-footer" ]
                    [ div [ class "modal-footer_left-side" ]
                        modal__.footer.leftSide
                    , div
                        [ class "modal-footer_actions" ]
                        (List.map Button.view modal__.footer.actions)
                    ]

        content_ =
            case modal__.content of
                Content c ->
                    section [ class "modal-content" ] [ c ]

                CustomContent c ->
                    c
    in
    view_
        modal__.closeMsg
        modal__.acceptMsg
        (id modal__.id
            :: classList [ ( "modal_dim-overlay", modal__.dimOverlay ) ]
            :: modal__.attributes
        )
        [ header_, content_, footer_ ]



-- INTERNALS


view_ : Maybe msg -> Maybe msg -> List (Attribute msg) -> List (Html msg) -> Html msg
view_ closeMsg acceptMsg attrs content_ =
    let
        ( modalContent, onEsc ) =
            case closeMsg of
                Just closeMsg_ ->
                    ( div [ id overlayId ]
                        [ onClickOutside closeMsg_
                            (div (tabindex 0 :: class "modal" :: attrs)
                                content_
                            )
                        ]
                    , Just closeMsg_
                    )

                Nothing ->
                    ( div [ id overlayId ]
                        [ div (tabindex 0 :: class "modal" :: attrs) content_
                        ]
                    , Nothing
                    )
    in
    modalOverlay onEsc acceptMsg modalContent


overlayId : String
overlayId =
    "modal-overlay"
