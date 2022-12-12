module Code.Perspective exposing (..)

import Code.FullyQualifiedName as FQN exposing (FQN)
import Code.Hash as Hash exposing (Hash)
import Code.Namespace exposing (NamespaceDetails)
import RemoteData exposing (RemoteData(..), WebData)



{-
   Perspective
   ===========

   A Perspective (and PerspectiveParams) is used to orient how Code is viewed
   (in terms of page, url, and api requests) request. Have the user changed
   perspective to view a sub namespace within a project? Perhaps they are
   viewing the root of their codebase, etc. This information is tracked with a
   `Perspective`.

-}


type RootPerspective
    = Relative
    | Absolute Hash


type
    Perspective
    -- The Root can refer to several things; the root of the codebase,
    -- the root of a project, or a users codebase.
    = Root RootPerspective
    | Namespace
        { root : RootPerspective
        , fqn : FQN
        , details : WebData NamespaceDetails
        }


relativeRootPerspective : Perspective
relativeRootPerspective =
    Root Relative


toRootPerspective : Perspective -> Perspective
toRootPerspective perspective =
    Root (rootPerspective perspective)


toNamespacePerspective : Perspective -> FQN -> Perspective
toNamespacePerspective perspective fqn_ =
    Namespace { root = rootPerspective perspective, fqn = fqn_, details = NotAsked }


namespacePerspective : FQN -> Perspective
namespacePerspective fqn_ =
    namespacePerspective_ Relative fqn_


namespacePerspective_ : RootPerspective -> FQN -> Perspective
namespacePerspective_ root fqn_ =
    Namespace { root = root, fqn = fqn_, details = NotAsked }


rootPerspective : Perspective -> RootPerspective
rootPerspective perspective =
    case perspective of
        Root p ->
            p

        Namespace d ->
            d.root


{-| Move the perspective up 1 level through the number of segments of a
namespace FQN and finally stopping at the Root perspective
-}
upOneLevel : Perspective -> Perspective
upOneLevel pers =
    case pers of
        Root _ ->
            pers

        Namespace d ->
            if FQN.numSegments d.fqn > 1 then
                namespacePerspective_ d.root (FQN.dropLast d.fqn)

            else
                Root d.root


rootHash : Perspective -> Maybe Hash
rootHash perspective =
    case perspective of
        Root Relative ->
            Nothing

        Root (Absolute h) ->
            Just h

        Namespace d ->
            case d.root of
                Relative ->
                    Nothing

                Absolute h ->
                    Just h


fqn : Perspective -> FQN
fqn perspective =
    case perspective of
        Root _ ->
            FQN.fromString "."

        Namespace d ->
            d.fqn


rootPerspectiveEquals : RootPerspective -> RootPerspective -> Bool
rootPerspectiveEquals a b =
    case ( a, b ) of
        ( Relative, Relative ) ->
            True

        ( Absolute ah, Absolute bh ) ->
            Hash.equals ah bh

        _ ->
            False


equals : Perspective -> Perspective -> Bool
equals a b =
    case ( a, b ) of
        ( Root ap, Root bp ) ->
            rootPerspectiveEquals ap bp

        ( Namespace ans, Namespace bns ) ->
            rootPerspectiveEquals ans.root bns.root && FQN.equals ans.fqn bns.fqn

        _ ->
            False


{-| Even when we have a Root hash, we always constructor Relative params.
Absolute is currently not supported (until Unison Share includes historic
root), though the model allows it.
-}
toParams : Perspective -> PerspectiveParams
toParams perspective =
    case perspective of
        Root _ ->
            ByRoot Relative

        Namespace d ->
            ByNamespace Relative d.fqn


fromParams : PerspectiveParams -> Perspective
fromParams params =
    case params of
        ByRoot p ->
            Root p

        ByNamespace p fqn_ ->
            Namespace { root = p, fqn = fqn_, details = NotAsked }


needsFetching : Perspective -> Bool
needsFetching perspective =
    case perspective of
        Namespace d ->
            d.details == NotAsked

        _ ->
            False


isRootPerspective : Perspective -> Bool
isRootPerspective perspective =
    case perspective of
        Root _ ->
            True

        Namespace _ ->
            False


isNamespacePerspective : Perspective -> Bool
isNamespacePerspective perspective =
    case perspective of
        Root _ ->
            False

        Namespace _ ->
            True



-- PerspectiveParams ----------------------------------------------------------
-- These are how a perspective is represented in the url, supporting relative
-- URLs; "latest" vs the absolute URL with a root hash.


type PerspectiveParams
    = ByRoot RootPerspective
    | ByNamespace RootPerspective FQN
