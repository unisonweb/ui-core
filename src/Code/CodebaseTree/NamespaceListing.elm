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
import Dict exposing (Dict)
import Json.Decode as Decode exposing (at, field)
import Json.Decode.Extra exposing (when)
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
    | MergedNamespaceWithType NamespaceListing DefinitionListing


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

                MergedNamespaceWithType nl dl ->
                    MergedNamespaceWithType (map f nl) dl

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

                MergedNamespaceWithType nl _ ->
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

                MergedNamespaceWithType (NamespaceListing _ fqn _) _ ->
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

        mergedContent =
            mergeNamespacesWithTypes content
    in
    List.sortWith sorter mergedContent


mergeNamespacesWithTypes : NamespaceListingContent -> NamespaceListingContent
mergeNamespacesWithTypes content =
    let
        -- Group items by their FQN
        groupByFqn item acc =
            let
                fqn =
                    case item of
                        SubNamespace (NamespaceListing _ fqn_ _) ->
                            Just fqn_

                        SubDefinition (TypeListing _ fqn_ _) ->
                            Just fqn_

                        SubDefinition (TermListing _ fqn_ _) ->
                            Just fqn_

                        SubDefinition (DataConstructorListing _ fqn_) ->
                            Just fqn_

                        SubDefinition (AbilityConstructorListing _ fqn_) ->
                            Just fqn_

                        _ ->
                            Nothing
            in
            case fqn of
                Just fqn_ ->
                    let
                        fqnKey =
                            FQN.toString fqn_

                        existing =
                            Dict.get fqnKey acc |> Maybe.withDefault []
                    in
                    Dict.insert fqnKey (item :: existing) acc

                Nothing ->
                    -- Items without FQN (like patches) go to a special key
                    let
                        existing =
                            Dict.get "" acc |> Maybe.withDefault []
                    in
                    Dict.insert "" (item :: existing) acc

        -- Convert groups back to NamespaceListingChild items, merging where appropriate
        processGroup items =
            let
                ( namespaces, typeDefinitions, others ) =
                    List.foldl
                        (\item ( ns, types, other ) ->
                            case item of
                                SubNamespace nl ->
                                    ( nl :: ns, types, other )

                                SubDefinition ((TypeListing _ _ _) as tl) ->
                                    ( ns, tl :: types, other )

                                _ ->
                                    ( ns, types, item :: other )
                        )
                        ( [], [], [] )
                        items
            in
            case ( namespaces, typeDefinitions ) of
                -- Both namespace and type definition exist with same name - merge them
                ( ns :: _, tl :: _ ) ->
                    [ MergedNamespaceWithType ns tl ]

                -- Only namespace exists
                ( ns :: _, [] ) ->
                    [ SubNamespace ns ]

                -- Only type definition exists
                ( [], tl :: _ ) ->
                    [ SubDefinition tl ]

                -- No namespace or type definition (just other items)
                ( [], [] ) ->
                    others

        grouped =
            List.foldl groupByFqn Dict.empty content

        merged =
            grouped
                |> Dict.values
                |> List.concatMap processGroup
    in
    merged



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
        decodeTag =
            field "tag" Decode.string

        decodeFqn =
            decodeFromParent parentFqn

        termTypeByHash hash =
            if Hash.isAbilityConstructorHash hash then
                "AbilityConstructor"

            else if Hash.isDataConstructorHash hash then
                "DataConstructor"

            else
                "Term"

        decodeConstructorSuffix =
            Decode.map termTypeByHash (at [ "contents", "termHash" ] Hash.decode)

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
                [ when decodeTag ((==) "Subnamespace") (field "contents" (decodeSubNamespace parentFqn))
                , when decodeConstructorSuffix ((==) "DataConstructor") (field "contents" decodeDataConstructorListing)
                , when decodeConstructorSuffix ((==) "AbilityConstructor") (field "contents" decodeAbilityConstructorListing)
                , when decodeTag ((==) "TypeObject") (field "contents" decodeTypeListing)
                , when decodeTag ((==) "TermObject") (field "contents" decodeTermListing)
                , when decodeTag ((==) "PatchObject") (field "contents" decodePatchListing)
                ]
    in
    Decode.list decodeChild |> Decode.map sortContent
