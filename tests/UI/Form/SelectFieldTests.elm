module UI.Form.SelectFieldTests exposing (..)

import Expect
import Json.Encode as Encode
import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import UI.Form.SelectField as SelectField exposing (SelectField)


type Fruit
    = Apple
    | Banana
    | Cherry


type Msg
    = OnChange Fruit


fruitOptions : SelectField.SelectOptions Fruit
fruitOptions =
    SelectField.options
        (SelectField.option "Apple" Apple)
        [ SelectField.option "Banana" Banana
        , SelectField.option "Cherry" Cherry
        ]


selectField : Fruit -> SelectField Fruit Msg
selectField selected =
    SelectField.field OnChange fruitOptions selected


rendering : Test
rendering =
    describe "SelectField.view"
        [ test "renders a label when provided" <|
            \_ ->
                selectField Apple
                    |> SelectField.withLabel "Favorite fruit"
                    |> SelectField.view
                    |> Query.fromHtml
                    |> Query.has [ Selector.class "label", Selector.text "Favorite fruit" ]
        , test "renders help text when provided" <|
            \_ ->
                selectField Apple
                    |> SelectField.withHelpText "Pick one"
                    |> SelectField.view
                    |> Query.fromHtml
                    |> Query.has [ Selector.class "help-text", Selector.text "Pick one" ]
        , test "renders an option per provided option" <|
            \_ ->
                selectField Apple
                    |> SelectField.view
                    |> Query.fromHtml
                    |> Query.findAll [ Selector.tag "option" ]
                    |> Query.count (Expect.equal 3)
        , test "marks the invalid class when marked as invalid" <|
            \_ ->
                selectField Apple
                    |> SelectField.markAsInvalid
                    |> SelectField.view
                    |> Query.fromHtml
                    |> Query.has [ Selector.class "select-field_is-invalid" ]
        ]


onChangeTest : Test
onChangeTest =
    describe "SelectField change event"
        [ test "selecting an option by its index looks up the matching value" <|
            \_ ->
                selectField Apple
                    |> SelectField.view
                    |> Query.fromHtml
                    |> Query.find [ Selector.tag "select" ]
                    |> Event.simulate (Event.custom "change" (Encode.object [ ( "target", Encode.object [ ( "value", Encode.string "2" ) ] ) ]))
                    |> Event.expect (OnChange Cherry)
        ]
