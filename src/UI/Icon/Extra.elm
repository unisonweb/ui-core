module UI.Icon.Extra exposing (fromString)

import UI.Icon as Icon


fromString : String -> Maybe (Icon.Icon msg)
fromString name =
    case name of
        "unisonMark" ->
            Just Icon.unisonMark

        "patch" ->
            Just Icon.patch

        "curveArrowRight" ->
            Just Icon.curveArrowRight

        "curveArrowLeft" ->
            Just Icon.curveArrowLeft

        "dataConstructor" ->
            Just Icon.dataConstructor

        "abilityConstructor" ->
            Just Icon.abilityConstructor

        "ability" ->
            Just Icon.ability

        "test" ->
            Just Icon.test

        "doc" ->
            Just Icon.doc

        "docs" ->
            Just Icon.docs

        "term" ->
            Just Icon.term

        "search" ->
            Just Icon.search

        "caretDown" ->
            Just Icon.caretDown

        "caretLeft" ->
            Just Icon.caretLeft

        "caretRight" ->
            Just Icon.caretRight

        "caretUp" ->
            Just Icon.caretUp

        "arrowDown" ->
            Just Icon.arrowDown

        "arrowLeft" ->
            Just Icon.arrowLeft

        "arrowRight" ->
            Just Icon.arrowRight

        "arrowUp" ->
            Just Icon.arrowUp

        "arrowLeftUp" ->
            Just Icon.arrowLeftUp

        "arrowsToLine" ->
            Just Icon.arrowsToLine

        "arrowsFromLine" ->
            Just Icon.arrowsFromLine

        "arrowEscapeBox" ->
            Just Icon.arrowEscapeBox

        "keyboard" ->
            Just Icon.keyboard

        "checkmark" ->
            Just Icon.checkmark

        "chevronDown" ->
            Just Icon.chevronDown

        "chevronUp" ->
            Just Icon.chevronUp

        "chevronLeft" ->
            Just Icon.chevronLeft

        "chevronRight" ->
            Just Icon.chevronRight

        "browse" ->
            Just Icon.browse

        "folder" ->
            Just Icon.folder

        "folderOpen" ->
            Just Icon.folderOpen

        "folderOutlined" ->
            Just Icon.folderOutlined

        "intoFolder" ->
            Just Icon.intoFolder

        "hash" ->
            Just Icon.hash

        "plus" ->
            Just Icon.plus

        "largePlus" ->
            Just Icon.largePlus

        "warn" ->
            Just Icon.warn

        "x" ->
            Just Icon.x

        "dot" ->
            Just Icon.dot

        "boldDot" ->
            Just Icon.boldDot

        "largeDot" ->
            Just Icon.largeDot

        "dots" ->
            Just Icon.dots

        "dash" ->
            Just Icon.dash

        "boldDash" ->
            Just Icon.boldDash

        "github" ->
            Just Icon.github

        "youtube" ->
            Just Icon.youtube

        "twitter" ->
            Just Icon.twitter

        "mastodon" ->
            Just Icon.mastodon

        "discord" ->
            Just Icon.discord

        "slack" ->
            Just Icon.slack

        "download" ->
            Just Icon.download

        "upload" ->
            Just Icon.upload

        "list" ->
            Just Icon.list

        "tag" ->
            Just Icon.tag

        "tags" ->
            Just Icon.tags

        "tagsOutlined" ->
            Just Icon.tagsOutlined

        "clipboard" ->
            Just Icon.clipboard

        "user" ->
            Just Icon.user

        "userGroup" ->
            Just Icon.userGroup

        "cog" ->
            Just Icon.cog

        "chest" ->
            Just Icon.chest

        "pencilRuler" ->
            Just Icon.pencilRuler

        "exitDoor" ->
            Just Icon.exitDoor

        "documentCode" ->
            Just Icon.documentCode

        "documentCertificate" ->
            Just Icon.documentCertificate

        "certificate" ->
            Just Icon.certificate

        "leftSidebarOn" ->
            Just Icon.leftSidebarOn

        "leftSidebarOff" ->
            Just Icon.leftSidebarOff

        "bulb" ->
            Just Icon.bulb

        "heart" ->
            Just Icon.heart

        "heartOutline" ->
            Just Icon.heartOutline

        "star" ->
            Just Icon.star

        "starOutline" ->
            Just Icon.starOutline

        "rocket" ->
            Just Icon.rocket

        "eye" ->
            Just Icon.eye

        "eyeSlash" ->
            Just Icon.eyeSlash

        "unfoldedMap" ->
            Just Icon.unfoldedMap

        "padlock" ->
            Just Icon.padlock

        "bug" ->
            Just Icon.bug

        "tada" ->
            Just Icon.tada

        "cloud" ->
            Just Icon.cloud

        "questionmark" ->
            Just Icon.questionmark

        "info" ->
            Just Icon.info

        "keyboardKey" ->
            Just Icon.keyboardKey

        "presentation" ->
            Just Icon.presentation

        "presentationSlash" ->
            Just Icon.presentationSlash

        "window" ->
            Just Icon.window

        "wireframeGlobe" ->
            Just Icon.wireframeGlobe

        "refresh" ->
            Just Icon.refresh

        "refreshSmall" ->
            Just Icon.refreshSmall

        "refreshSmallBold" ->
            Just Icon.refreshSmallBold

        "mapPin" ->
            Just Icon.mapPin

        "mail" ->
            Just Icon.mail

        "graduationCap" ->
            Just Icon.graduationCap

        "writingPad" ->
            Just Icon.writingPad

        "branch" ->
            Just Icon.branch

        "fork" ->
            Just Icon.fork

        "merge" ->
            Just Icon.merge

        "thumbsUp" ->
            Just Icon.thumbsUp

        "maximize" ->
            Just Icon.maximize

        "minimize" ->
            Just Icon.minimize

        "trash" ->
            Just Icon.trash

        "clock" ->
            Just Icon.clock

        "calendar" ->
            Just Icon.calendar

        "bolt" ->
            Just Icon.bolt

        "boltLightning" ->
            Just Icon.boltLightning

        "pulse" ->
            Just Icon.pulse

        "conversation" ->
            Just Icon.conversation

        "conversationOutlined" ->
            Just Icon.conversationOutlined

        "speechBubbleFromRight" ->
            Just Icon.speechBubbleFromRight

        "speechBubbleFromRightOutlined" ->
            Just Icon.speechBubbleFromRightOutlined

        "speechBubbleFromLeft" ->
            Just Icon.speechBubbleFromLeft

        "speechBubbleFromLeftOutlined" ->
            Just Icon.speechBubbleFromLeftOutlined

        "archive" ->
            Just Icon.archive

        "profile" ->
            Just Icon.profile

        "creditCard" ->
            Just Icon.creditCard

        "textDelete" ->
            Just Icon.textDelete

        "chain" ->
            Just Icon.chain

        "windowSplit" ->
            Just Icon.windowSplit

        "expandDown" ->
            Just Icon.expandDown

        "collapseUp" ->
            Just Icon.collapseUp

        "timeline" ->
            Just Icon.timeline

        "compare" ->
            Just Icon.compare

        "cli" ->
            Just Icon.cli

        "book" ->
            Just Icon.book

        "bookOutlined" ->
            Just Icon.bookOutlined

        "sun" ->
            Just Icon.sun

        "moon" ->
            Just Icon.moon

        "laptop" ->
            Just Icon.laptop

        "computer" ->
            Just Icon.computer

        "factory" ->
            Just Icon.factory

        "configure" ->
            Just Icon.configure

        "restartCircle" ->
            Just Icon.restartCircle

        "plug" ->
            Just Icon.plug

        "at" ->
            Just Icon.at

        "bell" ->
            Just Icon.bell

        "bellRing" ->
            Just Icon.bellRing

        "bellSlash" ->
            Just Icon.bellSlash

        "flask" ->
            Just Icon.flask

        "dependents" ->
            Just Icon.dependents

        "dependencies" ->
            Just Icon.dependencies

        "historyNode" ->
            Just Icon.historyNode

        "truck" ->
            Just Icon.truck

        "deliveryBox" ->
            Just Icon.deliveryBox

        "gift" ->
            Just Icon.gift

        _ ->
            kebabToCamel name
                |> Maybe.andThen fromString


kebabToCamel : String -> Maybe String
kebabToCamel name =
    if String.contains "-" name then
        let
            parts =
                String.split "-" name
        in
        case parts of
            first :: rest ->
                Just (first ++ String.concat (List.map capitalize rest))

            [] ->
                Nothing

    else
        Nothing


capitalize : String -> String
capitalize s =
    case String.uncons s of
        Just ( c, tail ) ->
            String.fromChar (Char.toUpper c) ++ tail

        Nothing ->
            s
