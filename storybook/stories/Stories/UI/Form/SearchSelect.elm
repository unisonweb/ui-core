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
    , fruitAboveSearch : Search String
    , selectedFruitAbove : Maybe String
    , fruitLimitedSearch : Search String
    , selectedFruitLimited : Maybe String
    }


type Msg
    = UpdateFruitSearch (Search String)
    | SelectFruit String (Search String)
    | UpdateFruitWithCompletionSearch (Search String)
    | AcceptFruitCompletion String
    | SelectFruitWithCompletion String (Search String)
    | UpdateFruitAboveSearch (Search String)
    | SelectFruitAbove String (Search String)
    | UpdateFruitLimitedSearch (Search String)
    | SelectFruitLimited String (Search String)


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
                  , fruitAboveSearch = Search.empty
                  , selectedFruitAbove = Nothing
                  , fruitLimitedSearch = Search.empty
                  , selectedFruitLimited = Nothing
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

        SelectFruit fruit newSearch ->
            ( { model | selectedFruit = Just fruit, fruitSearch = newSearch }, Cmd.none )

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

        AcceptFruitCompletion query ->
            update (UpdateFruitWithCompletionSearch (Search.withQuery query model.fruitWithCompletionSearch)) model

        SelectFruitWithCompletion fruit newSearch ->
            ( { model
                | selectedFruitWithCompletion = Just fruit
                , fruitWithCompletionSearch = newSearch
                , fruitQueryCompletion = Search.empty
              }
            , Cmd.none
            )

        UpdateFruitAboveSearch search ->
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
            ( { model | fruitAboveSearch = newSearch }, Cmd.none )

        SelectFruitAbove fruit newSearch ->
            ( { model | selectedFruitAbove = Just fruit, fruitAboveSearch = newSearch }, Cmd.none )

        UpdateFruitLimitedSearch search ->
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
            ( { model | fruitLimitedSearch = newSearch }, Cmd.none )

        SelectFruitLimited fruit newSearch ->
            ( { model | selectedFruitLimited = Just fruit, fruitLimitedSearch = newSearch }, Cmd.none )


viewMatch : (String -> Search String -> Msg) -> String -> Bool -> Html Msg
viewMatch selectMsg item isFocused =
    div
        [ class "search-select_match"
        , classList [ ( "is-focused", isFocused ) ]
        , onClick (selectMsg item (Search.withQuery item Search.empty))
        ]
        [ text item ]


selectedLabel : Maybe String -> Html Msg
selectedLabel selected =
    div
        [ style "font-size" "var(--font-size-medium)"
        , style "color" "var(--u-color_text_subdued)"
        ]
        [ text ("Selected: " ++ Maybe.withDefault "No selection" selected) ]


exampleLabel : String -> Html Msg
exampleLabel label =
    div
        [ style "font-size" "var(--font-size-small)"
        , style "font-weight" "500"
        , style "color" "var(--u-color_text_subdued)"
        , style "text-transform" "uppercase"
        , style "letter-spacing" "0.05em"
        ]
        [ text label ]


example : String -> List (Html Msg) -> Html Msg
example label children =
    div
        [ style "display" "flex"
        , style "flex-direction" "column"
        , style "gap" "0.5rem"
        ]
        (exampleLabel label :: children)


view : Model -> Html Msg
view model =
    let
        fruitSelect =
            SearchSelect.searchSelect model.fruitSearch UpdateFruitSearch SelectFruit
                |> SearchSelect.withPlaceholder "Search fruits..."
                |> SearchSelect.withMatchAsQuery
                |> SearchSelect.view (viewMatch SelectFruit)

        fruitSelectWithCompletion =
            SearchSelect.searchSelect model.fruitWithCompletionSearch UpdateFruitWithCompletionSearch SelectFruitWithCompletion
                |> SearchSelect.withPlaceholder "Search fruits..."
                |> SearchSelect.withQueryCompletion { search = model.fruitQueryCompletion, acceptMsg = AcceptFruitCompletion }
                |> SearchSelect.withMatchAsQuery
                |> SearchSelect.view (viewMatch SelectFruitWithCompletion)

        fruitSelectAbove =
            SearchSelect.searchSelect model.fruitAboveSearch UpdateFruitAboveSearch SelectFruitAbove
                |> SearchSelect.withPlaceholder "Search fruits..."
                |> SearchSelect.withSheetAbove
                |> SearchSelect.withMatchAsQuery
                |> SearchSelect.view (viewMatch SelectFruitAbove)

        fruitSelectLimited =
            SearchSelect.searchSelect model.fruitLimitedSearch UpdateFruitLimitedSearch SelectFruitLimited
                |> SearchSelect.withPlaceholder "Search fruits..."
                |> SearchSelect.withMaxResults 5
                |> SearchSelect.withMatchAsQuery
                |> SearchSelect.view (viewMatch SelectFruitLimited)
    in
    rows
        [ style "gap" "2rem", style "padding" "1.5rem", style "padding-top" "8rem", style "flex-wrap" "wrap" ]
        [ example "Default"
            [ fruitSelect
            , selectedLabel model.selectedFruit
            ]
        , example "Query completion"
            [ fruitSelectWithCompletion
            , selectedLabel model.selectedFruitWithCompletion
            ]
        , example "Sheet above"
            [ fruitSelectAbove
            , selectedLabel model.selectedFruitAbove
            ]
        , example "Max results (5)"
            [ fruitSelectLimited
            , selectedLabel model.selectedFruitLimited
            ]
        ]
