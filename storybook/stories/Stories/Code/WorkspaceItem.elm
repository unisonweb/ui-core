module Stories.Code.WorkspaceItem exposing (..)

import Browser
import Code.Syntax exposing (..)
import Code.Workspace.WorkspaceItem exposing (Item, Msg(..), WorkspaceItem(..), fromItem)
import Code.Workspace.Zoom exposing (Zoom(..))
import Dict
import Helpers.Layout exposing (col)
import Helpers.ReferenceHelper exposing (sampleReference)
import Html exposing (Html)
import Json.Decode
import Stories.Code.WorkspaceItemSample exposing (decodeSampleItemList)
import UI.ViewMode


type alias Model =
    { zoom : Zoom
    }


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( { zoom = Near }, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateZoom _ zoom ->
            ( { model | zoom = zoom }, Cmd.none )

        _ ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    case decodeSampleItemList of
        Err error ->
            col [] [ Html.text (Json.Decode.errorToString error) ]

        Ok source ->
            List.map
                (viewItem model)
                source
                |> col []


viewItem : Model -> Item -> Html Code.Workspace.WorkspaceItem.Msg
viewItem model item =
    let
        workspaceItem =
            fromItem sampleReference item
    in
    case workspaceItem of
        Success ref originalItem ->
            let
                updatedItem =
                    { originalItem
                        | zoom = model.zoom
                    }
            in
            Code.Workspace.WorkspaceItem.view
                { activeTooltip = Nothing, summaries = Dict.empty }
                UI.ViewMode.Regular
                (Success ref updatedItem)
                True

        Loading _ ->
            Code.Workspace.WorkspaceItem.view
                { activeTooltip = Nothing, summaries = Dict.empty }
                UI.ViewMode.Regular
                workspaceItem
                True

        Failure _ _ ->
            Code.Workspace.WorkspaceItem.view
                { activeTooltip = Nothing, summaries = Dict.empty }
                UI.ViewMode.Regular
                workspaceItem
                True
