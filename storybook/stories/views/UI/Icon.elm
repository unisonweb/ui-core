module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Url
import UI.Icon as I

main : Program () Model Msg
main =
    Browser.element  
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

type alias Model = ()


init : () -> ( Model, Cmd Msg )
init _ =
    ( (), Cmd.none )

type Msg
    = NoOp
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        LinkClicked urlRequest ->
            ( model, Cmd.none )

        UrlChanged url ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


elements: List (I.Icon msg)
elements = [
    I.unisonMark,
    I.patch,
    I.dataConstructor,
    I.abilityConstructor,
    I.ability,
    I.test,
    I.doc,
    I.docs,
    I.term,
    I.type_,
    I.search,
    I.caretDown,
    I.caretLeft,
    I.caretRight,
    I.caretUp,
    I.arrowDown,
    I.arrowLeft,
    I.arrowRight,
    I.arrowUp,
    I.arrowLeftUp,
    I.checkmark,
    I.chevronDown,
    I.chevronUp,
    I.chevronLeft,
    I.chevronRight,
    I.browse,
    I.folder,
    I.folderOutlined,
    I.intoFolder,
    I.hash,
    I.plus,
    I.warn,
    I.x,
    I.dot,
    I.largeDot,
    I.dots,
    I.dash,
    I.github,
    I.twitter,
    I.slack,
    I.download,
    I.upload,
    I.list,
    I.tags,
    I.tagsOutlined,
    I.clipboard,
    I.user,
    I.cog,
    I.chest,
    I.pencilRuler,
    I.exitDoor,
    I.documentCertificate,
    I.certificate,
    I.leftSidebarOn,
    I.leftSidebarOff,
    I.bulb,
    I.heart,
    I.heartOutline,
    I.star,
    I.starOutline,
    I.rocket,
    I.eye,
    I.eyeSlash,
    I.unfoldedMap,
    I.padlock,
    I.bug,
    I.tada,
    I.cloud,
    I.questionmark,
    I.keyboardKey,
    I.presentation,
    I.presentationSlash,
    I.box,
    I.wireframeGlobe,
    I.mapPin,
    I.mail,
    I.graduationCap
    ]


view : Model -> Html Msg
view model = div [] [ h1 [] (elements |> List.map (I.view))]
