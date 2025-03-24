module Lib.HttpApi exposing
    ( ApiRequest
    , ApiUrl(..)
    , Endpoint(..)
    , EndpointConfig
    , ExpectedResponse(..)
    , HttpApi
    , HttpResult
    , apiUrlFromString
    , baseApiUrl
    , defaultTimeout
    , httpApi
    , httpApi_
    , perform
    , toRequest
    , toRequestWithEmptyResponse
    , toTask
    , toUrl
    , withHeader
    , withTimeout
    , withoutTimeout
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


type ExpectedResponse a msg
    = EmptyBody (HttpResult () -> msg)
    | JsonBody (HttpResult a -> msg) (Decode.Decoder a)


httpApi : Bool -> String -> Maybe String -> HttpApi
httpApi withCredentials rawUrl xsrfToken =
    let
        headers =
            xsrfToken
                |> Maybe.map (Http.header "X-XSRF-TOKEN")
                |> Maybe.map (\x -> [ x ])
                |> Maybe.withDefault []
    in
    httpApi_ (apiUrlFromString withCredentials rawUrl) headers


httpApi_ : ApiUrl -> List Http.Header -> HttpApi
httpApi_ apiUrl headers =
    { url = apiUrl, headers = headers }



{-

   ApiUrl
   ======

   CrossOrigin: for URLs to a different domain or subdomain.api.example.com

   SameOrigin: with an optional path to indicate the base of the URL that the HTTP API exists on
   ex: SameOrigin ["api"]
-}


type ApiUrl
    = CrossOrigin Url
    | WithCredentialsCrossOrigin Url
    | SameOrigin (List String)


apiUrlFromString : Bool -> String -> ApiUrl
apiUrlFromString withCredentials s =
    let
        sameOrigin =
            s
                |> String.split "/"
                |> List.filter (String.isEmpty >> not)
                |> SameOrigin

        crossOrigin_ =
            if withCredentials then
                WithCredentialsCrossOrigin

            else
                CrossOrigin
    in
    if String.startsWith "http" s then
        -- Attempt to parse as a URL and assume its CrossOrigin, otherwise
        -- assume its a path and parse it into segments for SameOrigin.
        Url.fromString s
            |> Maybe.map crossOrigin_
            |> Maybe.withDefault sameOrigin

    else
        sameOrigin


baseApiUrl : HttpApi -> String
baseApiUrl api =
    toUrl api.url (GET { path = [], queryParams = [] })


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
    | PATCH (EndpointConfig { body : Http.Body })
    | DELETE (EndpointConfig { body : Http.Body })


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

                PATCH c ->
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

        WithCredentialsCrossOrigin url ->
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
        , expect : ExpectedResponse a msg
        , headers : List Http.Header
        , timeout : Maybe Float
        }


toRequest : Decode.Decoder a -> (HttpResult a -> msg) -> Endpoint -> ApiRequest a msg
toRequest decoder toMsg endpoint =
    ApiRequest { endpoint = endpoint, expect = JsonBody toMsg decoder, headers = [], timeout = Just defaultTimeout }


toRequestWithEmptyResponse : (HttpResult () -> msg) -> Endpoint -> ApiRequest a msg
toRequestWithEmptyResponse toMsg endpoint =
    ApiRequest { endpoint = endpoint, expect = EmptyBody toMsg, headers = [], timeout = Just defaultTimeout }


withHeader : ( String, String ) -> ApiRequest a msg -> ApiRequest a msg
withHeader ( name, value ) (ApiRequest req) =
    ApiRequest { req | headers = Http.header name value :: req.headers, timeout = Just defaultTimeout }


withTimeout : Float -> ApiRequest a msg -> ApiRequest a msg
withTimeout t (ApiRequest req) =
    ApiRequest { req | timeout = Just t }


{-| ⚠️ Try and avoid using this, we generally never want the user to wait for an
unbounded time.
-}
withoutTimeout : ApiRequest a msg -> ApiRequest a msg
withoutTimeout (ApiRequest req) =
    ApiRequest { req | timeout = Nothing }


perform : HttpApi -> ApiRequest a msg -> Cmd msg
perform api (ApiRequest { endpoint, expect, headers, timeout }) =
    let
        request_ =
            case api.url of
                WithCredentialsCrossOrigin _ ->
                    Http.riskyRequest

                _ ->
                    Http.request

        expect_ =
            case expect of
                EmptyBody toMsg ->
                    Http.expectWhatever toMsg

                JsonBody toMsg decoder ->
                    Http.expectJson toMsg decoder
    in
    case endpoint of
        GET _ ->
            request_
                { method = "GET"
                , headers = api.headers ++ headers
                , body = Http.emptyBody
                , url = toUrl api.url endpoint
                , expect = expect_
                , timeout = timeout
                , tracker = Nothing
                }

        POST c ->
            request_
                { method = "POST"
                , headers = api.headers ++ headers
                , body = c.body
                , url = toUrl api.url endpoint
                , expect = expect_
                , timeout = timeout
                , tracker = Nothing
                }

        PUT c ->
            request_
                { method = "PUT"
                , headers = api.headers ++ headers
                , body = c.body
                , url = toUrl api.url endpoint
                , expect = expect_
                , timeout = timeout
                , tracker = Nothing
                }

        PATCH c ->
            request_
                { method = "PATCH"
                , headers = api.headers ++ headers
                , body = c.body
                , url = toUrl api.url endpoint
                , expect = expect_
                , timeout = timeout
                , tracker = Nothing
                }

        DELETE c ->
            request_
                { method = "DELETE"
                , headers = api.headers ++ headers
                , body = c.body
                , url = toUrl api.url endpoint
                , expect = expect_
                , timeout = timeout
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
                WithCredentialsCrossOrigin _ ->
                    Http.riskyTask

                _ ->
                    Http.task
    in
    case endpoint of
        GET _ ->
            task_
                { headers = headers
                , resolver = Http.stringResolver (httpJsonBodyResolver decoder)
                , timeout = Just defaultTimeout
                , url = toUrl apiUrl endpoint
                , method = "GET"
                , body = Http.emptyBody
                }

        POST c ->
            task_
                { headers = headers
                , resolver = Http.stringResolver (httpJsonBodyResolver decoder)
                , timeout = Just defaultTimeout
                , url = toUrl apiUrl endpoint
                , method = "POST"
                , body = c.body
                }

        PUT c ->
            task_
                { headers = headers
                , resolver = Http.stringResolver (httpJsonBodyResolver decoder)
                , timeout = Just defaultTimeout
                , url = toUrl apiUrl endpoint
                , method = "PUT"
                , body = c.body
                }

        PATCH c ->
            task_
                { headers = headers
                , resolver = Http.stringResolver (httpJsonBodyResolver decoder)
                , timeout = Just defaultTimeout
                , url = toUrl apiUrl endpoint
                , method = "PATCH"
                , body = c.body
                }

        DELETE c ->
            task_
                { headers = headers
                , resolver = Http.stringResolver (httpJsonBodyResolver decoder)
                , timeout = Just defaultTimeout
                , url = toUrl apiUrl endpoint
                , method = "DELETE"
                , body = c.body
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


defaultTimeout : Float
defaultTimeout =
    30000
