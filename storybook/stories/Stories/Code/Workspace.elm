module Stories.Code.Workspace exposing (..)

import Browser
import Code.DefinitionSummaryTooltip
import Code.Syntax exposing (..)
import Code.Workspace exposing (Model, Msg(..))
import Code.Workspace.WorkspaceItem exposing (Item, WorkspaceItem(..), decodeItem, decodeList, fromItem)
import Code.Workspace.WorkspaceItems exposing (WorkspaceItems, empty, fromItems)
import Code.Workspace.Zoom exposing (Zoom(..))
import Dict
import Helpers.Layout exposing (col)
import Helpers.ReferenceHelper exposing (sampleReference)
import Html exposing (Html)
import Json.Decode exposing (decodeString)
import Lib.OperatingSystem
import UI.KeyboardShortcut
import UI.KeyboardShortcut.Key
import UI.ViewMode


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
    case makeWorkspaceItems of
        Err _ ->
            ( makeWorkspaceModel, Cmd.none )

        Ok workspaceItems ->
            ( { makeWorkspaceModel | workspaceItems = workspaceItems }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    case makeWorkspaceItems of
        Err _ ->
            ( model, Cmd.none )

        Ok workspaceItems ->
            ( { model | workspaceItems = workspaceItems }, Cmd.none )



-- case msg of
--     UpdateZoom _ zoom ->
--         ( { model | zoom = zoom }, Cmd.none )
--     _ ->
--         ( model, Cmd.none )


decodeItemList : Result Json.Decode.Error (List Item)
decodeItemList =
    decodeString (decodeList sampleReference) incrementGetDefinitionResponse


decodeSingleItem : Result Json.Decode.Error Item
decodeSingleItem =
    decodeString (decodeItem sampleReference) incrementGetDefinitionResponse


sampleKeyboardShortcut : UI.KeyboardShortcut.Model
sampleKeyboardShortcut =
    UI.KeyboardShortcut.init Lib.OperatingSystem.MacOS


makeWorkspaceModel : Model
makeWorkspaceModel =
    { workspaceItems = empty
    , keyboardShortcut = sampleKeyboardShortcut
    , definitionSummaryTooltip = Code.DefinitionSummaryTooltip.init
    }


makeWorkspaceItems : Result Json.Decode.Error WorkspaceItems
makeWorkspaceItems =
    case decodeItemList of
        Err error ->
            Result.Err error

        Ok source ->
            case decodeSingleItem of
                Err err ->
                    Result.Err err

                Ok singleItemRaw ->
                    let
                        workspaceItems =
                            List.map (fromItem sampleReference) source

                        singleItem =
                            fromItem sampleReference singleItemRaw
                    in
                    Ok <| fromItems workspaceItems singleItem workspaceItems


view : Model -> Html Msg
view model =
    Code.Workspace.view UI.ViewMode.Regular model



-- let
--     decodeResult : Result Json.Decode.Error (List Item)
--     decodeResult =
--         let
--             result =
--                 decodeString (decodeList sampleReference) incrementGetDefinitionResponse
--         in
--         result
-- in
-- case decodeResult of
--     Err error ->
--         col [] [ Html.text (Json.Decode.errorToString error) ]
--     Ok source ->
--         List.map
--             (viewItem model)
--             source
--             |> col []
-- viewItem : Model -> Item -> Html Code.Workspace.WorkspaceItem.Msg
-- viewItem model item =
--     let
--         workspaceItem =
--             fromItem sampleReference item
--     in
--     case workspaceItem of
--         Success ref originalItem ->
--             let
--                 updatedItem =
--                     { originalItem
--                         | zoom = model.zoom
--                     }
--             in
--             Code.Workspace.WorkspaceItem.view
--                 { activeTooltip = Nothing, summaries = Dict.empty }
--                 UI.ViewMode.Regular
--                 (Success ref updatedItem)
--                 True
--         Loading _ ->
--             Code.Workspace.WorkspaceItem.view
--                 { activeTooltip = Nothing, summaries = Dict.empty }
--                 UI.ViewMode.Regular
--                 workspaceItem
--                 True
--         Failure _ _ ->
--             Code.Workspace.WorkspaceItem.view
--                 { activeTooltip = Nothing, summaries = Dict.empty }
--                 UI.ViewMode.Regular
--                 workspaceItem
--                 True


incrementGetDefinitionResponse : String
incrementGetDefinitionResponse =
    """
  {
    "termDefinitions": {
        "#t7g50rohbm1c45qnvv2fiaupft4qqoduakqhj6k8fcmh1n75d4spgma4gvu1r6ip0nbn8dhv5vue4imeopnug13rnooft0abqq3uqgg": {
            "termNames": [
                "increment"
            ],
            "bestTermName": "increment",
            "defnTermTag": "Plain",
            "termDefinition": {
                "tag": "UserObject",
                "contents": [
                    {
                        "annotation": {
                            "contents": "increment",
                            "tag": "HashQualifier"
                        },
                        "segment": "increment"
                    },
                    {
                        "annotation": {
                            "tag": "TypeAscriptionColon"
                        },
                        "segment": " :"
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
                            "contents": "##Nat",
                            "tag": "TypeReference"
                        },
                        "segment": "Nat"
                    },
                    {
                        "annotation": null,
                        "segment": "\\n"
                    },
                    {
                        "annotation": {
                            "contents": "increment",
                            "tag": "HashQualifier"
                        },
                        "segment": "increment"
                    },
                    {
                        "annotation": null,
                        "segment": " "
                    },
                    {
                        "annotation": {
                            "tag": "Var"
                        },
                        "segment": "input"
                    },
                    {
                        "annotation": {
                            "tag": "BindingEquals"
                        },
                        "segment": " ="
                    },
                    {
                        "annotation": null,
                        "segment": "\\n"
                    },
                    {
                        "annotation": null,
                        "segment": "  "
                    },
                    {
                        "annotation": {
                            "tag": "UseKeyword"
                        },
                        "segment": "use "
                    },
                    {
                        "annotation": {
                            "tag": "UsePrefix"
                        },
                        "segment": "Nat"
                    },
                    {
                        "annotation": null,
                        "segment": " "
                    },
                    {
                        "annotation": {
                            "tag": "UseSuffix"
                        },
                        "segment": "+"
                    },
                    {
                        "annotation": null,
                        "segment": "\\n"
                    },
                    {
                        "annotation": null,
                        "segment": "  "
                    },
                    {
                        "annotation": {
                            "tag": "Var"
                        },
                        "segment": "input"
                    },
                    {
                        "annotation": null,
                        "segment": " "
                    },
                    {
                        "annotation": {
                            "contents": "##Nat.+",
                            "tag": "TermReference"
                        },
                        "segment": "+"
                    },
                    {
                        "annotation": null,
                        "segment": " "
                    },
                    {
                        "annotation": {
                            "tag": "NumericLiteral"
                        },
                        "segment": "1"
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
                }
            ],
            "termDocs": [
                [
                    "increment.doc",
                    "#9f1venepo9524lpcpb1b94t1nlo8gucqd2f9ldoogl2u8thdip75qcjv8ufsdc551o69chg92od6paarvuvrh8fiondi5es1414bo3g",
                    {
                        "contents": [
                            {
                                "contents": "Some",
                                "tag": "Word"
                            },
                            {
                                "contents": "documentation",
                                "tag": "Word"
                            }
                        ],
                        "tag": "Paragraph"
                    }
                ]
            ]
        }
    },
    "typeDefinitions": {},
    "missingDefinitions": []
}
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
