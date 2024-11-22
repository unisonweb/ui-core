module Code.ReadmeCard exposing (..)

import Code.Config exposing (Config)
import Code.Definition.Doc as Doc exposing (DocFoldToggles)
import Code.Definition.Readme as Readme exposing (Readme)
import Code.Definition.Reference exposing (Reference)
import Code.DefinitionSummaryTooltip as DefinitionSummaryTooltip
import Code.Syntax.SyntaxConfig as SyntaxConfig
import Html exposing (Html, p)
import UI.Button as Button
import UI.Card as Card exposing (Card)
import UI.Click as Click
import UI.ErrorCard as ErrorCard
import UI.Icon as Icon
import UI.Placeholder as Placeholder



-- MODEL


type alias Model =
    { foldToggles : DocFoldToggles
    , definitionSummaryTooltip : DefinitionSummaryTooltip.Model
    }


init : Model
init =
    { foldToggles = Doc.emptyDocFoldToggles
    , definitionSummaryTooltip = DefinitionSummaryTooltip.init
    }



-- UPDATE


type Msg
    = OpenReference Reference
    | ToggleDocFold Doc.FoldId
    | DefinitionSummaryTooltipMsg DefinitionSummaryTooltip.Msg


type OutMsg
    = OpenDefinition Reference
    | None


update : Config -> Msg -> Model -> ( Model, Cmd Msg, OutMsg )
update config msg model =
    case msg of
        OpenReference r ->
            ( model, Cmd.none, OpenDefinition r )

        ToggleDocFold fid ->
            ( { model | foldToggles = Doc.toggleFold model.foldToggles fid }, Cmd.none, None )

        DefinitionSummaryTooltipMsg tMsg ->
            let
                ( definitionSummaryTooltip, tCmd ) =
                    DefinitionSummaryTooltip.update config tMsg model.definitionSummaryTooltip
            in
            ( { model | definitionSummaryTooltip = definitionSummaryTooltip }
            , Cmd.map DefinitionSummaryTooltipMsg tCmd
            , None
            )


asCard : Model -> Readme -> Card Msg
asCard model readme =
    let
        syntaxConfig =
            SyntaxConfig.default
                (OpenReference >> Click.onClick)
                (DefinitionSummaryTooltip.tooltipConfig
                    DefinitionSummaryTooltipMsg
                    model.definitionSummaryTooltip
                )
    in
    Card.titled "Readme"
        [ Readme.view syntaxConfig ToggleDocFold model.foldToggles readme
        ]
        |> Card.withClassName "readme-card"



-- VIEW


viewLoading : Html msg
viewLoading =
    let
        shape length =
            Placeholder.text
                |> Placeholder.withLength length
                |> Placeholder.subdued
                |> Placeholder.tiny

        shapes =
            [ shape Placeholder.Large
            , shape Placeholder.Medium
            , shape Placeholder.Huge
            , shape Placeholder.Small
            , shape Placeholder.Medium
            , shape Placeholder.Large
            , shape Placeholder.Small
            ]
                |> List.map Placeholder.view
    in
    Card.card
        ([ p [] [ Placeholder.view (shape Placeholder.Tiny) ]
         , p [] [ Placeholder.view (shape Placeholder.Medium) ]
         ]
            ++ shapes
        )
        |> Card.asContained
        |> Card.view


viewError : msg -> Html msg
viewError retryClickMsg =
    let
        retry =
            Button.iconThenLabel retryClickMsg Icon.refresh "Try Again"
                |> Button.medium
                |> Button.subdued
    in
    ErrorCard.errorCard_
        "Couldn't load the README"
        "Something unexpected happened on our end when loading the README and we can't display it."
        retry
        |> ErrorCard.toCard
        |> Card.asContainedWithFade
        |> Card.view


view : Model -> Readme -> Html Msg
view model readme =
    readme
        |> asCard model
        |> Card.view
