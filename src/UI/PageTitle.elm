module UI.PageTitle exposing (..)

import Html exposing (Html, div, h1, header, p, span, text)
import Html.Attributes exposing (class)
import Maybe.Extra as MaybeE
import UI
import UI.Icon as Icon exposing (Icon)


type Title msg
    = Title
        { icon : Maybe (Icon msg)
        , leftTitleText : Maybe String
        , titleText : String
        , rightTitleText : Maybe String
        , description : Maybe (Html msg)
        }
    | CustomTitle (List (Html msg))


type alias PageTitle msg =
    { title : Title msg
    , rightSide : List (Html msg)
    }



-- CREATE


title : String -> PageTitle msg
title titleText =
    { title =
        Title
            { icon = Nothing
            , leftTitleText = Nothing
            , titleText = titleText
            , rightTitleText = Nothing
            , description = Nothing
            }
    , rightSide = []
    }


custom : List (Html msg) -> PageTitle msg
custom items =
    let
        title_ =
            CustomTitle items
    in
    { title = title_, rightSide = [] }



-- MODIFY


withIcon : Icon msg -> PageTitle msg -> PageTitle msg
withIcon icon pageTitle_ =
    case pageTitle_.title of
        Title t ->
            let
                newTitle =
                    Title { t | icon = Just icon }
            in
            { pageTitle_ | title = newTitle }

        _ ->
            pageTitle_


withLeftTitleText : String -> PageTitle msg -> PageTitle msg
withLeftTitleText leftTitleText pageTitle_ =
    case pageTitle_.title of
        Title t ->
            let
                newTitle =
                    Title { t | leftTitleText = Just leftTitleText }
            in
            { pageTitle_ | title = newTitle }

        _ ->
            pageTitle_


withRightTitleText : String -> PageTitle msg -> PageTitle msg
withRightTitleText rightTitleText pageTitle_ =
    case pageTitle_.title of
        Title t ->
            let
                newTitle =
                    Title { t | rightTitleText = Just rightTitleText }
            in
            { pageTitle_ | title = newTitle }

        _ ->
            pageTitle_


withDescription : String -> PageTitle msg -> PageTitle msg
withDescription description pageTitle_ =
    withDescription_ (text description) pageTitle_


withDescription_ : Html msg -> PageTitle msg -> PageTitle msg
withDescription_ description pageTitle_ =
    case pageTitle_.title of
        Title t ->
            let
                newTitle =
                    Title { t | description = Just description }
            in
            { pageTitle_ | title = newTitle }

        _ ->
            pageTitle_


withRightSide : List (Html msg) -> PageTitle msg -> PageTitle msg
withRightSide rightSide pageTitle_ =
    { pageTitle_ | rightSide = rightSide }



-- MAP


mapTitle : (a -> b) -> Title a -> Title b
mapTitle f title_ =
    case title_ of
        Title t ->
            Title
                { icon = Maybe.map (Icon.map f) t.icon
                , leftTitleText = t.leftTitleText
                , titleText = t.titleText
                , rightTitleText = t.rightTitleText
                , description = Maybe.map (Html.map f) t.description
                }

        CustomTitle items ->
            CustomTitle (List.map (Html.map f) items)


map : (a -> b) -> PageTitle a -> PageTitle b
map f pageTitle_ =
    { title = mapTitle f pageTitle_.title
    , rightSide = List.map (Html.map f) pageTitle_.rightSide
    }



-- VIEW


viewTitle : Title msg -> Html msg
viewTitle title_ =
    case title_ of
        Title t ->
            let
                h1_ =
                    h1 []
                        [ MaybeE.unwrap UI.nothing (\l -> span [ class "left-title-text" ] [ text l ]) t.leftTitleText
                        , text t.titleText
                        , MaybeE.unwrap UI.nothing (\r -> span [ class "right-title-text" ] [ text r ]) t.rightTitleText
                        ]

                viewTitle_ attrs content =
                    div (class "page-title_title page-title_default-title" :: attrs) content
            in
            case ( t.icon, t.description ) of
                ( Nothing, Nothing ) ->
                    viewTitle_ [] [ h1_ ]

                ( Nothing, Just d ) ->
                    viewTitle_ []
                        [ div [ class "text" ]
                            [ h1_
                            , p [ class "description" ] [ d ]
                            ]
                        ]

                ( Just i, Nothing ) ->
                    viewTitle_ [ class "has_icon" ]
                        [ div [ class "icon-badge" ] [ Icon.view i ]
                        , h1_
                        ]

                ( Just i, Just d ) ->
                    viewTitle_ [ class "has_icon" ]
                        [ div [ class "icon-badge" ] [ Icon.view i ]
                        , div [ class "text" ]
                            [ h1_
                            , p [ class "description" ] [ d ]
                            ]
                        ]

        CustomTitle items ->
            div [ class "page-title_title page-title_custom-title" ] items


viewRightSide : List (Html msg) -> Html msg
viewRightSide rightSide =
    div [ class "page-title_right-side" ] rightSide


view : PageTitle msg -> Html msg
view pageTitle_ =
    header
        [ class "page-title" ]
        [ viewTitle pageTitle_.title
        , viewRightSide pageTitle_.rightSide
        ]
