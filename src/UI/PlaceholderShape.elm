module UI.PlaceholderShape exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)



{-

   PlaceholderShape
   ================

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


type PlaceholderShape
    = Text { size : Size, length : Size, intensity : Intensity }



-- CREATE


text : PlaceholderShape
text =
    Text { size = Medium, length = Medium, intensity = Normal }


text_ : Size -> Size -> Intensity -> PlaceholderShape
text_ size length intensity =
    Text { size = size, length = length, intensity = intensity }



-- MODIFY


withSize : Size -> PlaceholderShape -> PlaceholderShape
withSize size (Text t) =
    Text { t | size = size }


withLength : Size -> PlaceholderShape -> PlaceholderShape
withLength length (Text t) =
    Text { t | length = length }


withIntensity : Intensity -> PlaceholderShape -> PlaceholderShape
withIntensity intensity (Text t) =
    Text { t | intensity = intensity }



-- VIEW


view : PlaceholderShape -> Html msg
view (Text t) =
    let
        sizeClass =
            "placeholder-shape_size_" ++ sizeToClassName t.size

        lengthClass =
            "placeholder-shape_length_" ++ sizeToClassName t.length

        intensityClass =
            "placeholder-shape_intensity_" ++ intensityToClassName t.intensity
    in
    div
        [ class "placeholder-shape placeholder-shape_text"
        , class sizeClass
        , class lengthClass
        , class intensityClass
        ]
        []


sizeToClassName : Size -> String
sizeToClassName size =
    case size of
        Tiny ->
            "tiny"

        Small ->
            "small"

        Medium ->
            "small"

        Large ->
            "small"

        Huge ->
            "small"


intensityToClassName : Intensity -> String
intensityToClassName intensity =
    case intensity of
        Subdued ->
            "subdued"

        Normal ->
            "normal"

        Emphasized ->
            "emphasized"
