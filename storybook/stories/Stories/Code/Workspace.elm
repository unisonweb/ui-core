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
import Code.Workspace.WorkspaceItem exposing (WorkspaceItem(..))
import Code.Workspace.WorkspaceItems as WorkspaceItems
import Html exposing (Html, div)
import Html.Events exposing (onClick)
import Lib.HttpApi as HttpApi exposing (ApiUrl(..), Endpoint(..))
import Lib.OperatingSystem as OperatingSystem
import UI.KeyboardShortcut as KeyboardShortcut exposing (KeyboardShortcut(..))
import UI.ViewMode
import Url
import Dict exposing (Dict)


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
                |> Reference.fromString Reference.TermReference

        model =
            { workspaceItems = WorkspaceItems.empty
            , keyboardShortcut = KeyboardShortcut.init OperatingSystem.MacOS
            , workspaceItemViewState = Code.Workspace.WorkspaceItem.viewState
            , isMinimapToggled = False
            , referenceMap = Dict.empty
            }

        openResult =
            Workspace.open config model reference
    in
    Tuple.mapSecond (Cmd.map WorkspaceMsg) openResult


type Msg
    = WorkspaceMsg Workspace.Msg
    | Open Reference.Reference


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

                "Nat.gt" ->
                    "/nat_gt_term_def.json"

                "base.README" ->
                    "/base_readme.json"

                "blog" ->
                     "/blog_def.json"

                "assets.indexHtml" ->
                    "/long.json"

                "PositiveInt2" ->
                    "/positive_int_2.json"

                "Config" -> 
                    "/cloud_config_def.json"

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

        Open ref ->
            let
                openResult =
                    Workspace.open config model ref
            in
            Tuple.mapSecond (Cmd.map WorkspaceMsg) openResult


view : Model -> Html Msg
view model =
    div []
        [ Workspace.view
            UI.ViewMode.Regular
            model
            |> Html.map WorkspaceMsg
        , Html.br [] []
        , sampleAddButton Reference.TermReference "PositiveInt2"
        , Html.br [] []
        , sampleAddButton Reference.TermReference "assets.indexHtml"
        , Html.br [] []
        , sampleAddButton Reference.TermReference "base.README"
        , Html.br [] []
        , sampleAddButton Reference.TermReference "blog"
        , Html.br [] []
        , sampleAddButton Reference.TermReference "Nat.gt"
        , Html.br [] []
        , sampleAddButton Reference.TermReference "Config"
        ]


sampleAddButton : (HashQualified -> Reference.Reference) -> String -> Html Msg
sampleAddButton toRef name =
    Html.button
        [ onClick
            (name
                |> Reference.fromString toRef
                |> Open
            )
        ]
        [ Html.text ("Open " ++ name) ]
