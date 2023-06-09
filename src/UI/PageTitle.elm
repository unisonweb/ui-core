module UI.PageTitle exposing (..)

import Html exposing (Html, div, h1, header, p, text)
import Html.Attributes exposing (class)
import UI.Icon as Icon exposing (Icon)


type Title msg
    = Title
        { icon : Maybe (Icon msg)
        , title : String
        , description : Maybe String
        }
    | CustomTitle (List (Html msg))


type alias PageTitle msg =
    { title : Title msg
    , rightSide : List (Html msg)
    }



-- CREATE


title : String -> PageTitle msg
title title_ =
    let
        title__ =
            Title { icon = Nothing, title = title_, description = Nothing }
    in
    { title = title__, rightSide = [] }


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


withDescription : String -> PageTitle msg -> PageTitle msg
withDescription description pageTitle_ =
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
                , title = t.title
                , description = t.description
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
                viewTitle_ attrs content =
                    div (class "page-title_title page-title_default-title" :: attrs) content
            in
            case ( t.icon, t.description ) of
                ( Nothing, Nothing ) ->
                    viewTitle_ [] [ h1 [] [ text t.title ] ]

                ( Nothing, Just d ) ->
                    viewTitle_ []
                        [ div [ class "text" ]
                            [ h1 [] [ text t.title ]
                            , p [ class "description" ] [ text d ]
                            ]
                        ]

                ( Just i, Nothing ) ->
                    viewTitle_ [ class "has_icon" ]
                        [ div [ class "icon-badge" ] [ Icon.view i ]
                        , h1 [] [ text t.title ]
                        ]

                ( Just i, Just d ) ->
                    viewTitle_ [ class "has_icon" ]
                        [ div [ class "icon-badge" ] [ Icon.view i ]
                        , div [ class "text" ]
                            [ h1 [] [ text t.title ]
                            , p [ class "description" ] [ text d ]
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
