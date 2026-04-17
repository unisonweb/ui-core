module UI.Form.SearchSelectTests exposing (..)

import Expect
import Html exposing (div, text)
import Html.Attributes exposing (class)
import Json.Decode as Json
import Lib.Search as Search exposing (Search)
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import UI.Form.SearchSelect as SearchSelect exposing (SearchSelect)


type Msg
    = UpdateSearch (Search String)
    | SelectItem String


searchSelectBelow : Search String -> SearchSelect String Msg
searchSelectBelow s =
    SearchSelect.searchSelect s UpdateSearch SelectItem


searchSelectAbove : Search String -> SearchSelect String Msg
searchSelectAbove s =
    SearchSelect.searchSelect s UpdateSearch SelectItem
        |> SearchSelect.withSheetAbove


decodeKey : SearchSelect String Msg -> String -> Result Json.Error Msg
decodeKey select key =
    let
        events =
            SearchSelect.toEvents select

        msgDecoder =
            Json.map .message events.keyMsg
    in
    Json.decodeString msgDecoder ("""{"key": \"""" ++ key ++ """"}""")


focusAfterKey : SearchSelect String Msg -> String -> Maybe String
focusAfterKey select key =
    case decodeKey select key of
        Ok (UpdateSearch updatedSearch) ->
            Search.searchResultsFocus updatedSearch

        _ ->
            Nothing


sheetPosition : Test
sheetPosition =
    describe "SearchSelect.sheetPosition"
        [ test "defaults to Below" <|
            \_ ->
                let
                    select =
                        SearchSelect.empty UpdateSearch SelectItem
                in
                Expect.equal SearchSelect.Below select.sheetPosition
        , test "withSheetAbove sets position to Above" <|
            \_ ->
                let
                    select =
                        SearchSelect.empty UpdateSearch SelectItem
                            |> SearchSelect.withSheetAbove
                in
                Expect.equal SearchSelect.Above select.sheetPosition
        ]


arrowKeysBelow : Test
arrowKeysBelow =
    let
        -- ["a", "b", "c"] with focus on "a"
        search =
            Search.fromList "q" [ "a", "b", "c" ]

        -- advance to "b"
        searchFocusedOnB =
            Search.searchResultsCycleNext search

        select =
            searchSelectBelow search

        selectFocusedOnB =
            searchSelectBelow searchFocusedOnB
    in
    describe "arrow keys with sheet below"
        [ test "ArrowDown cycles focus to the next result" <|
            \_ ->
                Expect.equal (Just "b") (focusAfterKey select "ArrowDown")
        , test "ArrowUp cycles focus to the previous result" <|
            \_ ->
                Expect.equal (Just "a") (focusAfterKey selectFocusedOnB "ArrowUp")
        ]


arrowKeysAbove : Test
arrowKeysAbove =
    let
        -- ["a", "b", "c"] with focus on "a"
        search =
            Search.fromList "q" [ "a", "b", "c" ]

        -- advance to "b"
        searchFocusedOnB =
            Search.searchResultsCycleNext search

        select =
            searchSelectAbove search

        selectFocusedOnB =
            searchSelectAbove searchFocusedOnB
    in
    describe "arrow keys with sheet above"
        [ test "ArrowUp cycles focus to the next result (moving up into the sheet)" <|
            \_ ->
                Expect.equal (Just "b") (focusAfterKey select "ArrowUp")
        , test "ArrowDown cycles focus to the previous result" <|
            \_ ->
                Expect.equal (Just "a") (focusAfterKey selectFocusedOnB "ArrowDown")
        ]


matchOrdering : Test
matchOrdering =
    let
        -- ["a", "b", "c"] where "a" is the best match
        search =
            Search.fromList "q" [ "a", "b", "c" ]

        viewMatch item _ =
            div [ class "search-select_match" ] [ text item ]

        emptyState =
            text "No results"

        sheetBelow =
            SearchSelect.viewSheet SearchSelect.Below Nothing viewMatch emptyState search

        sheetAbove =
            SearchSelect.viewSheet SearchSelect.Above Nothing viewMatch emptyState search
    in
    describe "match ordering in the sheet"
        [ test "sheet below renders best match first (top)" <|
            \_ ->
                sheetBelow
                    |> Query.fromHtml
                    |> Query.findAll [ Selector.class "search-select_match" ]
                    |> Query.index 0
                    |> Query.has [ Selector.text "a" ]
        , test "sheet above renders best match last (closest to the text field)" <|
            \_ ->
                sheetAbove
                    |> Query.fromHtml
                    |> Query.findAll [ Selector.class "search-select_match" ]
                    |> Query.index 2
                    |> Query.has [ Selector.text "a" ]
        , test "sheet above renders worst match first (farthest from the text field)" <|
            \_ ->
                sheetAbove
                    |> Query.fromHtml
                    |> Query.findAll [ Selector.class "search-select_match" ]
                    |> Query.index 0
                    |> Query.has [ Selector.text "c" ]
        ]


maxResultsTest : Test
maxResultsTest =
    let
        search =
            Search.fromList "q" [ "a", "b", "c", "d", "e" ]

        viewMatch item _ =
            div [ class "search-select_match" ] [ text item ]

        emptyState =
            text "No results"
    in
    describe "maxResults"
        [ test "limits the number of rendered matches" <|
            \_ ->
                SearchSelect.viewSheet SearchSelect.Below (Just 3) viewMatch emptyState search
                    |> Query.fromHtml
                    |> Query.findAll [ Selector.class "search-select_match" ]
                    |> Query.count (Expect.equal 3)
        , test "shows the first N matches when sheet is below" <|
            \_ ->
                SearchSelect.viewSheet SearchSelect.Below (Just 2) viewMatch emptyState search
                    |> Query.fromHtml
                    |> Query.findAll [ Selector.class "search-select_match" ]
                    |> Query.index 1
                    |> Query.has [ Selector.text "b" ]
        , test "shows all matches when limit exceeds result count" <|
            \_ ->
                SearchSelect.viewSheet SearchSelect.Below (Just 100) viewMatch emptyState search
                    |> Query.fromHtml
                    |> Query.findAll [ Selector.class "search-select_match" ]
                    |> Query.count (Expect.equal 5)
        , test "ArrowDown cycles only within the visible results" <|
            \_ ->
                let
                    -- ["a", "b", "c", "d", "e"] limited to 3
                    -- press 1: "b", press 2: "c", press 3: wraps to "a"
                    -- without the fix it would walk to "d" on the 3rd press
                    select =
                        SearchSelect.searchSelect search UpdateSearch SelectItem
                            |> SearchSelect.withMaxResults 3

                    after2 =
                        select
                            |> applyKey "ArrowDown"
                            |> applyKey "ArrowDown"

                    focusAfter3Downs =
                        focusAfterKey after2 "ArrowDown"
                in
                Expect.equal (Just "a") focusAfter3Downs
        ]


applyKey : String -> SearchSelect String Msg -> SearchSelect String Msg
applyKey key select =
    case decodeKey select key of
        Ok (UpdateSearch updatedSearch) ->
            { select | search = updatedSearch }

        _ ->
            select
