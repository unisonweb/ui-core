module UI.ViewMode exposing (..)

import UI.Button as Button exposing (Button)
import UI.Icon as Icon


type ViewMode
    = Regular
    | Presentation


fromString : String -> ViewMode
fromString s =
    if s == "presentation" then
        Presentation

    else
        Regular


toString : ViewMode -> String
toString vm =
    case vm of
        Regular ->
            "regular"

        Presentation ->
            "presentation"


isRegular : ViewMode -> Bool
isRegular vm =
    vm == Regular


isPresentation : ViewMode -> Bool
isPresentation vm =
    vm == Presentation


button : (ViewMode -> msg) -> ViewMode -> Button msg
button updateViewModeMsg viewMode =
    let
        button_ =
            case viewMode of
                Regular ->
                    Button.iconThenLabel
                        (updateViewModeMsg Presentation)
                        Icon.presentation
                        "Enter Presentation Mode"

                Presentation ->
                    Button.iconThenLabel
                        (updateViewModeMsg Regular)
                        Icon.presentationSlash
                        "Exit Presentation Mode"
                        |> Button.subdued
    in
    button_ |> Button.small


toCssClass : ViewMode -> String
toCssClass vm =
    "view-mode_" ++ toString vm
