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
import Json.Decode as Decode
import Lib.OperatingSystem as OperatingSystem
import UI.KeyboardShortcut as KeyboardShortcut exposing (KeyboardShortcut(..))


type alias Model =
    WorkspaceMinimap.Minimap Msg


type Msg
    = SelectItem WorkspaceItem.WorkspaceItem
    | CloseItem WorkspaceItem.WorkspaceItem
    | CloseAll
    | ToggleMinimap
    | GotItem Reference.Reference (Result Http.Error WorkspaceItem.Item)


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
    ( { keyboardShortcut = KeyboardShortcut.init OperatingSystem.MacOS
      , workspaceItems =
            WorkspaceItems.fromItems []
                ("increment" |> loadingItem)
                ([ "nat_gt"
                 , "base_readme"
                 , "not_exist"
                 , "loading"
                 ]
                    |> List.map loadingItem
                )
      , selectItemMsg = SelectItem
      , closeItemMsg = CloseItem
      , closeAllMsg = CloseAll
      , isToggled = False
      , toggleMinimapMsg = ToggleMinimap
      }
    , Cmd.batch
        [ getSampleResponse "/increment_term_def.json" "increment"
        , getSampleResponse "/nat_gt_term_def.json" "nat_gt"
        , getSampleResponse "/base_readme.json" "base_readme"
        , getSampleResponse "/not_exist.json" "not_exist"
        ]
    )


loadingItem : String -> WorkspaceItem.WorkspaceItem
loadingItem termName =
    termName
        |> termReference
        |> WorkspaceItem.Loading


termReference : String -> Reference.Reference
termReference termName =
    termName
        |> FQN.fromString
        |> HashQualified.NameOnly
        |> Reference.TypeReference


getSampleResponse : String -> String -> Cmd Msg
getSampleResponse url termName =
    let
        reference =
            termName |> termReference

        decoder =
            Decode.map
                (\itemWithRef -> itemWithRef.item)
                (reference |> WorkspaceItem.decodeItem)
    in
    Http.get
        { url = url
        , expect = Http.expectJson (GotItem reference) decoder
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        SelectItem item ->
            let
                nextWorkspaceItems =
                    item
                        |> WorkspaceItem.reference
                        |> WorkspaceItems.focusOn model.workspaceItems
            in
            ( { model | workspaceItems = nextWorkspaceItems }
            , Cmd.none
            )

        CloseItem item ->
            let
                nextWorkspaceItems =
                    item
                        |> WorkspaceItem.reference
                        |> WorkspaceItems.remove model.workspaceItems
            in
            ( { model | workspaceItems = nextWorkspaceItems }
            , Cmd.none
            )

        CloseAll ->
            let
                nextWorkspaceItems =
                    WorkspaceItems.empty
            in
            ( { model | workspaceItems = nextWorkspaceItems }
            , Cmd.none
            )

        ToggleMinimap ->
            ( { model | isToggled = not model.isToggled }
            , Cmd.none
            )

        GotItem reference result ->
            case result of
                Err error ->
                    let
                        newWorkspaceItems =
                            WorkspaceItem.Failure reference error
                                |> WorkspaceItems.replace model.workspaceItems reference
                    in
                    ( { model | workspaceItems = newWorkspaceItems }, Cmd.none )

                Ok item ->
                    let
                        newWorkspaceItems =
                            item
                                |> WorkspaceItem.fromItem reference
                                |> WorkspaceItems.replace model.workspaceItems reference
                    in
                    ( { model | workspaceItems = newWorkspaceItems }, Cmd.none )


view : Model -> Html Msg
view model =
    WorkspaceMinimap.view model
