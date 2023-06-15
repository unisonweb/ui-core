module Stories.Code.Workspace exposing (..)

import Browser
import Code.Config exposing (Config)
import Code.Definition.Reference as Reference
import Code.DefinitionSummaryTooltip as DefinitionSummaryTooltip
import Code.FullyQualifiedName as FQN
import Code.HashQualified exposing (HashQualified(..))
import Code.Perspective as Perspective
import Code.Syntax exposing (..)
import Code.Workspace as Workspace
import Code.Workspace.WorkspaceItem exposing (Item, WorkspaceItem(..), decodeItem, fromItem)
import Code.Workspace.WorkspaceItems as WorkspaceItems
import Html exposing (Html)
import Http
import Lib.HttpApi as HttpApi exposing (ApiUrl(..), Endpoint(..))
import Lib.OperatingSystem as OperatingSystem
import UI.KeyboardShortcut as KeyboardShortcut exposing (KeyboardShortcut(..))
import UI.ViewMode


type alias Model =
    Workspace.Model


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
    ( { workspaceItems = WorkspaceItems.empty
      , keyboardShortcut = KeyboardShortcut.init OperatingSystem.MacOS
      , definitionSummaryTooltip = DefinitionSummaryTooltip.init
      , isMinimapToggled = False
      }
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
                |> NameOnly
                |> Reference.TypeReference

        decoder =
            reference
                |> decodeItem
    in
    Http.get
        { url = url
        , expect = Http.expectJson (GotItem index reference) decoder
        }


type Msg
    = WorkspaceMsg Workspace.Msg
    | GotItem Int Reference.Reference (Result Http.Error Item)


codebaseHash : Endpoint
codebaseHash =
    GET { path = [ "list" ], queryParams = [] }


api : HttpApi.HttpApi
api =
    { url = SameOrigin []
    , headers = []
    }


config : Config
config =
    { operatingSystem = OperatingSystem.MacOS
    , perspective = Perspective.relativeRootPerspective
    , toApiEndpoint = \_ -> codebaseHash
    , api = api
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        WorkspaceMsg wMsg ->
            let
                ( newModel, cmd, _ ) =
                    Workspace.update config UI.ViewMode.Regular wMsg model
            in
            ( newModel, Cmd.map WorkspaceMsg cmd )

        GotItem _ reference result ->
            case result of
                Err error ->
                    Debug.log (Debug.toString error)
                        ( model, Cmd.none )

                Ok item ->
                    let
                        newWorkspaceItems =
                            item
                                |> fromItem reference
                                |> WorkspaceItems.prependWithFocus model.workspaceItems

                        newModel =
                            { model | workspaceItems = newWorkspaceItems }
                    in
                    ( newModel, Cmd.none )


view : Model -> Html Msg
view model =
    Workspace.view
        UI.ViewMode.Regular
        model
        |> Html.map WorkspaceMsg
