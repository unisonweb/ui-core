module Stories.Code.PageContent exposing (..)

import Browser
import Code.Config exposing (Config)
import Code.Definition.Reference as Reference
import Code.FullyQualifiedName as FQN
import Code.HashQualified exposing (HashQualified(..))
import Code.Perspective as Perspective
import Code.Syntax exposing (..)
import Code.Workspace as Workspace
import Code.Workspace.WorkspaceItem exposing (Item, ItemWithReferences, WorkspaceItem(..), decodeList, fromItem)
import Code.Workspace.WorkspaceItems as WorkspaceItems
import Dict exposing (Dict)
import Html exposing (Html)
import Http
import Json.Decode as Decode
import Lib.HttpApi as HttpApi exposing (ApiUrl(..), Endpoint(..))
import Lib.OperatingSystem as OperatingSystem
import UI.KeyboardShortcut as KeyboardShortcut exposing (KeyboardShortcut(..))
import UI.PageContent as PageContent
import UI.ViewMode


type alias Model =
    Workspace.Model


type Msg
    = WorkspaceMsg Workspace.Msg
    | GotItem Int Reference.Reference (Result Http.Error (List Item))


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
      , workspaceItemViewState = Code.Workspace.WorkspaceItem.viewState
      , isMinimapToggled = False
      , referenceMap = Dict.empty
      }
    , Cmd.batch
        [ getSampleResponse 0 "/long.json" "assets.indexHtml"
        , getSampleResponse 1 "/increment_term_def.json" "increment"
        , getSampleResponse 2 "/nat_gt_term_def.json" "nat_gt"
        , getSampleResponse 3 "/base_readme.json" "base_readme"
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
            Decode.map
                (\itemWithRefList -> List.map (\itemWithRef -> itemWithRef.item) itemWithRefList)
                (decodeList reference)
    in
    Http.get
        { url = url
        , expect = Http.expectJson (GotItem index reference) decoder
        }


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
        WorkspaceMsg _ ->
            ( model, Cmd.none )

        GotItem _ reference (Err error) ->
            ( model, Cmd.none )

        GotItem _ reference (Ok items) ->
            let
                newWorkspaceItems =
                    List.head items
                        |> Maybe.map
                            (\item ->
                                item
                                    |> fromItem reference
                                    |> WorkspaceItems.prependWithFocus model.workspaceItems
                            )
                        |> Maybe.withDefault model.workspaceItems

                newModel =
                    { model | workspaceItems = newWorkspaceItems }
            in
            ( newModel, Cmd.none )


view : Model -> Html Msg
view model =
    let
        workspaceView =
            Workspace.view
                UI.ViewMode.Regular
                model
    in
    PageContent.view <|
        PageContent.oneColumn [ workspaceView |> Html.map WorkspaceMsg ]
