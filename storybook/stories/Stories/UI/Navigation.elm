module Stories.UI.Navigation exposing (..)

import Browser
import Helpers.Layout exposing (columns)
import Html exposing (Html)
import UI.Click as C
import UI.Icon as I
import UI.Navigation as N
import UI.Nudge
import UI.Tooltip


main : Program () () Msg
main =
    Browser.element
        { init = \_ -> ( (), Cmd.none )
        , view = \_ -> view
        , update = \_ currentModel -> ( currentModel, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }


type Msg
    = UserClicked


sampleNavItem : N.NavItem Msg
sampleNavItem =
    N.navItem "some" (C.ExternalHref C.Self "some")


sampleNavItems : List (N.NavItem Msg)
sampleNavItems =
    [ C.ExternalHref C.Self "link 1" |> N.navItem "item 1"
    , C.ExternalHref C.Self "link 2" |> N.navItem "item 2"
    , C.ExternalHref C.Self "link 3" |> N.navItem "item 3"
    ]


elements : List (N.Navigation Msg)
elements =
    [ N.withNoSelectedItems
        sampleNavItems
        N.empty
    , N.withItems
        (List.take 2 sampleNavItems)
        (C.ExternalHref C.Self "link 3" |> N.navItem "item 3")
        (List.drop 3 sampleNavItems)
        N.empty
    , N.withNoSelectedItems
        (sampleNavItems
            |> List.map (N.navItemWithIcon I.unisonMark)
        )
        N.empty
    , N.withNoSelectedItems
        (sampleNavItems
            |> List.map (N.navItemWithNudge (UI.Nudge.nudge |> UI.Nudge.pulsate))
        )
        N.empty
    , N.withNoSelectedItems
        (sampleNavItems
            |> List.map (N.navItemWithTooltip (UI.Tooltip.text "tooltip text" |> UI.Tooltip.tooltip))
        )
        N.empty
    ]


view : Html Msg
view =
    columns [] (elements |> List.map N.view)
