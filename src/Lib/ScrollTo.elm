module Lib.ScrollTo exposing (..)

import Browser.Dom as Dom
import Task


scrollTo : msg -> String -> String -> Cmd msg
scrollTo doneMsg containerId targetId =
    scrollTo_ doneMsg containerId targetId 0


scrollTo_ : msg -> String -> String -> Float -> Cmd msg
scrollTo_ doneMsg containerId targetId marginTop =
    Task.sequence
        [ Dom.getElement targetId |> Task.map (.element >> .y)
        , Dom.getElement containerId |> Task.map (.element >> .y)
        , Dom.getViewportOf containerId |> Task.map (.viewport >> .y)
        ]
        |> Task.andThen
            (\ys ->
                case ys of
                    elY :: viewportY :: viewportScrollTop :: [] ->
                        Dom.setViewportOf containerId 0 (viewportScrollTop + (elY - viewportY) - marginTop)
                            |> Task.onError (\_ -> Task.succeed ())

                    _ ->
                        Task.succeed ()
            )
        |> Task.attempt (always doneMsg)
