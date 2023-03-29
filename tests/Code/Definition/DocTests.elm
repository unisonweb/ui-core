module Code.Definition.DocTests exposing (..)

import Code.Definition.Doc as Doc exposing (Doc(..))
import Expect
import Lib.TreePath as TreePath
import Test exposing (..)


mergeWords : Test
mergeWords =
    describe "Doc.mergeWords"
        [ test "merges adjacent Word elements with a separator" <|
            \_ ->
                let
                    before =
                        [ Word "Hello", Word "World", Blankline, Word "After", Word "non", Word "word" ]

                    expected =
                        [ Word "Hello World", Blankline, Word "After non word" ]
                in
                Expect.equal expected (Doc.mergeWords " " before)
        ]


isDocFoldToggled : Test
isDocFoldToggled =
    describe "Doc.isDocFoldToggled"
        [ test "returns True if the doc is toggled" <|
            \_ ->
                let
                    toggles =
                        Doc.toggleFold Doc.emptyDocFoldToggles id
                in
                Doc.isDocFoldToggled toggles id
                    |> Expect.equal True
                    |> Expect.onFail "doc is toggled"
        , test "returns False if the doc is not toggled" <|
            \_ ->
                let
                    toggles =
                        Doc.emptyDocFoldToggles
                in
                Doc.isDocFoldToggled toggles id
                    |> Expect.equal False
                    |> Expect.onFail "doc is not toggled"
        ]


toString : Test
toString =
    describe "Doc.toString"
        [ test "merges docs down to a string with a separator" <|
            \_ ->
                let
                    before =
                        Span [ Word "Hello", Word "World", Blankline, Word "After", Word "non", Word "word" ]

                    expected =
                        "Hello World After non word"
                in
                Expect.equal expected (Doc.toString " " before)
        ]


toggleFold : Test
toggleFold =
    describe "Doc.toggleFold"
        [ test "Adds a toggle if not present" <|
            \_ ->
                let
                    toggles =
                        Doc.toggleFold Doc.emptyDocFoldToggles id
                in
                Doc.isDocFoldToggled toggles id
                    |> Expect.equal True
                    |> Expect.onFail "doc was added"
        , test "Removes a toggle if present" <|
            \_ ->
                let
                    toggles =
                        Doc.toggleFold Doc.emptyDocFoldToggles id

                    without =
                        Doc.toggleFold toggles id
                in
                Doc.isDocFoldToggled without id
                    |> Expect.equal False
                    |> Expect.onFail "doc was removed"
        ]



-- Helpers


id : Doc.FoldId
id =
    Doc.FoldId [ TreePath.VariantIndex 0, TreePath.ListIndex 3 ]
