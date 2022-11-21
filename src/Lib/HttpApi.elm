module Lib.HttpApi exposing
    ( ApiRequest
    , ApiUrl(..)
    , Endpoint(..)
    , EndpointConfig
    , HttpApi
    , HttpResult
    , apiUrlFromString
    , httpApi
    , httpApi_
    , perform
    , timeout
    , toRequest
    , toTask
    , toUrl
    , withHeader
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


type alias HttpApi =
    { url : ApiUrl
    , headers : List Http.Header
    }


httpApi : String -> Maybe String -> HttpApi
httpApi rawUrl xsrfToken =
    let
        headers =
            xsrfToken
                |> Maybe.map (Http.header "X-XSRF-TOKEN")
                |> Maybe.map (\x -> [ x ])
                |> Maybe.withDefault []
    in
    httpApi_ rawUrl headers


httpApi_ : String -> List Http.Header -> HttpApi
httpApi_ rawUrl headers =
    { url = apiUrlFromString rawUrl, headers = headers }



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
    let
        sameOrigin =
            s
                |> String.split "/"
                |> List.filter (String.isEmpty >> not)
                |> SameOrigin
    in
    if String.startsWith "http" s then
        -- Attempt to parse as a URL and assume its CrossOrigin, otherwise
        -- assume its a path and parse it into segments for SameOrigin.
        Url.fromString s
            |> Maybe.map CrossOrigin
            |> Maybe.withDefault sameOrigin

    else
        sameOrigin


{-| An Endpoint represents a description of an API Endpoint with Http Method,
Url Path, query params and post body
-}
type alias EndpointConfig e =
    { e | path : List String, queryParams : List QueryParameter }


type alias EndpointWithoutBody =
    EndpointConfig {}


type Endpoint
    = GET (EndpointConfig EndpointWithoutBody)
    | POST (EndpointConfig { body : Http.Body })
      -- TODO: Add support for PATCH, which might need a bit more constrained
      -- `body` field.
    | PUT (EndpointConfig { body : Http.Body })
    | DELETE (EndpointConfig {})


toUrl : ApiUrl -> Endpoint -> String
toUrl apiUrl endpoint =
    let
        ( path, queryParams ) =
            case endpoint of
                GET c ->
                    ( c.path, c.queryParams )

                POST c ->
                    ( c.path, c.queryParams )

                PUT c ->
                    ( c.path, c.queryParams )

                DELETE c ->
                    ( c.path, c.queryParams )

        stripSlashSuffix s =
            if String.endsWith "/" s then
                String.dropRight 1 s

            else
                s

        toUrlString u =
            u
                |> Url.toString
                |> stripSlashSuffix
    in
    case apiUrl of
        CrossOrigin url ->
            crossOrigin (toUrlString url) path queryParams

        SameOrigin basePath ->
            absolute (basePath ++ path) queryParams



-- REQUEST --------------------------------------------------------------------


type alias HttpResult a =
    Result Http.Error a


{-| Combines an EndpointUrl with a Decoder and a HttpResult to Msg function.
Required to perform a call to the API.
-}
type ApiRequest a msg
    = ApiRequest
        { endpoint : Endpoint
        , decoder : Decode.Decoder a
        , toMsg : HttpResult a -> msg
        , headers : List Http.Header
        }


toRequest : Decode.Decoder a -> (HttpResult a -> msg) -> Endpoint -> ApiRequest a msg
toRequest decoder toMsg endpoint =
    ApiRequest { endpoint = endpoint, decoder = decoder, toMsg = toMsg, headers = [] }


withHeader : ( String, String ) -> ApiRequest a msg -> ApiRequest a msg
withHeader ( name, value ) (ApiRequest req) =
    ApiRequest { req | headers = Http.header name value :: req.headers }


perform : HttpApi -> ApiRequest a msg -> Cmd msg
perform api (ApiRequest { endpoint, decoder, toMsg, headers }) =
    let
        request_ =
            case api.url of
                CrossOrigin _ ->
                    Http.riskyRequest

                SameOrigin _ ->
                    Http.request
    in
    case endpoint of
        GET _ ->
            request_
                { method = "GET"
                , headers = api.headers ++ headers
                , body = Http.emptyBody
                , url = toUrl api.url endpoint
                , expect = Http.expectJson toMsg decoder
                , timeout = Just timeout
                , tracker = Nothing
                }

        POST c ->
            request_
                { method = "POST"
                , headers = api.headers ++ headers
                , body = c.body
                , url = toUrl api.url endpoint
                , expect = Http.expectJson toMsg decoder
                , timeout = Just timeout
                , tracker = Nothing
                }

        PUT c ->
            request_
                { method = "PUT"
                , headers = api.headers ++ headers
                , body = c.body
                , url = toUrl api.url endpoint
                , expect = Http.expectJson toMsg decoder
                , timeout = Just timeout
                , tracker = Nothing
                }

        DELETE _ ->
            request_
                { method = "DELETE"
                , headers = api.headers ++ headers
                , body = Http.emptyBody
                , url = toUrl api.url endpoint
                , expect = Http.expectJson toMsg decoder
                , timeout = Just timeout
                , tracker = Nothing
                }



--- TASK ----------------------------------------------------------------------


{-| toTask

By default, don't add headers

-}
toTask : ApiUrl -> Decode.Decoder a -> Endpoint -> Task Http.Error a
toTask apiUrl decoder endpoint =
    toTask_ apiUrl decoder [] endpoint


{-| toTask

  - TODO: This API should be merged into ApiRequest fully, such that ApiRequest can be chainable.
    This would also mean headers can be supported for Task

-}
toTask_ : ApiUrl -> Decode.Decoder a -> List Http.Header -> Endpoint -> Task Http.Error a
toTask_ apiUrl decoder headers endpoint =
    let
        task_ =
            case apiUrl of
                CrossOrigin _ ->
                    Http.riskyTask

                SameOrigin _ ->
                    Http.task
    in
    case endpoint of
        GET _ ->
            task_
                { headers = headers
                , resolver = Http.stringResolver (httpJsonBodyResolver decoder)
                , timeout = Just timeout
                , url = toUrl apiUrl endpoint
                , method = "GET"
                , body = Http.emptyBody
                }

        POST c ->
            task_
                { headers = headers
                , resolver = Http.stringResolver (httpJsonBodyResolver decoder)
                , timeout = Just timeout
                , url = toUrl apiUrl endpoint
                , method = "POST"
                , body = c.body
                }

        PUT c ->
            task_
                { headers = headers
                , resolver = Http.stringResolver (httpJsonBodyResolver decoder)
                , timeout = Just timeout
                , url = toUrl apiUrl endpoint
                , method = "PUT"
                , body = c.body
                }

        DELETE _ ->
            task_
                { headers = headers
                , resolver = Http.stringResolver (httpJsonBodyResolver decoder)
                , timeout = Just timeout
                , url = toUrl apiUrl endpoint
                , method = "DELETE"
                , body = Http.emptyBody
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
