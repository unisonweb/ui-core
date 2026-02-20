module Stories.UI.Form.SearchSelect exposing (..)

import Browser
import Helpers.Layout exposing (rows)
import Html exposing (Html, div, text)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Lib.Search as Search exposing (Search)
import UI.Form.SearchSelect as SearchSelect


type alias Model =
    { fruitSearch : Search String
    , selectedFruit : Maybe String
    , colorSearch : Search String
    }


type Msg
    = UpdateFruitSearch (Search String)
    | SelectFruit String


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
                ( { fruitSearch =
                        Search.empty
                  , selectedFruit = Nothing
                  , colorSearch = Search.empty
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


viewMatch : (String -> Msg) -> String -> Bool -> Html Msg
viewMatch selectMsg item isFocused =
    div
        [ class "search-select_match"
        , style "padding" "0.5rem 0.75rem"
        , style "cursor" "pointer"
        , style "background"
            (if isFocused then
                "var(--u-color_element_hovered, #f0f0f0)"

             else
                "transparent"
            )
        , onClick (selectMsg item)
        ]
        [ text item ]


view : Model -> Html Msg
view model =
    let
        fruitSelect =
            SearchSelect.searchSelect model.fruitSearch UpdateFruitSearch SelectFruit
                |> SearchSelect.withPlaceholder "Search fruits..."
                |> SearchSelect.view (viewMatch SelectFruit)
    in
    rows
        [ style "gap" "2rem", style "padding" "1.5rem" ]
        [ div
            [ style "display" "flex"
            , style "flex-direction" "column"
            , style "gap" "0.5rem"
            ]
            [ fruitSelect
            , div
                [ style "font-size" "var(--font-size-medium)"
                , style "color" "var(--u-color_text_subdued)"
                ]
                [ text ("Selected: " ++ Maybe.withDefault "No selection" model.selectedFruit)
                ]
            ]
        ]
