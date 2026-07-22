module Stories.UI.Form.SelectField exposing (..)

import Browser
import Helpers.Layout exposing (columns)
import Html exposing (Html)
import UI.Form.SelectField as SelectField


type Fruit
    = Apple
    | Banana
    | Cherry
    | Durian


fruitLabel : Fruit -> String
fruitLabel fruit =
    case fruit of
        Apple ->
            "Apple"

        Banana ->
            "Banana"

        Cherry ->
            "Cherry"

        Durian ->
            "Durian"


type alias Model =
    { fruit : Fruit
    , fruitWithHelpText : Fruit
    , disabledFruit : Fruit
    , invalidFruit : Fruit
    }


main : Program () Model Msg
main =
    Browser.element
        { init =
            always
                ( { fruit = Apple
                  , fruitWithHelpText = Apple
                  , disabledFruit = Apple
                  , invalidFruit = Apple
                  }
                , Cmd.none
                )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }


type Msg
    = OnFruitChange Fruit
    | OnFruitWithHelpTextChange Fruit
    | OnInvalidFruitChange Fruit


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFruitChange fruit ->
            ( { model | fruit = fruit }, Cmd.none )

        OnFruitWithHelpTextChange fruit ->
            ( { model | fruitWithHelpText = fruit }, Cmd.none )

        OnInvalidFruitChange fruit ->
            ( { model | invalidFruit = fruit }, Cmd.none )


fruitOptions : SelectField.SelectOptions Fruit
fruitOptions =
    SelectField.options
        (SelectField.option (fruitLabel Apple) Apple)
        [ SelectField.option (fruitLabel Banana) Banana
        , SelectField.option (fruitLabel Cherry) Cherry
        , SelectField.option (fruitLabel Durian) Durian
        ]


elements : Model -> List (SelectField.SelectField Fruit Msg)
elements model =
    [ SelectField.field OnFruitChange fruitOptions model.fruit
        |> SelectField.withLabel "Favorite fruit"
    , SelectField.field OnFruitWithHelpTextChange fruitOptions model.fruitWithHelpText
        |> SelectField.withLabel "Favorite fruit"
        |> SelectField.withHelpText "Pick the fruit you like the most"
    , SelectField.field OnFruitChange fruitOptions model.disabledFruit
        |> SelectField.withLabel "Disabled"
        |> SelectField.withDisabled
    , SelectField.field OnInvalidFruitChange fruitOptions model.invalidFruit
        |> SelectField.withLabel "Invalid"
        |> SelectField.withHelpText "This field has an error"
        |> SelectField.markAsInvalid
    ]


view : Model -> Html Msg
view model =
    columns [] (elements model |> List.map SelectField.view)
