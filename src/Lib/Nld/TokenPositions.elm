module Lib.Nld.TokenPositions exposing (..)

import Dict exposing (Dict)
import Set exposing (Set)


type alias TokenPositions =
    { toMap : Dict String (Set Int)
    , byPosition : Dict Int String
    }


fromList : List String -> TokenPositions
fromList tokens =
    let
        addPos i x =
            case x of
                Nothing ->
                    Just (Set.singleton i)

                Just s ->
                    Just (Set.insert i s)

        go textToPos posToText i xs =
            case xs of
                [] ->
                    TokenPositions textToPos posToText

                t :: ts ->
                    go (Dict.update t (addPos i) textToPos) (Dict.insert i t posToText) (i + 1) ts
    in
    go Dict.empty Dict.empty 0 tokens


positions : String -> TokenPositions -> Set Int
positions t tp =
    Maybe.withDefault Set.empty (Dict.get t tp.toMap)


remove : String -> Int -> TokenPositions -> TokenPositions
remove t pos tp =
    let
        delPos x =
            Maybe.map (Set.remove pos) x

        newTextToPos =
            Dict.update t delPos tp.toMap

        newPosToText =
            Dict.remove pos tp.byPosition
    in
    TokenPositions newTextToPos newPosToText


gapCost : Int -> Int -> Float
gapCost prevPos currentPos =
    if currentPos >= prevPos then
        toFloat (currentPos - prevPos)

    else
        1.5 * toFloat (prevPos - currentPos + 1)
