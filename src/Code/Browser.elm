module Code.Browser exposing (..)

import Code.CodebaseApi as CodebaseApi
import Code.CodebaseTree.NamespaceListing as NamespaceListing exposing (NamespaceListing)
import Code.Config exposing (Config)
import Code.FullyQualifiedName exposing (FQN)
import Code.Namespace.NamespaceRef as NamespaceRef
import Http
import Lib.HttpApi as HttpApi exposing (ApiRequest)
import RemoteData exposing (RemoteData(..))
import UI.MillerColumns as MillerColumns exposing (MillerColumns)


type alias Model =
    { columns : MillerColumns NamespaceListing Msg
    }


init : Config -> ( Model, Cmd Msg )
init config =
    let
        columns =
            MillerColumns.millerColumns Select Loading

        model =
            { columns = columns }
    in
    ( model
    , HttpApi.perform config.api (fetchRootNamespaceListing config)
    )


type Msg
    = Select NamespaceListing
    | FetchSubNamespaceListingFinished FQN (Result Http.Error NamespaceListing)
    | FetchRootNamespaceListingFinished (Result Http.Error NamespaceListing)


fetchRootNamespaceListing : Config -> ApiRequest NamespaceListing Msg
fetchRootNamespaceListing config =
    fetchNamespaceListing config Nothing FetchRootNamespaceListingFinished


fetchSubNamespaceListing : Config -> FQN -> ApiRequest NamespaceListing Msg
fetchSubNamespaceListing config fqn =
    fetchNamespaceListing config (Just fqn) (FetchSubNamespaceListingFinished fqn)


fetchNamespaceListing : Config -> Maybe FQN -> (Result Http.Error NamespaceListing -> msg) -> ApiRequest NamespaceListing msg
fetchNamespaceListing config fqn toMsg =
    CodebaseApi.Browse { perspective = config.perspective, ref = Maybe.map NamespaceRef.NameRef fqn }
        |> config.toApiEndpoint
        |> HttpApi.toRequest (NamespaceListing.decode fqn) toMsg
