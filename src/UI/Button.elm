module UI.Button exposing
    ( Button
    , Size(..)
    , Type(..)
    , button
    , button_
    , contained
    , danger
    , default
    , github
    , icon
    , iconThenLabel
    , iconThenLabel_
    , icon_
    , large
    , medium
    , positive
    , preventDefault
    , primary
    , share
    , small
    , stopPropagation
    , uncontained
    , view
    , withClick
    , withSize
    , withType
    )

import Html exposing (Html, a, text)
import Html.Attributes exposing (class)
import UI.Click as Click exposing (Click(..))
import UI.Icon as I


type Content msg
    = Icon (I.Icon msg)
    | IconThenLabel (I.Icon msg) String
    | Label String


type alias Button msg =
    { click : Click msg
    , content : Content msg
    , type_ : Type
    , color : Color
    , size : Size
    }



-- BASE


button : msg -> String -> Button msg
button msg label =
    button_ (Click.onClick msg) label


button_ : Click msg -> String -> Button msg
button_ click label =
    { click = click
    , content = Label label
    , type_ = Contained
    , color = Default
    , size = Medium
    }


icon : msg -> I.Icon msg -> Button msg
icon msg icon__ =
    icon_ (Click.onClick msg) icon__


icon_ : Click msg -> I.Icon msg -> Button msg
icon_ click icon__ =
    { click = click
    , content = Icon icon__
    , type_ = Contained
    , color = Default
    , size = Medium
    }


iconThenLabel : msg -> I.Icon msg -> String -> Button msg
iconThenLabel msg icon__ label =
    iconThenLabel_ (Click.onClick msg) icon__ label


iconThenLabel_ : Click msg -> I.Icon msg -> String -> Button msg
iconThenLabel_ click icon__ label =
    { click = click
    , content = IconThenLabel icon__ label
    , type_ = Contained
    , color = Default
    , size = Medium
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
view { content, type_, color, click, size } =
    let
        ( contentType, content_ ) =
            case content of
                Icon i ->
                    ( "content-icon", [ I.view i ] )

                IconThenLabel i l ->
                    ( "content-icon-then-label", [ I.view i, text l ] )

                Label l ->
                    ( "content-label", [ text l ] )

        attrs =
            [ class "button"
            , class (typeToClassName type_)
            , class (colorToClassName color)
            , class (sizeToClassName size)
            , class contentType
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



-- VARIANTS


type Type
    = Contained
    | Uncontained


type Color
    = Default
    | Primary
    | Share
    | Danger
    | Positive


contained : Button clickMsg -> Button clickMsg
contained button__ =
    { button__ | type_ = Contained }


uncontained : Button clickMsg -> Button clickMsg
uncontained button__ =
    { button__ | type_ = Uncontained }


withType : Type -> Button clickMsg -> Button clickMsg
withType type_ button__ =
    { button__ | type_ = type_ }


withClick : Click msg -> Button msg -> Button msg
withClick click button__ =
    { button__ | click = click }


default : Button clickMsg -> Button clickMsg
default =
    withColor Default


primary : Button clickMsg -> Button clickMsg
primary =
    withColor Primary


share : Button clickMsg -> Button clickMsg
share =
    withColor Share


danger : Button clickMsg -> Button clickMsg
danger =
    withColor Danger


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


typeToClassName : Type -> String
typeToClassName type_ =
    case type_ of
        Contained ->
            "contained"

        Uncontained ->
            "uncontained"


colorToClassName : Color -> String
colorToClassName color =
    case color of
        Default ->
            "default"

        Primary ->
            "primary"

        Share ->
            "share"

        Danger ->
            "danger"

        Positive ->
            "positive"
