module Stories.UI.Form.SearchSelect exposing (..)

import Browser
import Helpers.Layout exposing (rows)
import Html exposing (Html, div, text)
import Html.Attributes exposing (class, classList, style)
import Html.Events exposing (onClick)
import Lib.Search as Search exposing (Search)
import UI.Form.SearchSelect as SearchSelect


type alias Model =
    { fruitSearch : Search String
    , selectedFruit : Maybe String
    , colorSearch : Search String
    , fruitWithCompletionSearch : Search String
    , fruitQueryCompletion : Search String
    , selectedFruitWithCompletion : Maybe String
    }


type Msg
    = UpdateFruitSearch (Search String)
    | SelectFruit String
    | UpdateFruitWithCompletionSearch (Search String)
    | SelectFruitWithCompletion String


fruits : List String
fruits =
    [ "Apple"
    , "Apricot"
    , "Avocado"
    , "Banana"
    , "Blueberry"
    , "Cherry"
    , "Coconut"
    , "Date"
    , "Fig"
    , "Grape"
    , "Guava"
    , "Kiwi"
    , "Lemon"
    , "Lime"
    , "Mango"
    , "Orange"
    , "Papaya"
    , "Peach"
    , "Pear"
    , "Pineapple"
    , "Plum"
    , "Raspberry"
    , "Strawberry"
    , "Watermelon"
    ]


colors : List String
colors =
    [ "Amber"
    , "Blue"
    , "Coral"
    , "Crimson"
    , "Cyan"
    , "Emerald"
    , "Fuchsia"
    , "Gold"
    , "Green"
    , "Indigo"
    , "Ivory"
    , "Jade"
    , "Lavender"
    , "Magenta"
    , "Maroon"
    , "Navy"
    , "Ochre"
    , "Olive"
    , "Orange"
    , "Pink"
    , "Purple"
    , "Red"
    , "Rose"
    , "Ruby"
    , "Sapphire"
    , "Scarlet"
    , "Silver"
    , "Teal"
    , "Turquoise"
    , "Violet"
    , "White"
    , "Yellow"
    ]


main : Program () Model Msg
main =
    Browser.element
        { init =
            always
                ( { fruitSearch = Search.empty
                  , selectedFruit = Nothing
                  , colorSearch = Search.empty
                  , fruitWithCompletionSearch = Search.empty
                  , fruitQueryCompletion = Search.empty
                  , selectedFruitWithCompletion = Nothing
                  }
                , Cmd.none
                )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }


filterItems : List String -> String -> List String
filterItems items query =
    List.filter
        (String.toLower >> String.contains (String.toLower query))
        items


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateFruitSearch search ->
            let
                q =
                    Search.query search

                newSearch =
                    if String.isEmpty q then
                        Search.empty

                    else
                        case search of
                            Search.Success _ _ ->
                                search

                            _ ->
                                Search.fromList q (filterItems fruits q)
            in
            ( { model | fruitSearch = newSearch }, Cmd.none )

        SelectFruit fruit ->
            ( { model | selectedFruit = Just fruit, fruitSearch = Search.empty }, Cmd.none )

        UpdateFruitWithCompletionSearch search ->
            let
                q =
                    Search.query search

                newSearch =
                    if String.isEmpty q then
                        Search.empty

                    else
                        case search of
                            Search.Success _ _ ->
                                search

                            _ ->
                                Search.fromList q (filterItems fruits q)

                queryCompletion =
                    if String.isEmpty q then
                        Search.empty

                    else
                        fruits
                            |> List.filter (String.toLower >> String.startsWith (String.toLower q))
                            |> List.head
                            |> Maybe.map (\match -> Search.fromList q [ match ])
                            |> Maybe.withDefault Search.empty
            in
            ( { model
                | fruitWithCompletionSearch = newSearch
                , fruitQueryCompletion = queryCompletion
              }
            , Cmd.none
            )

        SelectFruitWithCompletion fruit ->
            ( { model
                | selectedFruitWithCompletion = Just fruit
                , fruitWithCompletionSearch = Search.empty
                , fruitQueryCompletion = Search.empty
              }
            , Cmd.none
            )


viewMatch : (String -> Msg) -> String -> Bool -> Html Msg
viewMatch selectMsg item isFocused =
    div
        [ class "search-select_match"
        , classList [ ( "is-focused", isFocused ) ]
        , onClick (selectMsg item)
        ]
        [ text item ]


selectedLabel : Maybe String -> Html Msg
selectedLabel selected =
    div
        [ style "font-size" "var(--font-size-medium)"
        , style "color" "var(--u-color_text_subdued)"
        ]
        [ text ("Selected: " ++ Maybe.withDefault "No selection" selected) ]


view : Model -> Html Msg
view model =
    let
        fruitSelect =
            SearchSelect.searchSelect model.fruitSearch UpdateFruitSearch SelectFruit
                |> SearchSelect.withPlaceholder "Search fruits..."
                |> SearchSelect.view (viewMatch SelectFruit)

        fruitSelectWithCompletion =
            SearchSelect.searchSelect model.fruitWithCompletionSearch UpdateFruitWithCompletionSearch SelectFruitWithCompletion
                |> SearchSelect.withPlaceholder "Search fruits..."
                |> SearchSelect.withQueryCompletion model.fruitQueryCompletion
                |> SearchSelect.view (viewMatch SelectFruitWithCompletion)
    in
    rows
        [ style "gap" "2rem", style "padding" "1.5rem" ]
        [ div
            [ style "display" "flex"
            , style "flex-direction" "column"
            , style "gap" "0.5rem"
            ]
            [ fruitSelect
            , selectedLabel model.selectedFruit
            ]
        , div
            [ style "display" "flex"
            , style "flex-direction" "column"
            , style "gap" "0.5rem"
            ]
            [ fruitSelectWithCompletion
            , selectedLabel model.selectedFruitWithCompletion
            ]
        ]
