module Code.Definition.InfoTests exposing (..)

import Code.Definition.Info as Info
import Code.Definition.Reference as Reference exposing (Reference(..))
import Code.FullyQualifiedName as FQN
import Expect
import List.Nonempty as NEL
import Test exposing (..)


namespaceAndOtherNames : Test
namespaceAndOtherNames =
    describe "Info.namespaceAndOtherNames"
        [ test "does not have duplicates in otherNames" <|
            \_ ->
                let
                    result =
                        Info.namespaceAndOtherNames
                            (Reference.fromString TermReference "List.map")
                            (FQN.fromString "map")
                            (NEL.Nonempty
                                (FQN.fromString "List.map")
                                [ FQN.fromString "base.List.map", FQN.fromString "something.else.List.map", FQN.fromString "base.List.map" ]
                            )

                    otherNames =
                        Tuple.second result |> List.map FQN.toString

                    expected =
                        [ "base.List.map", "something.else.List.map" ]
                in
                Expect.equal expected otherNames
        , test "does not have overlap in namespace" <|
            \_ ->
                let
                    result =
                        Info.namespaceAndOtherNames
                            (Reference.fromString TermReference "BlogAuthor.bio.modify")
                            (FQN.fromString "bio.modify")
                            (NEL.Nonempty
                                (FQN.fromString "BlogAuthor.bio.modify")
                                [ FQN.fromString "Bio.change" ]
                            )

                    namespace =
                        Tuple.first result |> Maybe.map FQN.toString

                    otherNames =
                        Tuple.second result |> List.map FQN.toString

                    expected =
                        ( Just "BlogAuthor", [ "Bio.change" ] )
                in
                Expect.equal expected ( namespace, otherNames )
        ]
