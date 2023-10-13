module UI.ExternalLinkIcon exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class)
import UI.Click as Click exposing (Click)
import UI.Icon as Icon


view : Click msg -> Html msg
view click =
    Click.view [ class "external-link-icon" ]
        [ Icon.view Icon.arrowEscapeBox ]
        click
