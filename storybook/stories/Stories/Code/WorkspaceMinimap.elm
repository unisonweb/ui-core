module Stories.Code.WorkspaceMinimap exposing (..)

import Browser
import Code.Definition.Reference as Reference
import Code.FullyQualifiedName as FQN
import Code.HashQualified as HashQualified
import Code.Workspace as Workspace
import Code.Workspace.WorkspaceItem as WorkspaceItem
import Code.Workspace.WorkspaceItems as WorkspaceItems
import Code.Workspace.WorkspaceMinimap as WorkspaceMinimap
import Dict exposing (Dict, empty, insert, remove)
import Html exposing (Html)
import Http
import Lib.OperatingSystem as OperatingSystem
import UI.KeyboardShortcut as KeyboardShortcut exposing (KeyboardShortcut(..))


type alias Model =
    { workspaceItemDict : Dict Int WorkspaceItem.WorkspaceItem
    }


type Msg
    = WorkspaceMsg Workspace.Msg
    | GotItem Int Reference.Reference (Result Http.Error WorkspaceItem.Item)
    | WorkspaceMinimapMsg WorkspaceMinimap.Msg


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
    ( { workspaceItemDict = Dict.empty }
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
        WorkspaceMsg _ ->
            ( model, Cmd.none )

        GotItem index reference result ->
            case result of
                Err error ->
                    Debug.log (Debug.toString error)
                        ( model, Cmd.none )

                Ok item ->
                    let
                        workspaceItem =
                            WorkspaceItem.fromItem reference item

                        newDict =
                            insert index workspaceItem model.workspaceItemDict
                    in
                    ( { model | workspaceItemDict = newDict }, Cmd.none )

        WorkspaceMinimapMsg mMsg ->
            case mMsg of
                WorkspaceMinimap.SelectItem _ ->
                    ( model, Cmd.none )

                WorkspaceMinimap.CloseAll ->
                    ( { workspaceItemDict = empty }, Cmd.none )


view : Model -> Html Msg
view model =
    case Dict.values model.workspaceItemDict of
        [] ->
            Html.text "no items"

        x :: xs ->
            let
                workspaceItems =
                    WorkspaceItems.fromItems [] x xs
            in
            WorkspaceMinimap.view (KeyboardShortcut.init OperatingSystem.MacOS) workspaceItems |> Html.map WorkspaceMinimapMsg
