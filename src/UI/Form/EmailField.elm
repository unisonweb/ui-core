module UI.Form.EmailField exposing (..)

import Html exposing (Html)
import UI.Form.TextField as TextField exposing (TextField)


type alias EmailField msg =
    TextField msg



-- CREATE


field : (String -> msg) -> String -> String -> EmailField msg
field onInput label value =
    TextField.field onInput label value
        |> TextField.withType "email"


fieldWithoutLabel : (String -> msg) -> String -> String -> EmailField msg
fieldWithoutLabel onInput placeholder value =
    TextField.fieldWithoutLabel onInput placeholder value
        |> TextField.withType "email"



-- VIEW


view : EmailField msg -> Html msg
view =
    TextField.view
