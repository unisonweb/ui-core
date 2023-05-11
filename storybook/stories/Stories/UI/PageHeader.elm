module Stories.UI.PageHeader exposing (..)

import Browser
import Html exposing (Html, div, text)
import UI.Click as Click
import UI.Icon as Icon
import UI.Navigation as Nav
import UI.PageHeader as PageHeader exposing (PageHeader)


type alias Model =
    { mobileNavIsOpen : Bool
    }


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( { mobileNavIsOpen = False }, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


type Msg
    = NoOp
    | ToggleMobileNav


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ToggleMobileNav ->
            ( { model | mobileNavIsOpen = not model.mobileNavIsOpen }, Cmd.none )


view : Model -> Html Msg
view model =
    pageHeader model
        |> PageHeader.view


pageHeader : Model -> PageHeader Msg
pageHeader model =
    let
        click =
            Click.onClick NoOp

        context =
            { isActive = False
            , content = div [] [ text "Pageheader Context" ]
            , click = Just click
            }

        allNavItems_ =
            { code =
                Nav.navItem "Code" click
                    |> Nav.navItemWithIcon Icon.ability
            , releases =
                Nav.navItem "Releases" click
                    |> Nav.navItemWithIcon Icon.rocket
            , settings =
                Nav.navItem "Settings" click
                    |> Nav.navItemWithIcon Icon.cog
            }

        nav =
            { navigation =
                Nav.withItems []
                    allNavItems_.code
                    [ allNavItems_.releases, allNavItems_.settings ]
                    Nav.empty
            , mobileNavToggleMsg = ToggleMobileNav
            , mobileNavIsOpen = model.mobileNavIsOpen
            }
    in
    context
        |> PageHeader.pageHeader
        |> PageHeader.withNavigation nav
        |> PageHeader.withRightSide []
