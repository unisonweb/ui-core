module Lib.HttpApiTests exposing (..)

import Expect
import Lib.HttpApi as HttpApi
import Test exposing (..)
import Url.Builder exposing (string)


toUrl : Test
toUrl =
    describe "HttpApi.toUrl"
        [ test "Returns a full URL string with endpoint path and query params" <|
            \_ ->
                let
                    apiUrl =
                        HttpApi.apiUrlFromString "https://api.example.com"

                    endpoint =
                        HttpApi.GET
                            { path = [ "some", "path" ]
                            , queryParams = [ string "search" "param" ]
                            }

                    result =
                        HttpApi.toUrl apiUrl endpoint
                in
                Expect.equal "https://api.example.com/some/path?search=param" result
        ]
