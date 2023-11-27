module Stories.UI.Form.TextField exposing (..)

import Browser
import Helpers.Layout exposing (columns)
import Html exposing (Html)
import UI.Form.TextField as TextField
import UI.Icon as I


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
    ]


view : Model -> Html Msg
view model =
    columns [] (elements model |> List.map TextField.view)
