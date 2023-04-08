module Stories.Code.Readme exposing (..)

import Browser
import Code.Definition.Doc as Doc
import Code.Definition.Readme as Readme exposing (Readme)
import Code.Syntax as Syntax
import Code.Workspace.Zoom exposing (Zoom(..))
import Html exposing (Html)
import UI.Click as Click


sampleToClick : Syntax.ToClick ()
sampleToClick =
    \_ -> Click.Disabled


sampleTooltipConfig : Syntax.TooltipConfig ()
sampleTooltipConfig =
    { toHoverStart = \_ -> ()
    , toHoverEnd = \_ -> ()
    , toTooltip = \_ -> Nothing
    }


config : Syntax.LinkedWithTooltipConfig ()
config =
    { toClick = sampleToClick
    , tooltip = sampleTooltipConfig
    }


sampleFoldId : Doc.FoldId
sampleFoldId =
    Doc.FoldId []


sampleToggles : Doc.DocFoldToggles
sampleToggles =
    Doc.emptyDocFoldToggles


sampleReadme : Readme
sampleReadme =
    Readme.Readme <| Doc.Word "sample doc word"


sampleView : Html ()
sampleView =
    Readme.view
        config
        (\_ -> ())
        sampleToggles
        sampleReadme


type alias Model =
    ()


main : Program () Model ()
main =
    Browser.element
        { init = \_ -> ( (), Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


update : () -> () -> ( (), Cmd () )
update _ _ =
    ( (), Cmd.none )


view : Model -> Html ()
view _ =
    sampleView
