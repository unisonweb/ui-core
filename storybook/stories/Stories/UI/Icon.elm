module Stories.UI.Icon exposing (main)

import Browser
import Html exposing (..)
import UI.Icon as I


main : Program () () Msg
main =
    Browser.element
        { init = \_ -> ( (), Cmd.none )
        , view = \_ -> view
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }


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
    , I.arrowsToLine
    , I.arrowsFromLine
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
    , I.boldDot
    , I.largeDot
    , I.dots
    , I.dash
    , I.boldDash
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
    , I.documentCode
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
    , I.window
    , I.keyboard
    , I.wireframeGlobe
    , I.mapPin
    , I.mail
    , I.graduationCap
    , I.unfoldedMap
    ]


view : Html Msg
view =
    div [] [ h1 [] (elements |> List.map I.view) ]
