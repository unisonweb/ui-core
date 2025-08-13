module UI.Tag exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Maybe.Extra as MaybeE
import UI.Click as Click exposing (Click)
import UI.Icon as Icon exposing (Icon)


type TagAction msg
    = NoAction
    | TagClick (Click msg)
    | DismissLeft (Click msg)
    | DismissRight (Click msg)


type TagSize
    = Medium
    | Large
    | ExtraLarge


type alias Tag msg =
    { icon : Maybe (Icon msg)
    , leftText : Maybe String
    , text : String
    , rightText : Maybe String
    , action : TagAction msg
    , className : Maybe String
    , size : TagSize
    }



-- CREATE


tag : String -> Tag msg
tag text_ =
    { icon = Nothing
    , leftText = Nothing
    , text = text_
    , rightText = Nothing
    , action = NoAction
    , size = Medium
    , className = Nothing
    }



-- MODIFY


withIcon : Icon msg -> Tag msg -> Tag msg
withIcon icon t =
    { t | icon = Just icon }


withClassName : String -> Tag msg -> Tag msg
withClassName className t =
    { t | className = Just className }


withClick : Click msg -> Tag msg -> Tag msg
withClick click t =
    { t | action = TagClick click }


withLeftText : String -> Tag msg -> Tag msg
withLeftText leftText t =
    { t | leftText = Just leftText }


withRightText : String -> Tag msg -> Tag msg
withRightText rightText t =
    { t | rightText = Just rightText }


withDismissLeft : Click msg -> Tag msg -> Tag msg
withDismissLeft click t =
    { t | action = DismissLeft click }


withDismissRight : Click msg -> Tag msg -> Tag msg
withDismissRight click t =
    { t | action = DismissRight click }


medium : Tag msg -> Tag msg
medium t =
    { t | size = Medium }


large : Tag msg -> Tag msg
large t =
    { t | size = Large }


extraLarge : Tag msg -> Tag msg
extraLarge t =
    { t | size = ExtraLarge }



-- MAP


mapAction : (a -> b) -> TagAction a -> TagAction b
mapAction toMsg action =
    case action of
        NoAction ->
            NoAction

        TagClick c ->
            TagClick (Click.map toMsg c)

        DismissLeft c ->
            DismissLeft (Click.map toMsg c)

        DismissRight c ->
            DismissRight (Click.map toMsg c)


map : (a -> b) -> Tag a -> Tag b
map toMsg t =
    { icon = Maybe.map (Icon.map toMsg) t.icon
    , leftText = t.leftText
    , text = t.text
    , rightText = t.rightText
    , className = t.className
    , action = mapAction toMsg t.action
    , size = t.size
    }



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
            Maybe.map (text >> viewEl "tag_right-text") t.rightText

        tagText =
            div [ class "tag_text" ]
                (MaybeE.values [ leftText, Just (text t.text), rightText ])

        sizeClass =
            case t.size of
                Medium ->
                    class "tag_size_medium"

                Large ->
                    class "tag_size_large"

                ExtraLarge ->
                    class "tag_size_extra-large"

        attrs =
            [ class "tag", sizeClass ]
                ++ (t.className
                        |> Maybe.map (\cn -> [ class cn ])
                        |> Maybe.withDefault []
                   )

        content =
            MaybeE.values [ icon, Just tagText ]
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
