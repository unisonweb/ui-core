module UIStories.Icon exposing (main)

import Browser
import Html exposing (..)
import UI.Icon as I


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( (), Cmd.none )
        , view = view
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    ()


type alias Msg =
    ()


elements : List (I.Icon msg)
elements =
    [ I.unisonMark
    , I.patch
    , I.dataConstructor
    , I.abilityConstructor
    , I.ability
    , I.test
    , I.doc
    , I.docs
    , I.term
    , I.type_
    , I.search
    , I.caretDown
    , I.caretLeft
    , I.caretRight
    , I.caretUp
    , I.arrowDown
    , I.arrowLeft
    , I.arrowRight
    , I.arrowUp
    , I.arrowLeftUp
    , I.checkmark
    , I.chevronDown
    , I.chevronUp
    , I.chevronLeft
    , I.chevronRight
    , I.browse
    , I.folder
    , I.folderOutlined
    , I.intoFolder
    , I.hash
    , I.plus
    , I.warn
    , I.x
    , I.dot
    , I.largeDot
    , I.dots
    , I.dash
    , I.github
    , I.twitter
    , I.slack
    , I.download
    , I.upload
    , I.list
    , I.tags
    , I.tagsOutlined
    , I.clipboard
    , I.user
    , I.cog
    , I.chest
    , I.pencilRuler
    , I.exitDoor
    , I.documentCertificate
    , I.certificate
    , I.leftSidebarOn
    , I.leftSidebarOff
    , I.bulb
    , I.heart
    , I.heartOutline
    , I.star
    , I.starOutline
    , I.rocket
    , I.eye
    , I.eyeSlash
    , I.unfoldedMap
    , I.padlock
    , I.bug
    , I.tada
    , I.cloud
    , I.questionmark
    , I.keyboardKey
    , I.presentation
    , I.presentationSlash
    , I.box
    , I.wireframeGlobe
    , I.mapPin
    , I.mail
    , I.graduationCap
    ]


view : Model -> Html Msg
view _ =
    div [] [ h1 [] (elements |> List.map I.view) ]
