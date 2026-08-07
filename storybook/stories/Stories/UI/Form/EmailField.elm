module Stories.UI.Form.EmailField exposing (..)

import Browser
import Helpers.Layout exposing (columns)
import Html exposing (Html)
import UI.Form.EmailField as EmailField
import UI.Form.TextField as TextField


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


elements : Model -> List (EmailField.EmailField Msg)
elements model =
    [ EmailField.field OnInput "Email" model.value
        |> TextField.withHelpText "We'll only use this to send you updates"
    , EmailField.fieldWithoutLabel OnInput "Enter your email" model.value
    ]


view : Model -> Html Msg
view model =
    columns [] (elements model |> List.map EmailField.view)
