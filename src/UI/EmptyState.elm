module UI.EmptyState exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import UI.OnSurface as OnSurface exposing (OnSurface)


type CenterPiece msg
    = CircleCenterPiece (Html msg)
    | CustomCenterPiece (Html msg)


type IllustrationType msg
    = Grid (List (Html msg))
    | IconCloud (CenterPiece msg)
    | Search


type alias EmptyState msg =
    { type_ : IllustrationType msg
    , onSurface : OnSurface
    , content : List (Html msg)
    }



-- CREATE


grid : List (Html msg) -> EmptyState msg
grid content =
    { type_ = Grid content, onSurface = OnSurface.light, content = [] }


iconCloud : CenterPiece msg -> EmptyState msg
iconCloud cp =
    { type_ = IconCloud cp, onSurface = OnSurface.light, content = [] }


search : EmptyState msg
search =
    { type_ = Search, onSurface = OnSurface.light, content = [] }


withContent : List (Html msg) -> EmptyState msg -> EmptyState msg
withContent content es =
    { es | content = content }


view : EmptyState msg -> Html msg
view es =
    let
        illustration =
            case es.type_ of
                Grid content ->
                    div [ class "empty-state_grid" ] content

                IconCloud (CircleCenterPiece content) ->
                    div [ class "empty-state_icon-cloud" ]
                        [ div [ class "empty-state_icon-cloud_center-piece" ]
                            [ div [ class "empty-state_icon-cloud_center-piece_circle" ]
                                [ content ]
                            ]
                        ]

                IconCloud (CustomCenterPiece content) ->
                    div [ class "empty-state_icon-cloud" ]
                        [ div [ class "empty-state_icon-cloud_center-piece" ]
                            [ content ]
                        ]

                Search ->
                    div [ class "empty-state_search" ] []
    in
    div [ class "empty-state" ] (illustration :: es.content)
