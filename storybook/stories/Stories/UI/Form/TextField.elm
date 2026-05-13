module Stories.UI.Form.TextField exposing (..)

import Browser
import Helpers.Layout exposing (columns)
import Html exposing (Html)
import UI.Form.TextField as TextField
import UI.Icon as Icon


type alias Model =
    { value : String }


main : Program () Model Msg
main =
    Browser.element
        { init = always ( { value = "" }, Cmd.none )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }


type Msg
    = OnInput String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnInput val ->
            ( { model | value = val }, Cmd.none )


elements : Model -> List (TextField.TextField Msg)
elements model =
    [ TextField.field OnInput "Some label" model.value
        |> TextField.withAutofocus
        |> TextField.withHelpText "Required. Ex. 'Add List.map'"
    , TextField.field OnInput "Ghost text" model.value
        |> TextField.withGhostText "List.map"
    , TextField.field OnInput "Ghost text with help text" model.value
        |> TextField.withGhostText "Suggested commit message"
        |> TextField.withHelpText "Start typing to override the suggestion"
    , TextField.fieldWithoutLabel OnInput "Search for a definition" model.value
        |> TextField.withGhostText "List.foldLeft"
    , TextField.field OnInput "Ghost text with icon" model.value
        |> TextField.withGhostText "@unison/base"
        |> TextField.withIcon Icon.search
    ]


view : Model -> Html Msg
view model =
    columns [] (elements model |> List.map TextField.view)
