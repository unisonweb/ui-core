module Stories.UI.Icon exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, style)
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


iconEntry : String -> I.Icon msg -> Html msg
iconEntry name icon =
    div
        [ style "display" "flex"
        , style "align-items" "center"
        , style "gap" "0.5rem"
        , style "padding" "0.5rem"
        ]
        [ I.view icon
        , span [ style "font-size" "0.8rem", style "color" "#666" ] [ text name ]
        ]


view : Html Msg
view =
    div
        [ style "display" "grid"
        , style "grid-template-columns" "repeat(auto-fill, minmax(220px, 1fr))"
        , style "padding" "1rem"
        ]
        [ iconEntry "unisonMark" I.unisonMark
        , iconEntry "patch" I.patch
        , iconEntry "dataConstructor" I.dataConstructor
        , iconEntry "abilityConstructor" I.abilityConstructor
        , iconEntry "ability" I.ability
        , iconEntry "test" I.test
        , iconEntry "doc" I.doc
        , iconEntry "docs" I.docs
        , iconEntry "term" I.term
        , iconEntry "type_" I.type_
        , iconEntry "search" I.search
        , iconEntry "caretDown" I.caretDown
        , iconEntry "caretLeft" I.caretLeft
        , iconEntry "caretRight" I.caretRight
        , iconEntry "caretUp" I.caretUp
        , iconEntry "arrowDown" I.arrowDown
        , iconEntry "arrowLeft" I.arrowLeft
        , iconEntry "arrowRight" I.arrowRight
        , iconEntry "arrowUp" I.arrowUp
        , iconEntry "arrowLeftUp" I.arrowLeftUp
        , iconEntry "arrowsToLine" I.arrowsToLine
        , iconEntry "arrowsFromLine" I.arrowsFromLine
        , iconEntry "arrowEscapeBox" I.arrowEscapeBox
        , iconEntry "keyboard" I.keyboard
        , iconEntry "checkmark" I.checkmark
        , iconEntry "chevronDown" I.chevronDown
        , iconEntry "chevronUp" I.chevronUp
        , iconEntry "chevronLeft" I.chevronLeft
        , iconEntry "chevronRight" I.chevronRight
        , iconEntry "browse" I.browse
        , iconEntry "folder" I.folder
        , iconEntry "folderOpen" I.folderOpen
        , iconEntry "folderOutlined" I.folderOutlined
        , iconEntry "intoFolder" I.intoFolder
        , iconEntry "hash" I.hash
        , iconEntry "plus" I.plus
        , iconEntry "largePlus" I.largePlus
        , iconEntry "warn" I.warn
        , iconEntry "x" I.x
        , iconEntry "dot" I.dot
        , iconEntry "boldDot" I.boldDot
        , iconEntry "largeDot" I.largeDot
        , iconEntry "dots" I.dots
        , iconEntry "dash" I.dash
        , iconEntry "boldDash" I.boldDash
        , iconEntry "github" I.github
        , iconEntry "youtube" I.youtube
        , iconEntry "twitter" I.twitter
        , iconEntry "mastodon" I.mastodon
        , iconEntry "discord" I.discord
        , iconEntry "slack" I.slack
        , iconEntry "download" I.download
        , iconEntry "upload" I.upload
        , iconEntry "list" I.list
        , iconEntry "tag" I.tag
        , iconEntry "tags" I.tags
        , iconEntry "tagsOutlined" I.tagsOutlined
        , iconEntry "clipboard" I.clipboard
        , iconEntry "user" I.user
        , iconEntry "userGroup" I.userGroup
        , iconEntry "cog" I.cog
        , iconEntry "chest" I.chest
        , iconEntry "pencilRuler" I.pencilRuler
        , iconEntry "exitDoor" I.exitDoor
        , iconEntry "documentCode" I.documentCode
        , iconEntry "documentCertificate" I.documentCertificate
        , iconEntry "certificate" I.certificate
        , iconEntry "leftSidebarOn" I.leftSidebarOn
        , iconEntry "leftSidebarOff" I.leftSidebarOff
        , iconEntry "bulb" I.bulb
        , iconEntry "heart" I.heart
        , iconEntry "heartOutline" I.heartOutline
        , iconEntry "star" I.star
        , iconEntry "starOutline" I.starOutline
        , iconEntry "rocket" I.rocket
        , iconEntry "eye" I.eye
        , iconEntry "eyeSlash" I.eyeSlash
        , iconEntry "unfoldedMap" I.unfoldedMap
        , iconEntry "padlock" I.padlock
        , iconEntry "bug" I.bug
        , iconEntry "tada" I.tada
        , iconEntry "cloud" I.cloud
        , iconEntry "questionmark" I.questionmark
        , iconEntry "info" I.info
        , iconEntry "keyboardKey" I.keyboardKey
        , iconEntry "presentation" I.presentation
        , iconEntry "presentationSlash" I.presentationSlash
        , iconEntry "window" I.window
        , iconEntry "wireframeGlobe" I.wireframeGlobe
        , iconEntry "refresh" I.refresh
        , iconEntry "refreshSmall" I.refreshSmall
        , iconEntry "refreshSmallBold" I.refreshSmallBold
        , iconEntry "mapPin" I.mapPin
        , iconEntry "mail" I.mail
        , iconEntry "graduationCap" I.graduationCap
        , iconEntry "writingPad" I.writingPad
        , iconEntry "branch" I.branch
        , iconEntry "fork" I.fork
        , iconEntry "merge" I.merge
        , iconEntry "thumbsUp" I.thumbsUp
        , iconEntry "maximize" I.maximize
        , iconEntry "minimize" I.minimize
        , iconEntry "trash" I.trash
        , iconEntry "clock" I.clock
        , iconEntry "calendar" I.calendar
        , iconEntry "bolt" I.bolt
        , iconEntry "boltLightning" I.boltLightning
        , iconEntry "pulse" I.pulse
        , iconEntry "conversation" I.conversation
        , iconEntry "conversationOutlined" I.conversationOutlined
        , iconEntry "speechBubbleFromRight" I.speechBubbleFromRight
        , iconEntry "speechBubbleFromRightOutlined" I.speechBubbleFromRightOutlined
        , iconEntry "speechBubbleFromLeft" I.speechBubbleFromLeft
        , iconEntry "speechBubbleFromLeftOutlined" I.speechBubbleFromLeftOutlined
        , iconEntry "archive" I.archive
        , iconEntry "profile" I.profile
        , iconEntry "creditCard" I.creditCard
        , iconEntry "textDelete" I.textDelete
        , iconEntry "chain" I.chain
        , iconEntry "windowSplit" I.windowSplit
        , iconEntry "expandDown" I.expandDown
        , iconEntry "collapseUp" I.collapseUp
        , iconEntry "timeline" I.timeline
        , iconEntry "compare" I.compare
        , iconEntry "cli" I.cli
        , iconEntry "book" I.book
        , iconEntry "bookOutlined" I.bookOutlined
        , iconEntry "sun" I.sun
        , iconEntry "moon" I.moon
        , iconEntry "laptop" I.laptop
        , iconEntry "computer" I.computer
        , iconEntry "factory" I.factory
        , iconEntry "configure" I.configure
        , iconEntry "restartCircle" I.restartCircle
        , iconEntry "plug" I.plug
        , iconEntry "at" I.at
        , iconEntry "bell" I.bell
        , iconEntry "bellRing" I.bellRing
        , iconEntry "bellSlash" I.bellSlash
        , iconEntry "flask" I.flask
        , iconEntry "dependents" I.dependents
        , iconEntry "dependencies" I.dependencies
        , iconEntry "historyNode" I.historyNode
        ]
