module UI.Tooltip exposing
    ( Arrow(..)
    , Content
    , MenuItem
    , Position(..)
    , Tooltip
    , hide
    , map
    , menu
    , rich
    , show
    , text
    , textMenu
    , toggleShow
    , tooltip
    , view
    , withArrow
    , withPosition
    , withShow
    )

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import UI
import UI.Click as Click exposing (Click)
import UI.Icon as Icon exposing (Icon)


type alias Tooltip msg =
    { arrow : Arrow
    , content : Content msg
    , position : Position
    , show : Bool
    }


type Arrow
    = None
    | Start
    | Middle
    | End


{-| Position relative to trigger
-}
type Position
    = Above
    | Below
    | LeftOf
    | RightOf



-- CREATE


tooltip : Content msg -> Tooltip msg
tooltip content =
    { arrow = Middle
    , content = content
    , position = Below
    , show = False
    }



-- CONTENT


type alias MenuItem msg =
    { icon : Maybe (Icon msg), label : String, click : Click msg }


type Content msg
    = Text String
    | Rich (Html msg)
    | Menu (List (MenuItem msg))


text : String -> Content msg
text t =
    Text t


rich : Html msg -> Content msg
rich h =
    Rich h


menu : List ( Icon msg, String, Click msg ) -> Content msg
menu items =
    items
        |> List.map (\( i, l, c ) -> MenuItem (Just i) l c)
        |> Menu


textMenu : List ( String, Click msg ) -> Content msg
textMenu items =
    items
        |> List.map (\( l, c ) -> MenuItem Nothing l c)
        |> Menu



-- MODIFY


withArrow : Arrow -> Tooltip msg -> Tooltip msg
withArrow arrow tooltip_ =
    { tooltip_ | arrow = arrow }


withPosition : Position -> Tooltip msg -> Tooltip msg
withPosition pos tooltip_ =
    { tooltip_ | position = pos }


withShow : Bool -> Tooltip msg -> Tooltip msg
withShow show_ tooltip_ =
    { tooltip_ | show = show_ }


show : Tooltip msg -> Tooltip msg
show tooltip_ =
    withShow True tooltip_


hide : Tooltip msg -> Tooltip msg
hide tooltip_ =
    withShow False tooltip_


toggleShow : Tooltip msg -> Tooltip msg
toggleShow tooltip_ =
    withShow (not tooltip_.show) tooltip_



-- MAP


map : (a -> msg) -> Tooltip a -> Tooltip msg
map toMsg tooltip_ =
    { arrow = tooltip_.arrow
    , content = mapContent toMsg tooltip_.content
    , position = tooltip_.position
    , show = tooltip_.show
    }


mapContent : (a -> msg) -> Content a -> Content msg
mapContent toMsg content =
    case content of
        Text s ->
            Text s

        Rich h ->
            Rich (Html.map toMsg h)

        Menu items ->
            Menu (List.map (mapMenuItem toMsg) items)


mapMenuItem : (a -> msg) -> MenuItem a -> MenuItem msg
mapMenuItem toMsg menuItem =
    { icon = Maybe.map (Icon.map toMsg) menuItem.icon
    , label = menuItem.label
    , click = Click.map toMsg menuItem.click
    }



-- VIEW


view : Html msg -> Tooltip msg -> Html msg
view trigger { arrow, content, position } =
    let
        viewMenuItem item =
            let
                iconHtml =
                    case item.icon of
                        Just icon ->
                            Icon.view icon

                        Nothing ->
                            UI.nothing
            in
            Click.view [ class "tooltip-menu-item" ] [ iconHtml, Html.text item.label ] item.click

        content_ =
            case content of
                Text t ->
                    Html.text t

                Rich html_ ->
                    html_

                Menu items ->
                    div [ class "tooltip-menu-items" ] (List.map viewMenuItem items)

        tooltip_ =
            -- The tooltip includes a small bridge (made with padding) above
            -- the bubble to allow the user to hover into the tooltip and click
            -- links etc.
            div
                [ class "tooltip"
                , class (positionToClass position)
                , class
                    (arrowToClass arrow)
                , class (contentToClass content)
                ]
                [ div
                    [ class "tooltip-bubble" ]
                    [ content_ ]
                ]
    in
    div [ class "tooltip-trigger" ] [ tooltip_, trigger ]



-- INTERNAL


contentToClass : Content msg -> String
contentToClass content =
    case content of
        Text _ ->
            "content-text"

        Rich _ ->
            "content-rich"

        Menu _ ->
            "content-menu"


positionToClass : Position -> String
positionToClass pos =
    case pos of
        Above ->
            "above"

        Below ->
            "below"

        RightOf ->
            "right-of"

        LeftOf ->
            "left-of"


arrowToClass : Arrow -> String
arrowToClass arrow =
    case arrow of
        None ->
            "arrow-none"

        Start ->
            "arrow-start"

        Middle ->
            "arrow-middle"

        End ->
            "arrow-end"
