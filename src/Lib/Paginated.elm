module Lib.Paginated exposing (..)


type Paginated a
    = Paginated
        { cursor : String
        , perPage : Int
        , total : Int
        , items : List a
        }
