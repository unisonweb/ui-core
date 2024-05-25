module Stories.Code.WorkspaceItem exposing (..)

import Browser
import Code.Syntax exposing (..)
import Code.Workspace.WorkspaceItem exposing (Item, ItemWithReference, Msg(..), WorkspaceItem(..), decodeItem, fromItem)
import Code.Workspace.Zoom exposing (Zoom(..))
import Dict
import Helpers.ReferenceHelper exposing (sampleReference)
import Html exposing (Html)
import Http
import UI.ViewMode


type alias Model =
    { workspaceItem : Maybe WorkspaceItem
    }


type Message
    = WorkspaceItemMsg Msg
    | GotItem (Result Http.Error ItemWithReference)


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
    ( { workspaceItem = Nothing }
    , Http.get
        { url = "/increment_term_def.json"
        , expect = Http.expectJson GotItem (decodeItem sampleReference)
        }
    )


update : Message -> Model -> ( Model, Cmd Message )
update msg model =
    case msg of
        WorkspaceItemMsg workspaceItemMsg ->
            case workspaceItemMsg of
                UpdateZoom _ zoom ->
                    case model.workspaceItem of
                        Nothing ->
                            ( model, Cmd.none )

                        Just item ->
                            case item of
                                Success ref itemData ->
                                    let
                                        updatedData =
                                            { itemData | zoom = zoom }

                                        updatedModel =
                                            { model
                                                | workspaceItem = Just <| Success ref updatedData
                                            }
                                    in
                                    ( updatedModel, Cmd.none )

                                _ ->
                                    ( model, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        GotItem result ->
            case result of
                Err error ->
                    ( model, Cmd.none )

                Ok item ->
                    ( { model
                        | workspaceItem = Just (fromItem sampleReference item.item)
                      }
                    , Cmd.none
                    )


view : Model -> Html Message
view model =
    case model.workspaceItem of
        Nothing ->
            Html.text "No item"

        Just item ->
            Code.Workspace.WorkspaceItem.view
                Code.Workspace.WorkspaceItem.viewState
                UI.ViewMode.Regular
                item
                True
                |> Html.map WorkspaceItemMsg
