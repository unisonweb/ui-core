module UI.Divider exposing (..)

import Html exposing (Html, hr)
import Html.Attributes exposing (class)


type OnSurface
    = Dark
    | Light


type DividerSize
    = Normal
    | Small


type alias Divider =
    { onSurface : OnSurface
    , size : DividerSize
    , margin : Bool
    }



-- CREATE


divider : Divider
divider =
    { onSurface = Light, size = Normal, margin = True }


simple : Divider
simple =
    { onSurface = Light, size = Small, margin = False }



-- MODIFY


withOnSurface : OnSurface -> Divider -> Divider
withOnSurface onSurface d =
    { d | onSurface = onSurface }


onDark : Divider -> Divider
onDark d =
    withOnSurface Dark d


onLight : Divider -> Divider
onLight d =
    withOnSurface Light d


withSize : DividerSize -> Divider -> Divider
withSize size d =
    { d | size = size }


small : Divider -> Divider
small d =
    withSize Small d


withMargin : Divider -> Divider
withMargin d =
    { d | margin = True }


withoutMargin : Divider -> Divider
withoutMargin d =
    { d | margin = False }



-- VIEW


viewSimple : Html msg
viewSimple =
    view simple


view : Divider -> Html msg
view d =
    let
        sizeClass =
            case d.size of
                Small ->
                    class "divider_size_small"

                Normal ->
                    class "divider_size_normal"

        surfaceClass =
            case d.onSurface of
                Light ->
                    class "divider_on-surface_light"

                Dark ->
                    class "divider_on-surface_dark"

        paddingClass =
            if d.margin then
                class "divider_margin"

            else
                class "divider_no-margin"
    in
    hr [ class "divider", sizeClass, surfaceClass, paddingClass ] []
