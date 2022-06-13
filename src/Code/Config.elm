module Code.Config exposing (..)

import Code.CodebaseApi exposing (ToApiEndpoint)
import Code.Perspective exposing (Perspective)
import Lib.HttpApi exposing (HttpApi)
import Lib.OperatingSystem exposing (OperatingSystem)


type alias Config =
    { operatingSystem : OperatingSystem
    , perspective : Perspective
    , toApiEndpoint : ToApiEndpoint
    , api : HttpApi
    }
