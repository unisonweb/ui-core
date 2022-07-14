module UI.ViewMode exposing (..)

import UI.Button as Button exposing (Button)
import UI.Icon as Icon


type ViewMode
    = Regular
    | Presentation


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
                        |> Button.uncontained
    in
    button_ |> Button.small
