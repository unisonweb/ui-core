module Stories.Code.Workspace exposing (..)

import Browser
import Code.CodebaseApi as CodebaseApi
import Code.Config exposing (Config)
import Code.Definition.Reference as Reference
import Code.FullyQualifiedName as FQN
import Code.HashQualified exposing (HashQualified(..))
import Code.Perspective as Perspective
import Code.Syntax exposing (..)
import Code.Workspace as Workspace
import Code.Workspace.WorkspaceItem exposing (Item, WorkspaceItem(..), decodeItem, fromItem)
import Code.Workspace.WorkspaceItems as WorkspaceItems
import Html exposing (Html, div)
import Html.Events exposing (onClick)
import Http
import Lib.HttpApi as HttpApi exposing (ApiUrl(..), Endpoint(..))
import Lib.OperatingSystem as OperatingSystem
import UI.KeyboardShortcut as KeyboardShortcut exposing (KeyboardShortcut(..))
import UI.ViewMode
import Url


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
    let
        reference =
            "increment"
                |> FQN.fromString
                |> NameOnly
                |> Reference.TypeReference

        model =
            { workspaceItems = WorkspaceItems.empty
            , keyboardShortcut = KeyboardShortcut.init OperatingSystem.MacOS
            , workspaceItemViewState = Code.Workspace.WorkspaceItem.viewState
            , isMinimapToggled = False
            }

        openResult =
            Workspace.open config model reference
    in
    Tuple.mapSecond (Cmd.map WorkspaceMsg) openResult



-- ( model
-- , Cmd.batch
--     [ getSampleResponse 0 "/increment_term_def.json" "increment"
--     , getSampleResponse 1 "/nat_gt_term_def.json" "nat_gt"
--     , getSampleResponse 2 "/base_readme.json" "base_readme"
--     , getSampleResponse 3 "/long.json" "assets.indexHtml"
--     ]
-- )


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
    | OpenNext


codebaseHash : Endpoint
codebaseHash =
    GET { path = [ "" ], queryParams = [] }


refToEndpoint : Reference.Reference -> Endpoint
refToEndpoint ref =
    let
        refStringToMockFileName : String -> String
        refStringToMockFileName input =
            case input of
                "increment" ->
                    "increment_term_def.json"

                "nat_gt" ->
                    "/nat_gt_term_def.json"

                "base_readme" ->
                    "/base_readme.json"

                "assets.indexHtml" ->
                    "/long.json"

                _ ->
                    ""
    in
    GET
        { path = [ refStringToMockFileName (Reference.toApiUrlString ref) ]
        , queryParams = []
        }


api : HttpApi.HttpApi
api =
    { url =
        Url.fromString "http://localhost:6006"
            |> Maybe.map CrossOrigin
            |> Maybe.withDefault (SameOrigin [])
    , headers = []
    }


config : Config
config =
    { operatingSystem = OperatingSystem.MacOS
    , perspective = Perspective.relativeRootPerspective
    , toApiEndpoint =
        \endpoint ->
            case endpoint of
                CodebaseApi.Find _ ->
                    codebaseHash

                CodebaseApi.Browse _ ->
                    codebaseHash

                CodebaseApi.Definition { ref } ->
                    refToEndpoint ref

                CodebaseApi.Summary _ ->
                    codebaseHash
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

        OpenNext ->
            let
                reference =
                    "assets.indexHtml"
                        |> FQN.fromString
                        |> NameOnly
                        |> Reference.TypeReference

                openResult =
                    Workspace.open config model reference
            in
            ( Tuple.first openResult
            , Tuple.second openResult |> Cmd.map WorkspaceMsg
            )


view : Model -> Html Msg
view model =
    div []
        [ Workspace.view
            UI.ViewMode.Regular
            model
            |> Html.map WorkspaceMsg
        , Html.button [ onClick OpenNext ] [ Html.text "Open next" ]
        ]
