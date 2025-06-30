module Code.FullyQualifiedNameTests exposing (..)

import Code.FullyQualifiedName as FQN exposing (..)
import Expect
import List.Nonempty as NEL
import Test exposing (..)


cons : Test
cons =
    describe "FullyQualifiedName.cons"
        [ test "cons a String to the front of the FQN segments" <|
            \_ ->
                let
                    list =
                        FQN.fromString "List"
                in
                Expect.equal [ "base", "List" ] (segments (FQN.cons "base" list))
        ]


snoc : Test
snoc =
    describe "FullyQualifiedName.snoc"
        [ test "snoc a String to the end of the FQN segments" <|
            \_ ->
                let
                    list =
                        FQN.fromString "List"
                in
                Expect.equal [ "List", "map" ] (segments (FQN.snoc list "map"))
        ]


dropLast : Test
dropLast =
    describe "FullyQualifiedName.dropLast"
        [ test "removes the last segment" <|
            \_ ->
                let
                    fqn =
                        FQN.fromString "base.List.map"
                in
                Expect.equal [ "base", "List" ] (segments (FQN.dropLast fqn))
        , test "keeps the last segment" <|
            \_ ->
                let
                    fqn =
                        FQN.fromString "List"
                in
                Expect.equal [ "List" ] (segments (FQN.dropLast fqn))
        ]


append : Test
append =
    describe "FullyQualifiedName.append"
        [ test "Appends 2 FQNs" <|
            \_ ->
                let
                    a =
                        FQN.fromString "base"

                    b =
                        FQN.fromString "List"
                in
                Expect.equal [ "base", "List" ] (segments (FQN.append a b))
        , test "Appending doesn't attempt to dedupe" <|
            \_ ->
                let
                    a =
                        FQN.fromString "base"

                    b =
                        FQN.fromString "base.List"
                in
                Expect.equal [ "base", "base", "List" ] (segments (FQN.append a b))
        ]


extend : Test
extend =
    describe "FullyQualifiedName.extend"
        [ test "extends 2 FQNs, keeping the start of the FQNs the same when they overlap" <|
            \_ ->
                let
                    a =
                        FQN.fromString "a.b.c"

                    b =
                        FQN.fromString "a.b.c.d.e.f"
                in
                Expect.equal "a.b.c.d.e.f" (FQN.toString (FQN.extend a b))
        , test "extends 2 FQNs, keeping overlaps only when fully overlapping the left side" <|
            \_ ->
                let
                    a =
                        FQN.fromString "a.b.c"

                    b =
                        FQN.fromString "a.k.e.f"
                in
                Expect.equal "a.b.c.a.k.e.f" (FQN.toString (FQN.extend a b))
        , test "Appends the 2 FQNs when there's no overlap" <|
            \_ ->
                let
                    a =
                        FQN.fromString "a.b.c"

                    b =
                        FQN.fromString "e.f"
                in
                Expect.equal "a.b.c.e.f" (FQN.toString (FQN.extend a b))
        ]


stripPrefix : Test
stripPrefix =
    describe "FullyQualifiedName.stripPrefix"
        [ test "removes the prefix if present" <|
            \_ ->
                let
                    a =
                        FQN.fromString "a.b.c"

                    b =
                        FQN.fromString "a.b.c.d.e.f"
                in
                Expect.equal "d.e.f" (FQN.toString (FQN.stripPrefix a b))
        , test "removes nothing if the prefix is not present" <|
            \_ ->
                let
                    a =
                        FQN.fromString "a.b.c"

                    b =
                        FQN.fromString "a.k.e.f"
                in
                Expect.equal "a.k.e.f" (FQN.toString (FQN.stripPrefix a b))
        , test "Appends the 2 FQNs when there's no overlap" <|
            \_ ->
                let
                    a =
                        FQN.fromString "a.b.c"

                    b =
                        FQN.fromString "e.f"
                in
                Expect.equal "a.b.c.e.f" (FQN.toString (FQN.extend a b))
        ]


fromString : Test
fromString =
    describe "FullyQualifiedName.fromString"
        [ test "Creates an FQN from a string" <|
            \_ ->
                Expect.equal [ "a", "b", "c" ] (segments (FQN.fromString "a.b.c"))
        , test "Creates an FQN from a string where a segment includes a dot (like the composition operatory)" <|
            \_ ->
                Expect.equal [ "base", "." ] (segments (FQN.fromString "base.."))
        , describe "Root"
            [ test "Creates a root FQN from \"\"" <|
                \_ ->
                    Expect.equal [ "." ] (segments (FQN.fromString ""))
            , test "Creates a root FQN from \" \"" <|
                \_ ->
                    Expect.equal [ "." ] (segments (FQN.fromString " "))
            , test "Creates a root FQN from \".\"" <|
                \_ ->
                    Expect.equal [ "." ] (segments (FQN.fromString "."))
            ]
        ]


fromUrlString : Test
fromUrlString =
    describe "FullyQualifiedName.fromUrlString"
        [ test "Creates an FQN from a URL string (segments separate by /)" <|
            \_ ->
                Expect.equal [ "a", "b", "c" ] (segments (FQN.fromUrlString "a/b/c"))
        , test "Supports . in segments (compose)" <|
            \_ ->
                Expect.equal [ "a", "b", "." ] (segments (FQN.fromUrlString "a/b/."))
        , test "Supports special characters in segments" <|
            \_ ->
                let
                    results =
                        [ segments (FQN.fromUrlString "a/b/+")
                        , segments (FQN.fromUrlString "a/b/*")
                        , segments (FQN.fromUrlString "a/b/%2F") -- /
                        , segments (FQN.fromUrlString "a/b/%25") -- %
                        , segments (FQN.fromUrlString "a/b/!")
                        , segments (FQN.fromUrlString "a/b/-")
                        , segments (FQN.fromUrlString "a/b/==")
                        , segments (FQN.fromUrlString "a/b/%F0%9F%90%A2") -- 🐢
                        ]

                    expects =
                        [ [ "a", "b", "+" ]
                        , [ "a", "b", "*" ]
                        , [ "a", "b", "/" ]
                        , [ "a", "b", "%" ]
                        , [ "a", "b", "!" ]
                        , [ "a", "b", "-" ]
                        , [ "a", "b", "==" ]
                        , [ "a", "b", "🐢" ]
                        ]
                in
                Expect.equal expects results
        , describe "Root"
            [ test "Creates a root FQN from \"\"" <|
                \_ ->
                    Expect.equal [ "." ] (segments (FQN.fromUrlString ""))
            , test "Creates a root FQN from \" \"" <|
                \_ ->
                    Expect.equal [ "." ] (segments (FQN.fromUrlString " "))
            , test "Creates a root FQN from \"/\"" <|
                \_ ->
                    Expect.equal [ "." ] (segments (FQN.fromUrlString "/"))
            ]
        ]


toString : Test
toString =
    describe "FullyQualifiedName.toString with segments separate by ."
        [ test "serializes the FQN" <|
            \_ ->
                Expect.equal "foo.bar" (FQN.toString (FQN.fromString "foo.bar"))
        , test "it supports . as term names (compose)" <|
            \_ ->
                Expect.equal "foo.bar.." (FQN.toString (FQN.fromString "foo.bar.."))
        ]


toUrlString : Test
toUrlString =
    describe "FullyQualifiedName.toUrlString"
        [ test "serializes the FQN with segments separate by /" <|
            \_ ->
                Expect.equal "foo/bar" (FQN.toUrlString (FQN.fromString "foo.bar"))
        , test "URL encodes / (divide) segments" <|
            \_ ->
                Expect.equal "foo/bar/%2F/doc" (FQN.toUrlString (FQN.fromString "foo.bar./.doc"))
        , test "URL encodes % segments" <|
            \_ ->
                Expect.equal "foo/bar/%25/doc" (FQN.toUrlString (FQN.fromString "foo.bar.%.doc"))
        , test "URL encodes . segments with a ; prefix" <|
            \_ ->
                Expect.equal "foo/bar/;./doc" (FQN.toUrlString (FQN.fromString "foo.bar...doc"))
        ]


fromParent : Test
fromParent =
    describe "FullyQualifiedName.fromParent"
        [ test "Combines a name and parent FQN" <|
            \_ ->
                Expect.equal "foo.bar.baz" (FQN.toString (FQN.fromParent (FQN.fromString "foo.bar") "baz"))
        ]


unqualifiedName : Test
unqualifiedName =
    describe "FullyQualifiedName.unqualifiedName"
        [ test "Extracts the last portion of a FQN" <|
            \_ ->
                Expect.equal "List" (FQN.unqualifiedName (FQN.fromString "base.List"))
        ]


isSuffixOf : Test
isSuffixOf =
    describe "FullyQualifiedName.isSuffixOf"
        [ test "Returns True when an FQN ends in the provided suffix" <|
            \_ ->
                let
                    suffix =
                        FQN.fromString "List.map"

                    fqn =
                        FQN.fromString "base.List.map"
                in
                FQN.isSuffixOf suffix fqn
                    |> Expect.equal True
                    |> Expect.onFail "is correctly a suffix of"
        , test "Returns False when an FQN does not end in the provided suffix" <|
            \_ ->
                let
                    suffix =
                        FQN.fromString "List.foldl"

                    fqn =
                        FQN.fromString "base.List.map"
                in
                FQN.isSuffixOf suffix fqn
                    |> Expect.equal False
                    |> Expect.onFail "is correctly *not* a suffix of"
        ]


isPrefixOf : Test
isPrefixOf =
    describe "FullyQualifiedName.isPrefixOf"
        [ test "Returns True when an FQN begin with the provided prefix" <|
            \_ ->
                let
                    prefix =
                        FQN.fromString "base.List"

                    fqn =
                        FQN.fromString "base.List.map"
                in
                FQN.isPrefixOf prefix fqn
                    |> Expect.equal True
                    |> Expect.onFail "is correctly a prefix of"
        , test "Returns False when an FQN does begin with the provided prefix" <|
            \_ ->
                let
                    prefix =
                        FQN.fromString "base.Text"

                    fqn =
                        FQN.fromString "base.List.map"
                in
                FQN.isPrefixOf prefix fqn
                    |> Expect.equal False
                    |> Expect.onFail "is correctly *not* a prefix of"
        ]


namespaceOf : Test
namespaceOf =
    describe "FullyQualifiedName.namespaceOf"
        [ test "With an FQN including the suffix, it returns the non suffix part" <|
            \_ ->
                let
                    suffix =
                        FQN.fromString "List.map"

                    fqn =
                        FQN.fromString "base.List.map"
                in
                Expect.equal (Just "base") (FQN.namespaceOf suffix fqn)
        , test "When the suffix and FQN are exactly the same, it returns Nothing" <|
            \_ ->
                let
                    suffix =
                        FQN.fromString "base.List.map"

                    fqn =
                        FQN.fromString "base.List.map"
                in
                Expect.equal Nothing (FQN.namespaceOf suffix fqn)
        , test "When the suffix is not included at all in the FQN, it returns Nothing" <|
            \_ ->
                let
                    suffix =
                        FQN.fromString "List.map.foldl"

                    fqn =
                        FQN.fromString "base.List.map"
                in
                Expect.equal Nothing (FQN.namespaceOf suffix fqn)
        , test "When the suffix is included more than once, only the last match of the FQN is removed" <|
            \_ ->
                let
                    suffix =
                        FQN.fromString "Map"

                    fqn =
                        FQN.fromString "base.Map.Map"
                in
                Expect.equal (Just "base.Map") (FQN.namespaceOf suffix fqn)
        ]


namespace : Test
namespace =
    describe "FullyQualifiedName.namespace"
        [ test "removes qualified name" <|
            \_ ->
                let
                    fqn =
                        FQN.fromString "base.List.map"
                in
                Expect.equal (Just (FQN.fromString "base.List")) (FQN.namespace fqn)
        , test "with an FQN of only 1 segment, it returns Nothing" <|
            \_ ->
                let
                    fqn =
                        FQN.fromString "map"
                in
                Expect.equal Nothing (FQN.namespace fqn)
        ]


toApiUrlString : Test
toApiUrlString =
    describe "FullyQualifiedName.toApiUrlString"
        [ test "URI encodes the name" <|
            \_ ->
                let
                    fqn =
                        FQN.fromString "base.List.map.🐢"

                    result =
                        FQN.toApiUrlString fqn
                in
                Expect.equal "base.List.map.%F0%9F%90%A2" result
        ]



-- HELPERS


segments : FQN -> List String
segments =
    FQN.segments >> NEL.toList
