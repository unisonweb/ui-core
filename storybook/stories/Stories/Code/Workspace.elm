module Stories.Code.Workspace exposing (..)

import Browser
import Code.DefinitionSummaryTooltip
import Code.Syntax exposing (..)
import Code.Workspace exposing (Model, Msg(..))
import Code.Workspace.WorkspaceItem exposing (WorkspaceItem(..))
import Code.Workspace.WorkspaceItems exposing (empty)
import Code.Workspace.Zoom exposing (Zoom(..))
import Html exposing (Html)
import Lib.OperatingSystem
import Stories.Code.WorkspaceItemsSample exposing (makeWorkspaceItems)
import UI.KeyboardShortcut
import UI.ViewMode


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init : () -> ( Model, Cmd Msg )
init _ =
    case makeWorkspaceItems of
        Err _ ->
            ( makeWorkspaceModel, Cmd.none )

        Ok workspaceItems ->
            ( { makeWorkspaceModel | workspaceItems = workspaceItems }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )


sampleKeyboardShortcut : UI.KeyboardShortcut.Model
sampleKeyboardShortcut =
    UI.KeyboardShortcut.init Lib.OperatingSystem.MacOS


makeWorkspaceModel : Model
makeWorkspaceModel =
    { workspaceItems = empty
    , keyboardShortcut = sampleKeyboardShortcut
    , definitionSummaryTooltip = Code.DefinitionSummaryTooltip.init
    }


view : Model -> Html Msg
view model =
    Code.Workspace.view UI.ViewMode.Regular model
