module UI.Tag exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Maybe.Extra as MaybeE
import UI
import UI.Click as Click exposing (Click)
import UI.Icon as Icon exposing (Icon)


type TagAction msg
    = NoAction
    | TagClick (Click msg)
    | DismissLeft (Click msg)
    | DismissRight (Click msg)


type alias Tag msg =
    { icon : Maybe (Icon msg)
    , leftText : Maybe String
    , text : String
    , rightText : Maybe String
    , action : TagAction msg
    }



-- CREATE


tag : String -> Tag msg
tag text_ =
    { icon = Nothing
    , leftText = Nothing
    , text = text_
    , rightText = Nothing
    , action = NoAction
    }



-- MODIFY


withClick : Click msg -> Tag msg -> Tag msg
withClick click t =
    { t | action = TagClick click }


withDismissLeft : Click msg -> Tag msg -> Tag msg
withDismissLeft click t =
    { t | action = DismissLeft click }


withDismissRight : Click msg -> Tag msg -> Tag msg
withDismissRight click t =
    { t | action = DismissRight click }



-- VIEW


view : Tag msg -> Html msg
view t =
    let
        viewEl class_ content_ =
            div [ class class_ ] [ content_ ]

        dismiss c =
            Click.view [ class "tag_dismiss" ] [ Icon.view Icon.x ] c

        icon =
            Maybe.map (Icon.view >> viewEl "tag_icon") t.icon

        leftText =
            Maybe.map (text >> viewEl "tag_left-text") t.leftText

        rightText =
            Maybe.map (text >> viewEl "tag_right-text") t.leftText

        attrs =
            [ class "tag" ]

        content =
            MaybeE.values [ icon, leftText, Just (text t.text), rightText ]
    in
    case t.action of
        TagClick c ->
            Click.view attrs content c

        DismissLeft c ->
            div attrs (dismiss c :: content)

        DismissRight c ->
            div attrs (content ++ [ dismiss c ])

        _ ->
            div attrs content


viewTags : List (Tag msg) -> Html msg
viewTags tags =
    div [ class "tags" ] (List.map view tags)
