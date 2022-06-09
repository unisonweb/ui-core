module Lib.HttpApi exposing
    ( ApiRequest
    , ApiUrl(..)
    , EndpointUrl(..)
    , HttpResult
    , apiUrlFromString
    , perform
    , toRequest
    , toTask
    , toUrl
    )

import Http
import Json.Decode as Decode
import Task exposing (Task)
import Url exposing (Url)
import Url.Builder exposing (QueryParameter, absolute, crossOrigin)



{-

   Api
   ===

   Various helpers and types to deal with constructing, building up, and passing
   around Api requests

-}
{-

   ApiUrl
   ======

   CrossOrigin: for URLs to a different domain or subdomain.api.example.com

   SameOrigin: with an optional path to indicate the base of the URL that the HTTP API exists on
   ex: SameOrigin ["api"]
-}


type ApiUrl
    = CrossOrigin Url
    | SameOrigin (List String)


apiUrlFromString : String -> ApiUrl
apiUrlFromString s =
    -- Attempt to parse as a URL and assume its CrossOrigin, otherwise
    -- assume its a path and parse it into segments for SameOrigin.
    Url.fromString s
        |> Maybe.map CrossOrigin
        |> Maybe.withDefault (SameOrigin (String.split "/" s))


{-| An EndpointUrl represents a level above a Url String. It includes paths and
query parameters in a structured way such that the structure can be built up
over several steps.
-}
type EndpointUrl
    = EndpointUrl (List String) (List QueryParameter)


toUrl : ApiUrl -> EndpointUrl -> String
toUrl apiUrl (EndpointUrl _ paths queryParams) =
    case apiUrl of
        CrossOrigin url ->
            crossOrigin (Url.toString url) paths queryParams

        SameOrigin basePath ->
            absolute (basePath ++ paths) queryParams



-- REQUEST --------------------------------------------------------------------


type alias HttpResult a =
    Result Http.Error a


{-| Combines an EndpointUrl with a Decoder and a HttpResult to Msg function.
Required to perform a call to the API.
-}
type ApiRequest a msg
    = ApiRequest EndpointUrl (Decode.Decoder a) (HttpResult a -> msg)


toRequest : Decode.Decoder a -> (HttpResult a -> msg) -> EndpointUrl -> ApiRequest a msg
toRequest decoder toMsg endpoint =
    ApiRequest endpoint decoder toMsg


perform : ApiUrl -> ApiRequest a msg -> Cmd msg
perform apiUrl (ApiRequest endpoint decoder toMsg) =
    let
        request_ =
            case apiUrl of
                CrossOrigin _ ->
                    Http.riskyRequest

                SameOrigin _ ->
                    Http.request
    in
    request_
        { method = "GET"
        , headers = []
        , body = Http.emptyBody
        , url = toUrl apiUrl endpoint
        , expect = Http.expectJson toMsg decoder
        , timeout = Just timeout
        , tracker = Nothing
        }



--- TASK ----------------------------------------------------------------------


{-| TODO Perhaps this API should be merged into ApiRequest fully?? |
-}
toTask : ApiUrl -> Decode.Decoder a -> EndpointUrl -> Task Http.Error a
toTask apiUrl decoder endpoint =
    let
        task_ =
            case apiUrl of
                CrossOrigin _ ->
                    Http.riskyTask

                SameOrigin _ ->
                    Http.task
    in
    task_
        { method = "GET"
        , headers = []
        , url = toUrl apiUrl endpoint
        , body = Http.emptyBody
        , resolver = Http.stringResolver (httpJsonBodyResolver decoder)
        , timeout = Just timeout
        }


httpJsonBodyResolver : Decode.Decoder a -> Http.Response String -> HttpResult a
httpJsonBodyResolver decoder resp =
    case resp of
        Http.GoodStatus_ _ s ->
            Decode.decodeString decoder s
                |> Result.mapError (Decode.errorToString >> Http.BadBody)

        Http.BadUrl_ s ->
            Err (Http.BadUrl s)

        Http.Timeout_ ->
            Err Http.Timeout

        Http.NetworkError_ ->
            Err Http.NetworkError

        Http.BadStatus_ m s ->
            Decode.decodeString decoder s
                -- just trying; if our decoder understands the response body, great
                |> Result.mapError (\_ -> Http.BadStatus m.statusCode)



-- HELPERS


timeout : Float
timeout =
    15000
