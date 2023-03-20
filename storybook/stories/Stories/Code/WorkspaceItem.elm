module Stories.Code.WorkspaceItem exposing (..)

import Browser
import Code.Syntax exposing (..)
import Code.Workspace.WorkspaceItem exposing (Item, Msg(..), WorkspaceItem(..), decodeList, fromItem)
import Code.Workspace.Zoom exposing (Zoom(..))
import Dict
import Helpers.Layout exposing (col)
import Helpers.ReferenceHelper exposing (sampleReference)
import Html exposing (Html)
import Json.Decode exposing (decodeString)
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
    let
        decodeResult : Result Json.Decode.Error (List Item)
        decodeResult =
            let
                result =
                    decodeString (decodeList sampleReference) incrementGetDefinitionResponse
            in
            result
    in
    case decodeResult of
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


incrementGetDefinitionResponse : String
incrementGetDefinitionResponse =
    """
  {"termDefinitions":{"#t7g50rohbm1c45qnvv2fiaupft4qqoduakqhj6k8fcmh1n75d4spgma4gvu1r6ip0nbn8dhv5vue4imeopnug13rnooft0abqq3uqgg":{"termNames":["increment"],"bestTermName":"increment","defnTermTag":"Plain","termDefinition":{"tag":"UserObject","contents":[{"annotation":{"contents":"increment","tag":"HashQualifier"},"segment":"increment"},{"annotation":{"tag":"TypeAscriptionColon"},"segment":" :"},{"annotation":null,"segment":" "},{"annotation":{"contents":"##Nat","tag":"TypeReference"},"segment":"Nat"},{"annotation":null,"segment":" "},{"annotation":{"tag":"TypeOperator"},"segment":"->"},{"annotation":null,"segment":" "},{"annotation":{"contents":"##Nat","tag":"TypeReference"},"segment":"Nat"},{"annotation":null,"segment":"\\n"},{"annotation":{"contents":"increment","tag":"HashQualifier"},"segment":"increment"},{"annotation":null,"segment":" "},{"annotation":{"tag":"Var"},"segment":"input"},{"annotation":{"tag":"BindingEquals"},"segment":" ="},{"annotation":null,"segment":"\\n"},{"annotation":null,"segment":"  "},{"annotation":{"tag":"UseKeyword"},"segment":"use "},{"annotation":{"tag":"UsePrefix"},"segment":"Nat"},{"annotation":null,"segment":" "},{"annotation":{"tag":"UseSuffix"},"segment":"+"},{"annotation":null,"segment":"\\n"},{"annotation":null,"segment":"  "},{"annotation":{"tag":"Var"},"segment":"input"},{"annotation":null,"segment":" "},{"annotation":{"contents":"##Nat.+","tag":"TermReference"},"segment":"+"},{"annotation":null,"segment":" "},{"annotation":{"tag":"NumericLiteral"},"segment":"1"}]},"signature":[{"annotation":{"contents":"##Nat","tag":"TypeReference"},"segment":"Nat"},{"annotation":null,"segment":" "},{"annotation":{"tag":"TypeOperator"},"segment":"->"},{"annotation":null,"segment":" "},{"annotation":{"contents":"##Nat","tag":"TypeReference"},"segment":"Nat"}],"termDocs":[["increment.doc","#9f1venepo9524lpcpb1b94t1nlo8gucqd2f9ldoogl2u8thdip75qcjv8ufsdc551o69chg92od6paarvuvrh8fiondi5es1414bo3g",{"contents":[{"contents":"Some","tag":"Word"},{"contents":"documentation","tag":"Word"}],"tag":"Paragraph"}]]}},"typeDefinitions":{},"missingDefinitions":[]}
    """


natGtGetDefinitionResponse : String
natGtGetDefinitionResponse =
    """
{
    "termDefinitions": {
        "##Nat.>": {
            "termNames": [
                "base.Nat.gt",
                "base.Nat.>",
                "lab.lib.base.Nat.>",
                "lab.lib.base.Nat.gt"
            ],
            "bestTermName": "Nat.gt",
            "defnTermTag": "Plain",
            "termDefinition": {
                "tag": "BuiltinObject",
                "contents": [
                    {
                        "annotation": {
                            "contents": "##Nat",
                            "tag": "TypeReference"
                        },
                        "segment": "Nat"
                    },
                    {
                        "annotation": null,
                        "segment": " "
                    },
                    {
                        "annotation": {
                            "tag": "TypeOperator"
                        },
                        "segment": "->"
                    },
                    {
                        "annotation": null,
                        "segment": " "
                    },
                    {
                        "annotation": {
                            "contents": "##Nat",
                            "tag": "TypeReference"
                        },
                        "segment": "Nat"
                    },
                    {
                        "annotation": null,
                        "segment": " "
                    },
                    {
                        "annotation": {
                            "tag": "TypeOperator"
                        },
                        "segment": "->"
                    },
                    {
                        "annotation": null,
                        "segment": " "
                    },
                    {
                        "annotation": {
                            "contents": "##Boolean",
                            "tag": "TypeReference"
                        },
                        "segment": "Boolean"
                    }
                ]
            },
            "signature": [
                {
                    "annotation": {
                        "contents": "##Nat",
                        "tag": "TypeReference"
                    },
                    "segment": "Nat"
                },
                {
                    "annotation": null,
                    "segment": " "
                },
                {
                    "annotation": {
                        "tag": "TypeOperator"
                    },
                    "segment": "->"
                },
                {
                    "annotation": null,
                    "segment": " "
                },
                {
                    "annotation": {
                        "contents": "##Nat",
                        "tag": "TypeReference"
                    },
                    "segment": "Nat"
                },
                {
                    "annotation": null,
                    "segment": " "
                },
                {
                    "annotation": {
                        "tag": "TypeOperator"
                    },
                    "segment": "->"
                },
                {
                    "annotation": null,
                    "segment": " "
                },
                {
                    "annotation": {
                        "contents": "##Boolean",
                        "tag": "TypeReference"
                    },
                    "segment": "Boolean"
                }
            ],
            "termDocs": []
        }
    },
    "typeDefinitions": {},
    "missingDefinitions": []
}
"""
