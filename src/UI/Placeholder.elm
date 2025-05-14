module UI.Placeholder exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import List.Extra as ListE



{-

   Placeholder
   ===========

   Various shapes used to indicator real page elements for loading states and
   empty states.
-}


type Size
    = Tiny
    | Small
    | Medium
    | Large
    | Huge


type Intensity
    = Emphasized
    | Normal
    | Subdued


type Placeholder
    = Text { size : Size, length : Size, intensity : Intensity }



-- CREATE


text : Placeholder
text =
    Text { size = Medium, length = Medium, intensity = Normal }


text_ : Size -> Size -> Intensity -> Placeholder
text_ size length intensity =
    Text { size = size, length = length, intensity = intensity }


texts : Int -> List Placeholder
texts n =
    let
        lengths =
            ListE.cycle n [ Large, Small, Medium, Tiny, Huge, Large, Medium, Small, Medium ]

        alternateLength i placeholder_ =
            placeholder_
                |> withLength (Maybe.withDefault Medium (ListE.getAt i lengths))
    in
    List.repeat n text
        |> List.indexedMap alternateLength


texts3 : List Placeholder
texts3 =
    texts 3


texts5 : List Placeholder
texts5 =
    texts 5


texts8 : List Placeholder
texts8 =
    texts 8


texts12 : List Placeholder
texts12 =
    texts 12



-- MODIFY


withSize : Size -> Placeholder -> Placeholder
withSize size (Text t) =
    Text { t | size = size }


withLength : Size -> Placeholder -> Placeholder
withLength length (Text t) =
    Text { t | length = length }


withIntensity : Intensity -> Placeholder -> Placeholder
withIntensity intensity (Text t) =
    Text { t | intensity = intensity }


tiny : Placeholder -> Placeholder
tiny ps =
    withSize Tiny ps


small : Placeholder -> Placeholder
small ps =
    withSize Small ps


medium : Placeholder -> Placeholder
medium ps =
    withSize Medium ps


large : Placeholder -> Placeholder
large ps =
    withSize Large ps


huge : Placeholder -> Placeholder
huge ps =
    withSize Huge ps


emphasized : Placeholder -> Placeholder
emphasized ps =
    withIntensity Emphasized ps


normal : Placeholder -> Placeholder
normal ps =
    withIntensity Normal ps


subdued : Placeholder -> Placeholder
subdued ps =
    withIntensity Subdued ps



-- VIEW


view : Placeholder -> Html msg
view (Text t) =
    let
        sizeClass =
            "placeholder_size_" ++ sizeToClassName t.size

        lengthClass =
            "placeholder_length_" ++ sizeToClassName t.length

        intensityClass =
            "placeholder_intensity_" ++ intensityToClassName t.intensity
    in
    div
        [ class "placeholder placeholder_text"
        , class sizeClass
        , class lengthClass
        , class intensityClass
        ]
        [ div [ class "placeholder_shape" ] [] ]


sizeToClassName : Size -> String
sizeToClassName size =
    case size of
        Tiny ->
            "tiny"

        Small ->
            "small"

        Medium ->
            "medium"

        Large ->
            "large"

        Huge ->
            "huge"


intensityToClassName : Intensity -> String
intensityToClassName intensity =
    case intensity of
        Subdued ->
            "subdued"

        Normal ->
            "normal"

        Emphasized ->
            "emphasized"
