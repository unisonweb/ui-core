module Stories.Code.WorkspaceMinimap exposing (..)

import Browser
import Code.Definition.Reference as Reference
import Code.FullyQualifiedName as FQN
import Code.HashQualified as HashQualified
import Code.Workspace.WorkspaceItem as WorkspaceItem
import Code.Workspace.WorkspaceItems as WorkspaceItems
import Code.Workspace.WorkspaceMinimap as WorkspaceMinimap
import Html exposing (Html)
import Http
import Lib.OperatingSystem as OperatingSystem
import UI.KeyboardShortcut as KeyboardShortcut exposing (KeyboardShortcut(..))


type alias Model =
    WorkspaceMinimap.Model


type Msg
    = WorkspaceMinimapMsg WorkspaceMinimap.Msg
    | GotItem Int Reference.Reference (Result Http.Error WorkspaceItem.Item)


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
    ( WorkspaceMinimap.init (KeyboardShortcut.init OperatingSystem.MacOS) WorkspaceItems.empty
    , Cmd.batch
        [ getSampleResponse 0 "/increment_term_def.json" "increment"
        , getSampleResponse 1 "/nat_gt_term_def.json" "nat_gt"
        , getSampleResponse 2 "/base_readme.json" "base_readme"
        ]
    )


getSampleResponse : Int -> String -> String -> Cmd Msg
getSampleResponse index url termName =
    let
        reference =
            termName
                |> FQN.fromString
                |> HashQualified.NameOnly
                |> Reference.TypeReference

        decoder =
            reference
                |> WorkspaceItem.decodeItem
    in
    Http.get
        { url = url
        , expect = Http.expectJson (GotItem index reference) decoder
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        WorkspaceMinimapMsg mMsg ->
            let
                ( updatedModel, cmd ) =
                    WorkspaceMinimap.update mMsg model
            in
            ( updatedModel, Cmd.map WorkspaceMinimapMsg cmd )

        GotItem _ reference result ->
            case result of
                Err error ->
                    Debug.log (Debug.toString error)
                        ( model, Cmd.none )

                Ok item ->
                    let
                        newWorkspaceItems =
                            item
                                |> WorkspaceItem.fromItem reference
                                |> WorkspaceItems.prependWithFocus model.workspaceItems
                    in
                    ( { model | workspaceItems = newWorkspaceItems }, Cmd.none )


view : Model -> Html Msg
view model =
    WorkspaceMinimap.view model
        |> Html.map WorkspaceMinimapMsg
