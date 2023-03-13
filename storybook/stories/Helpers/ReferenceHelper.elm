module Helpers.ReferenceHelper exposing (..)

import Code.Definition.Reference exposing (..)
import Code.FullyQualifiedName as FQN exposing (..)
import Code.HashQualified exposing (..)


sampleFQN : FQN
sampleFQN =
    FQN.fromString "a.b.c"


sampleHashQualified : HashQualified
sampleHashQualified =
    NameOnly sampleFQN


sampleReference : Reference
sampleReference =
    TypeReference sampleHashQualified
