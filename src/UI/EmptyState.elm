module UI.EmptyState exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import UI.Icon as Icon exposing (Icon)
import UI.OnSurface as OnSurface exposing (OnSurface)


type CenterPiece msg
    = CircleCenterPiece (Html msg)
    | CustomCenterPiece (Html msg)
    | IconCenterPiece (Icon msg)


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



-- MODIFY


withContent : List (Html msg) -> EmptyState msg -> EmptyState msg
withContent content es =
    { es | content = content }


onSurface : OnSurface -> EmptyState msg -> EmptyState msg
onSurface onSurface_ es =
    { es | onSurface = onSurface_ }


onDark : EmptyState msg -> EmptyState msg
onDark es =
    onSurface OnSurface.dark es


onLight : EmptyState msg -> EmptyState msg
onLight es =
    onSurface OnSurface.light es



-- VIEW


view : EmptyState msg -> Html msg
view es =
    let
        ( illustration, hasClass ) =
            case es.type_ of
                Grid content ->
                    ( div [ class "empty-state_grid" ] content
                    , class "has_empty-state_grid"
                    )

                IconCloud (CircleCenterPiece content) ->
                    ( div [ class "empty-state_icon-cloud" ]
                        [ div [ class "empty-state_icon-cloud_center-piece" ]
                            [ div [ class "empty-state_icon-cloud_center-piece_circle" ]
                                [ content ]
                            ]
                        ]
                    , class "has_empty-state_icon-cloud"
                    )

                IconCloud (IconCenterPiece icon) ->
                    ( div [ class "empty-state_icon-cloud" ]
                        [ div [ class "empty-state_icon-cloud_center-piece_icon" ]
                            [ Icon.view icon ]
                        ]
                    , class "has_empty-state_icon-cloud"
                    )

                IconCloud (CustomCenterPiece content) ->
                    ( div [ class "empty-state_icon-cloud" ]
                        [ div [ class "empty-state_icon-cloud_center-piece" ]
                            [ content ]
                        ]
                    , class "has_empty-state_icon-cloud"
                    )

                Search ->
                    ( div [ class "empty-state_search" ] []
                    , class "has_empty-state_search"
                    )
    in
    div [ class "empty-state", OnSurface.toClass es.onSurface, hasClass ] (illustration :: es.content)
