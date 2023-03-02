module Lib.ScrollTo exposing (..)

import Browser.Dom as Dom
import Task


scrollTo : msg -> String -> String -> Cmd msg
scrollTo doneMsg containerId targetId =
    Task.sequence
        [ Dom.getElement targetId |> Task.map (.element >> .y)
        , Dom.getElement containerId |> Task.map (.element >> .y)
        , Dom.getViewportOf containerId |> Task.map (.viewport >> .y)
        ]
        |> Task.andThen
            (\ys ->
                case Debug.log "elY, viewportY, viewportscrollTop" ys of
                    elY :: viewportY :: viewportScrollTop :: [] ->
                        Dom.setViewportOf containerId 0 (viewportScrollTop + (elY - viewportY))
                            |> Task.onError (\_ -> Task.succeed ())

                    _ ->
                        Task.succeed ()
            )
        |> Task.attempt (Debug.log "result" >> always doneMsg)
