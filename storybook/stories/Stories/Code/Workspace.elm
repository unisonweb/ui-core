module Stories.Code.Workspace exposing (..)

import Browser
import Code.Definition.Reference as Reference
import Code.DefinitionSummaryTooltip as DefinitionSummaryTooltip
import Code.FullyQualifiedName as FQN
import Code.HashQualified exposing (HashQualified(..))
import Code.Syntax exposing (..)
import Code.Workspace as Workspace exposing (Msg(..))
import Code.Workspace.WorkspaceItem exposing (Item, WorkspaceItem(..), decodeItem, fromItem)
import Code.Workspace.WorkspaceItems as WorkspaceItems
import Code.Workspace.WorkspaceMinimap as WorkspaceMinimap
import Dict exposing (Dict, insert)
import Helpers.ReferenceHelper exposing (sampleReference)
import Html exposing (Html)
import Http
import Lib.OperatingSystem as OperatingSystem
import UI.KeyboardShortcut as KeyboardShortcut exposing (KeyboardShortcut(..))
import UI.ViewMode


type alias Model =
    Workspace.Model



-- { workspaceItemDict : Dict Int WorkspaceItem
-- }


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
    ( { workspaceItems = WorkspaceItems.empty
      , keyboardShortcut = KeyboardShortcut.init OperatingSystem.MacOS
      , definitionSummaryTooltip = DefinitionSummaryTooltip.init
      , minimap = WorkspaceMinimap.init (KeyboardShortcut.init OperatingSystem.MacOS) WorkspaceItems.empty
      }
    , Cmd.batch
        [ getSampleResponse 0 "/increment_term_def.json" "increment"
        , getSampleResponse 1 "/nat_gt_term_def.json" "nat_gt"
        , getSampleResponse 2 "/base_readme.json" "base_readme"
        ]
    )


getSampleResponse : Int -> String -> String -> Cmd Message
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


type Message
    = WorkspaceMsg Msg
    | GotItem Int Reference.Reference (Result Http.Error Item)


update : Message -> Model -> ( Model, Cmd Message )
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
                            fromItem reference item

                        TODO: write some here
                        newDict =
                            insert index workspaceItem model.workspaceItemDict
                    in
                    ( { model | workspaceItemDict = newDict }, Cmd.none )


view : Model -> Html Message
view model =
    Workspace.view
        UI.ViewMode.Regular
        model
        |> Html.map WorkspaceMsg



-- case Dict.values model.workspaceItemDict of
--     [] ->
--         Html.text "no items"
--     x :: xs ->
--         let
--             workspaceItems =
--                 WorkspaceItems.fromItems [] x xs
--             workspaceModel =
--                 { workspaceItems = workspaceItems
--                 , keyboardShortcut = UI.KeyboardShortcut.init Lib.OperatingSystem.MacOS -- just a sample
--                 , definitionSummaryTooltip = Code.DefinitionSummaryTooltip.init
--                 , minimap = WorkspaceMinimap.init (UI.KeyboardShortcut.init Lib.OperatingSystem.MacOS) workspaceItems
--                 }
--         in
--         Code.Workspace.view
--             UI.ViewMode.Regular
--             workspaceModel
--             |> Html.map WorkspaceMsg
