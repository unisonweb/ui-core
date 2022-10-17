module UI.Button exposing
    ( Button
    , Size(..)
    , active
    , button
    , button_
    , critical
    , decorativeBlue
    , decorativePurple
    , default
    , emphasized
    , github
    , icon
    , iconThenLabel
    , iconThenLabelThenIcon
    , iconThenLabelThenIcon_
    , iconThenLabel_
    , icon_
    , labelThenIcon
    , labelThenIcon_
    , large
    , map
    , medium
    , notActive
    , positive
    , preventDefault
    , small
    , stopPropagation
    , subdued
    , view
    , withClick
    , withIconAfterLabel
    , withIconBeforeLabel
    , withIconsBeforeAndAfterLabel
    , withIsActive
    , withSize
    )

import Html exposing (Html, a, text)
import Html.Attributes exposing (class, classList)
import UI.Click as Click exposing (Click(..))
import UI.Icon as I


type Content msg
    = Icon (I.Icon msg)
    | IconThenLabel (I.Icon msg) String
    | LabelThenIcon String (I.Icon msg)
    | IconThenLabelThenIcon (I.Icon msg) String (I.Icon msg)
    | Label String


type alias Button msg =
    { click : Click msg
    , content : Content msg
    , color : Color
    , size : Size
    , isActive : Bool
    }



-- BASE


map : (a -> msg) -> Button a -> Button msg
map toMsg buttonA =
    let
        mapContent : Content a -> Content msg
        mapContent c =
            case c of
                Icon i ->
                    Icon (I.map toMsg i)

                IconThenLabel i label ->
                    IconThenLabel (I.map toMsg i) label

                IconThenLabelThenIcon i1 label i2 ->
                    IconThenLabelThenIcon (I.map toMsg i1) label (I.map toMsg i2)

                LabelThenIcon label i ->
                    LabelThenIcon label (I.map toMsg i)

                Label label ->
                    Label label
    in
    { click = Click.map toMsg buttonA.click
    , content = mapContent buttonA.content
    , color = buttonA.color
    , size = buttonA.size
    , isActive = False
    }


button : msg -> String -> Button msg
button msg label =
    button_ (Click.onClick msg) label


button_ : Click msg -> String -> Button msg
button_ click label =
    { click = click
    , content = Label label
    , color = Default
    , size = Medium
    , isActive = False
    }


icon : msg -> I.Icon msg -> Button msg
icon msg icon__ =
    icon_ (Click.onClick msg) icon__


icon_ : Click msg -> I.Icon msg -> Button msg
icon_ click icon__ =
    { click = click
    , content = Icon icon__
    , color = Default
    , size = Medium
    , isActive = False
    }


iconThenLabel : msg -> I.Icon msg -> String -> Button msg
iconThenLabel msg icon__ label =
    iconThenLabel_ (Click.onClick msg) icon__ label


iconThenLabel_ : Click msg -> I.Icon msg -> String -> Button msg
iconThenLabel_ click icon__ label =
    { click = click
    , content = IconThenLabel icon__ label
    , color = Default
    , size = Medium
    , isActive = False
    }


labelThenIcon : msg -> String -> I.Icon msg -> Button msg
labelThenIcon msg label icon__ =
    labelThenIcon_ (Click.onClick msg) label icon__


labelThenIcon_ : Click msg -> String -> I.Icon msg -> Button msg
labelThenIcon_ click label icon__ =
    { click = click
    , content = LabelThenIcon label icon__
    , color = Default
    , size = Medium
    , isActive = False
    }


iconThenLabelThenIcon : msg -> I.Icon msg -> String -> I.Icon msg -> Button msg
iconThenLabelThenIcon msg iconBefore label iconAfter =
    iconThenLabelThenIcon_ (Click.onClick msg) iconBefore label iconAfter


iconThenLabelThenIcon_ : Click msg -> I.Icon msg -> String -> I.Icon msg -> Button msg
iconThenLabelThenIcon_ click iconBefore label iconAfter =
    { click = click
    , content = IconThenLabelThenIcon iconBefore label iconAfter
    , color = Default
    , size = Medium
    , isActive = False
    }



-- Click Settings


stopPropagation : Button msg -> Button msg
stopPropagation button__ =
    { button__ | click = Click.stopPropagation button__.click }


preventDefault : Button msg -> Button msg
preventDefault button__ =
    { button__ | click = Click.preventDefault button__.click }



-- VIEW


view : Button clickMsg -> Html clickMsg
view { content, color, click, size, isActive } =
    let
        ( contentType, content_ ) =
            case content of
                Icon i ->
                    ( "content-icon", [ I.view i ] )

                IconThenLabel i l ->
                    ( "content-icon-then-label", [ I.view i, text l ] )

                IconThenLabelThenIcon i1 l i2 ->
                    ( "content-icon-then-label-then", [ I.view i1, text l, I.view i2 ] )

                LabelThenIcon l i ->
                    ( "content-label-then-icon", [ text l, I.view i ] )

                Label l ->
                    ( "content-label", [ text l ] )

        attrs =
            [ class "button"
            , class (colorToClassName color)
            , class (sizeToClassName size)
            , class contentType
            , classList [ ( "button_active", isActive ) ]
            ]
    in
    case click of
        OnClick _ _ ->
            Html.button (Click.attrs click ++ attrs) content_

        ExternalHref _ ->
            a (attrs ++ Click.attrs click) content_

        Href _ ->
            a (attrs ++ Click.attrs click) content_

        Disabled ->
            Html.button attrs content_



-- ICONS


withIconBeforeLabel : I.Icon msg -> Button msg -> Button msg
withIconBeforeLabel iconBefore button__ =
    let
        content =
            case button__.content of
                Icon _ ->
                    -- Kind of an awkward case... since we're expecting a label
                    button__.content

                IconThenLabel _ l ->
                    IconThenLabel iconBefore l

                IconThenLabelThenIcon _ l iconAfter ->
                    IconThenLabelThenIcon iconBefore l iconAfter

                LabelThenIcon l iconAfter ->
                    IconThenLabelThenIcon iconBefore l iconAfter

                Label l ->
                    IconThenLabel iconBefore l
    in
    { button__ | content = content }


withIconAfterLabel : I.Icon msg -> Button msg -> Button msg
withIconAfterLabel iconAfter button__ =
    let
        content =
            case button__.content of
                Icon _ ->
                    -- Kind of an awkward case... since we're expecting a label
                    button__.content

                IconThenLabel iconBefore l ->
                    IconThenLabelThenIcon iconBefore l iconAfter

                IconThenLabelThenIcon iconBefore l _ ->
                    IconThenLabelThenIcon iconBefore l iconAfter

                LabelThenIcon l _ ->
                    LabelThenIcon l iconAfter

                Label l ->
                    LabelThenIcon l iconAfter
    in
    { button__ | content = content }


withIconsBeforeAndAfterLabel : I.Icon msg -> I.Icon msg -> Button msg -> Button msg
withIconsBeforeAndAfterLabel iconBefore iconAfter button__ =
    let
        content =
            case button__.content of
                Icon _ ->
                    -- Kind of an awkward case... since we're expecting a label
                    button__.content

                IconThenLabel _ l ->
                    IconThenLabelThenIcon iconBefore l iconAfter

                IconThenLabelThenIcon _ l _ ->
                    IconThenLabelThenIcon iconBefore l iconAfter

                LabelThenIcon l _ ->
                    IconThenLabelThenIcon iconBefore l iconAfter

                Label l ->
                    IconThenLabelThenIcon iconBefore l iconAfter
    in
    { button__ | content = content }



-- VARIANTS


type Color
    = Default
    | Emphasized
    | Subdued
    | Critical
    | Positive
    | DecorativeBlue
    | DecorativePurple


withIsActive : Bool -> Button clickMsg -> Button clickMsg
withIsActive isActive button__ =
    { button__ | isActive = isActive }


active : Button clickMsg -> Button clickMsg
active button__ =
    withIsActive True button__


notActive : Button clickMsg -> Button clickMsg
notActive button__ =
    withIsActive False button__


withClick : Click msg -> Button msg -> Button msg
withClick click button__ =
    { button__ | click = click }


default : Button clickMsg -> Button clickMsg
default =
    withColor Default


subdued : Button clickMsg -> Button clickMsg
subdued =
    withColor Subdued


emphasized : Button clickMsg -> Button clickMsg
emphasized =
    withColor Emphasized


decorativePurple : Button clickMsg -> Button clickMsg
decorativePurple =
    withColor DecorativePurple


decorativeBlue : Button clickMsg -> Button clickMsg
decorativeBlue =
    withColor DecorativeBlue


critical : Button clickMsg -> Button clickMsg
critical =
    withColor Critical


positive : Button clickMsg -> Button clickMsg
positive =
    withColor Positive


withColor : Color -> Button clickMsg -> Button clickMsg
withColor color_ button__ =
    { button__ | color = color_ }



-- SIZES


type Size
    = Small
    | Medium
    | Large


small : Button clickMsg -> Button clickMsg
small =
    withSize Small


medium : Button clickMsg -> Button clickMsg
medium =
    withSize Medium


large : Button clickMsg -> Button clickMsg
large =
    withSize Large


withSize : Size -> Button clickMsg -> Button clickMsg
withSize size button__ =
    { button__ | size = size }



-- COMMON INSTANCES


github : String -> Button msg
github repo =
    iconThenLabel_ (Click.externalHref ("https://github.com/" ++ repo)) I.github repo
        |> small



-- INTERNAL


sizeToClassName : Size -> String
sizeToClassName size =
    case size of
        Small ->
            "small"

        Medium ->
            "medium"

        Large ->
            "large"


colorToClassName : Color -> String
colorToClassName color =
    case color of
        Default ->
            "default"

        Subdued ->
            "subdued"

        Emphasized ->
            "emphasized"

        DecorativePurple ->
            "decorative-purple"

        DecorativeBlue ->
            "decorative-blue"

        Critical ->
            "critical"

        Positive ->
            "positive"
