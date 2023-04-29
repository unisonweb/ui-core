module Stories.Code.WorkspaceItemSample exposing (..)

import Code.Workspace.WorkspaceItem exposing (Item, WorkspaceItem, decodeItem, decodeList, fromItem)
import Helpers.ReferenceHelper exposing (sampleReference)
import Html.Attributes.Autocomplete exposing (ContactType(..))
import Json.Decode exposing (decodeString)


decodeSampleWorkspaceItemList : Result Json.Decode.Error (List WorkspaceItem)
decodeSampleWorkspaceItemList =
    decodeSampleItemList
        |> Result.map (List.map (fromItem sampleReference))


decodeSampleWorkspaceItem : Result Json.Decode.Error WorkspaceItem
decodeSampleWorkspaceItem =
    decodeSampleSingleItem
        |> Result.map (fromItem sampleReference)


decodeSampleItemList : Result Json.Decode.Error (List Item)
decodeSampleItemList =
    incrementGetDefinitionResponse
        |> decodeString (decodeList sampleReference)


decodeSampleSingleItem : Result Json.Decode.Error Item
decodeSampleSingleItem =
    incrementGetDefinitionResponse
        |> decodeString (decodeItem sampleReference)


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
