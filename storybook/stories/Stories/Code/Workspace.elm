module Stories.Code.Workspace exposing (..)

import Browser
import Code.DefinitionSummaryTooltip
import Code.Syntax exposing (..)
import Code.Workspace exposing (Msg(..))
import Code.Workspace.WorkspaceItem exposing (Item, WorkspaceItem(..), decodeItem, fromItem)
import Code.Workspace.WorkspaceItems as WorkspaceItems
import Dict exposing (Dict, insert)
import Helpers.ReferenceHelper exposing (sampleReference)
import Html exposing (Html)
import Http
import Lib.OperatingSystem
import UI.KeyboardShortcut
import UI.ViewMode


type alias Model =
    { workspaceItemDict : Dict Int WorkspaceItem
    }


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
    ( { workspaceItemDict = Dict.empty }
    , Cmd.batch
        [ getSampleResponse 0 "/increment_term_def.json"
        , getSampleResponse 1 "/nat_gt_term_def.json"
        , getSampleResponse 2 "/base_readme.json"
        ]
    )


getSampleResponse : Int -> String -> Cmd Message
getSampleResponse index url =
    Http.get
        { url = url
        , expect = Http.expectJson (GotItem index) (decodeItem sampleReference)
        }


type Message
    = WorkspaceMsg Msg
    | GotItem Int (Result Http.Error Item)


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        WorkspaceMsg _ ->
            ( model, Cmd.none )

        GotItem index result ->
            case result of
                Err error ->
                    Debug.log (Debug.toString error)
                        ( model, Cmd.none )

                Ok item ->
                    let
                        workspaceItem =
                            fromItem sampleReference item

                        newDict =
                            insert index workspaceItem model.workspaceItemDict
                    in
                    ( { model | workspaceItemDict = newDict }, Cmd.none )


view : Model -> Html Message
view model =
    case Dict.values model.workspaceItemDict of
        [] ->
            Html.text "no items"

        x :: xs ->
            let
                workspaceItems =
                    WorkspaceItems.fromItems [] x xs

                workspaceModel =
                    { workspaceItems = workspaceItems
                    , keyboardShortcut = UI.KeyboardShortcut.init Lib.OperatingSystem.MacOS -- just a sample
                    , definitionSummaryTooltip = Code.DefinitionSummaryTooltip.init
                    }
            in
            Code.Workspace.view
                UI.ViewMode.Regular
                workspaceModel
                |> Html.map WorkspaceMsg
