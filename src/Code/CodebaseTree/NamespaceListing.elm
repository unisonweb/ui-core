module Code.CodebaseTree.NamespaceListing exposing
    ( DefinitionListing(..)
    , NamespaceListing(..)
    , NamespaceListingChild(..)
    , NamespaceListingContent
    , contentFetched
    , decode
    , map
    , sortContent
    )

import Code.Definition.Category as Category exposing (Category)
import Code.Definition.Term as Term
import Code.Definition.Type as Type
import Code.FullyQualifiedName as FQN exposing (FQN)
import Code.Hash as Hash exposing (Hash)
import Json.Decode as Decode exposing (field)
import Lib.Decode.Helpers exposing (whenPathIs, whenTagIs)
import Lib.UnicodeSort as UnicodeSort
import RemoteData exposing (RemoteData(..), WebData)


type DefinitionListing
    = TypeListing Hash FQN Category
    | TermListing Hash FQN Category
    | DataConstructorListing Hash FQN
    | AbilityConstructorListing Hash FQN
    | PatchListing String


type alias NamespaceListingContent =
    List NamespaceListingChild


type NamespaceListingChild
    = SubNamespace NamespaceListing
    | SubDefinition DefinitionListing


type NamespaceListing
    = NamespaceListing Hash FQN (WebData NamespaceListingContent)


map :
    (NamespaceListing -> NamespaceListing)
    -> NamespaceListing
    -> NamespaceListing
map f (NamespaceListing hash fqn content) =
    let
        mapNamespaceListing c =
            case c of
                SubNamespace nl ->
                    SubNamespace (map f nl)

                _ ->
                    c
    in
    f (NamespaceListing hash fqn (RemoteData.map (List.map mapNamespaceListing) content))


contentFetched : NamespaceListing -> FQN -> Bool
contentFetched (NamespaceListing _ fqn content) needleFqn =
    let
        contentFetched_ child =
            case child of
                SubNamespace nl ->
                    contentFetched nl needleFqn

                _ ->
                    False

        contentIncludes c =
            List.any contentFetched_ c
    in
    (FQN.equals fqn needleFqn && RemoteData.isSuccess content)
        || (content |> RemoteData.map contentIncludes |> RemoteData.withDefault False)


sortContent : NamespaceListingContent -> NamespaceListingContent
sortContent content =
    let
        toComparable child =
            case child of
                SubNamespace (NamespaceListing _ fqn _) ->
                    String.toLower (FQN.toString fqn)

                SubDefinition (TypeListing _ fqn _) ->
                    String.toLower (FQN.toString fqn)

                SubDefinition (TermListing _ fqn _) ->
                    String.toLower (FQN.toString fqn)

                SubDefinition (DataConstructorListing _ fqn) ->
                    String.toLower (FQN.toString fqn)

                SubDefinition (AbilityConstructorListing _ fqn) ->
                    String.toLower (FQN.toString fqn)

                SubDefinition (PatchListing name) ->
                    "zzz" ++ String.toLower name

        sorter a b =
            UnicodeSort.compareUnicode (toComparable a) (toComparable b)
    in
    List.sortWith sorter content



-- JSON DECODE


decode : Maybe FQN -> Decode.Decoder NamespaceListing
decode listingFqn =
    Decode.map3
        NamespaceListing
        (field "namespaceListingHash" Hash.decode)
        (field "namespaceListingFQN" FQN.decode)
        -- The main namespace being decoded has children, so we use Success for
        -- the RemoteData. There children of the children however are not yet
        -- fetched
        (Decode.map Success (field "namespaceListingChildren" (decodeContent listingFqn)))



-- JSON Decode Helpers


decodeFromParent : Maybe FQN -> Decode.Decoder FQN
decodeFromParent parentFqn =
    parentFqn
        |> Maybe.map FQN.decodeFromParent
        |> Maybe.withDefault FQN.decode


{-| Decoding specific intermediate type |
-}
decodeSubNamespace : Maybe FQN -> Decode.Decoder NamespaceListingChild
decodeSubNamespace parentFqn =
    Decode.map SubNamespace
        (Decode.map3 NamespaceListing
            (field "namespaceHash" Hash.decode)
            (field "namespaceName" (decodeFromParent parentFqn))
            (Decode.succeed NotAsked)
        )


decodeContent : Maybe FQN -> Decode.Decoder NamespaceListingContent
decodeContent parentFqn =
    let
        decodeFqn =
            decodeFromParent parentFqn

        decodeAbilityConstructorListing =
            Decode.map SubDefinition
                (Decode.map2 AbilityConstructorListing
                    (field "termHash" Hash.decode)
                    (field "termName" decodeFqn)
                )

        decodeDataConstructorListing =
            Decode.map SubDefinition
                (Decode.map2 DataConstructorListing
                    (field "termHash" Hash.decode)
                    (field "termName" decodeFqn)
                )

        decodeTypeListing =
            Decode.map SubDefinition
                (Decode.map3 TypeListing
                    (field "typeHash" Hash.decode)
                    (field "typeName" decodeFqn)
                    (Decode.map Category.Type (Type.decodeTypeCategory [ "typeTag" ]))
                )

        decodeTermListing =
            Decode.map SubDefinition
                (Decode.map3 TermListing
                    (field "termHash" Hash.decode)
                    (field "termName" decodeFqn)
                    (Decode.map Category.Term (Term.decodeTermCategory [ "termTag" ]))
                )

        decodePatchListing =
            Decode.map SubDefinition (Decode.map PatchListing (field "patchName" Decode.string))

        decodeChild =
            Decode.oneOf
                [ whenTagIs "Subnamespace" (field "contents" (decodeSubNamespace parentFqn))
                , whenPathIs [ "contents", "termTag" ] "DataConstructor" (field "contents" decodeDataConstructorListing)
                , whenPathIs [ "contents", "termTag" ] "AbilityConstructor" (field "contents" decodeAbilityConstructorListing)
                , whenTagIs "TypeObject" (field "contents" decodeTypeListing)
                , whenTagIs "TermObject" (field "contents" decodeTermListing)
                , whenTagIs "PatchObject" (field "contents" decodePatchListing)
                ]
    in
    Decode.list decodeChild |> Decode.map sortContent
