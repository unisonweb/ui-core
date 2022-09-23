module Code.CodebaseTree.NamespaceListingTests exposing (..)

import Code.CodebaseTree.NamespaceListing as NamespaceListing
    exposing
        ( DefinitionListing(..)
        , NamespaceListing(..)
        , NamespaceListingChild(..)
        )
import Code.Definition.Category exposing (Category(..))
import Code.Definition.Term exposing (TermCategory(..))
import Code.Definition.Type exposing (TypeCategory(..))
import Code.FullyQualifiedName as FQN
import Code.Hash as Hash
import Expect
import RemoteData exposing (RemoteData(..))
import Test exposing (..)


map : Test
map =
    describe "CodebaseTree.NamespaceListing.map"
        [ test "runs the function on deeply nestes namespaces" <|
            \_ ->
                let
                    hashA =
                        Hash.fromString "#a"

                    hashB =
                        Hash.fromString "#c"

                    hashC =
                        Hash.fromString "#b"

                    fqnA =
                        FQN.fromString "a"

                    fqnB =
                        FQN.fromString "a.b"

                    fqnC =
                        FQN.fromString "a.b.c"

                    original =
                        Maybe.map3
                            (\ha hb hc ->
                                NamespaceListing ha
                                    fqnA
                                    (Success
                                        [ SubNamespace
                                            (NamespaceListing
                                                hb
                                                fqnB
                                                (Success [ SubNamespace (NamespaceListing hc fqnC NotAsked) ])
                                            )
                                        ]
                                    )
                            )
                            hashA
                            hashB
                            hashC

                    expected =
                        Maybe.map3
                            (\ha hb hc ->
                                NamespaceListing ha
                                    fqnA
                                    (Success
                                        [ SubNamespace
                                            (NamespaceListing
                                                hb
                                                fqnB
                                                (Success [ SubNamespace (NamespaceListing hc fqnC Loading) ])
                                            )
                                        ]
                                    )
                            )
                            hashA
                            hashB
                            hashC

                    f ((NamespaceListing h fqn _) as nl) =
                        if FQN.equals fqn fqnC then
                            NamespaceListing h fqn Loading

                        else
                            nl

                    result =
                        Maybe.map (NamespaceListing.map f) original
                in
                Expect.equal expected result
        ]


sortContent : Test
sortContent =
    describe "CodebaseTree.NamespaceListing.sort"
        [ test "Sorts NamespaceContent alphabetically by FQN, case insensitive" <|
            \_ ->
                let
                    content =
                        [ SubDefinition (TypeListing (Hash.unsafeFromString "#Bytes") (FQN.fromString "Bytes") (Type DataType))
                        , SubNamespace (NamespaceListing (Hash.unsafeFromString "#Bytes") (FQN.fromString "Bytes") NotAsked)
                        , SubDefinition (TypeListing (Hash.unsafeFromString "#IO") (FQN.fromString "IO") (Type DataType))
                        , SubDefinition (PatchListing "patch")
                        , SubNamespace (NamespaceListing (Hash.unsafeFromString "#IO") (FQN.fromString "IO") NotAsked)
                        , SubDefinition (TermListing (Hash.unsafeFromString "#bug") (FQN.fromString "bug") (Term PlainTerm))
                        , SubDefinition (TermListing (Hash.unsafeFromString "#y") (FQN.fromString "y") (Term PlainTerm))
                        , SubDefinition (TermListing (Hash.unsafeFromString "#delay") (FQN.fromString "delay") (Term PlainTerm))
                        ]

                    expected =
                        [ SubDefinition (TermListing (Hash.unsafeFromString "#bug") (FQN.fromString "bug") (Term PlainTerm))
                        , SubDefinition (TypeListing (Hash.unsafeFromString "#Bytes") (FQN.fromString "Bytes") (Type DataType))
                        , SubNamespace (NamespaceListing (Hash.unsafeFromString "#Bytes") (FQN.fromString "Bytes") NotAsked)
                        , SubDefinition (TermListing (Hash.unsafeFromString "#delay") (FQN.fromString "delay") (Term PlainTerm))
                        , SubDefinition (TypeListing (Hash.unsafeFromString "#IO") (FQN.fromString "IO") (Type DataType))
                        , SubNamespace (NamespaceListing (Hash.unsafeFromString "#IO") (FQN.fromString "IO") NotAsked)
                        , SubDefinition (PatchListing "patch")
                        , SubDefinition (TermListing (Hash.unsafeFromString "#y") (FQN.fromString "y") (Term PlainTerm))
                        ]

                    result =
                        NamespaceListing.sortContent content
                in
                Expect.equal expected result
        ]
