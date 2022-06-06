module Code.Config exposing (..)

import Code.CodebaseApi exposing (ToApiEndpointUrl)
import Code.Perspective exposing (Perspective)
import Lib.HttpApi exposing (ApiUrl)
import Lib.OperatingSystem exposing (OperatingSystem)


type alias Config =
    { operatingSystem : OperatingSystem
    , perspective : Perspective
    , toApiEndpointUrl : ToApiEndpointUrl
    , apiUrl : ApiUrl
    }
