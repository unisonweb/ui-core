module Stories.Code.Workspace exposing (..)

import Browser
import Code.DefinitionSummaryTooltip
import Code.Syntax exposing (..)
import Code.Workspace exposing (Model, Msg(..))
import Code.Workspace.WorkspaceItem exposing (Item, WorkspaceItem(..), decodeItem, fromItem)
import Code.Workspace.WorkspaceItems exposing (empty, fromItems)
import Code.Workspace.Zoom exposing (Zoom(..))
import Helpers.ReferenceHelper exposing (sampleReference)
import Html exposing (Html)
import Http
import Lib.OperatingSystem
import UI.KeyboardShortcut
import UI.ViewMode


main : Program () Model Message
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init : () -> ( Model, Cmd Message )
init _ =
    ( initWorkspaceModel
    , Http.get
        { url = "/increment_term_def.json"
        , expect = Http.expectJson GotItem (decodeItem sampleReference)
        }
    )


type Message
    = WorkspaceMsg Msg
    | GotItem (Result Http.Error Item)


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        WorkspaceMsg _ ->
            ( model, Cmd.none )

        GotItem result ->
            case result of
                Err error ->
                    Debug.log (Debug.toString error)
                        ( model, Cmd.none )

                Ok item ->
                    let
                        workspaceItem =
                            fromItem sampleReference item

                        workspaceItems =
                            fromItems [ workspaceItem ] workspaceItem [ workspaceItem, workspaceItem ]
                    in
                    ( { model | workspaceItems = workspaceItems }, Cmd.none )


sampleKeyboardShortcut : UI.KeyboardShortcut.Model
sampleKeyboardShortcut =
    UI.KeyboardShortcut.init Lib.OperatingSystem.MacOS


initWorkspaceModel : Model
initWorkspaceModel =
    { workspaceItems = empty
    , keyboardShortcut = sampleKeyboardShortcut
    , definitionSummaryTooltip = Code.DefinitionSummaryTooltip.init
    }


view : Model -> Html Message
view model =
    Html.map WorkspaceMsg <|
        Code.Workspace.view
            UI.ViewMode.Regular
            model
