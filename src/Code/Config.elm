module Code.Config exposing (..)

import Code.CodebaseApi exposing (ToApiEndpoint)
import Code.Perspective exposing (Perspective)
import Lib.HttpApi exposing (ApiUrl)
import Lib.OperatingSystem exposing (OperatingSystem)


type alias Config =
    { operatingSystem : OperatingSystem
    , perspective : Perspective
    , toApiEndpoint : ToApiEndpoint
    , apiUrl : ApiUrl
    }
