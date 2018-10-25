module Color.Palette.Track exposing (track)

import Color.Palette.Msg exposing (Msg(..))
import Data.Tracking as Tracking


track : Msg -> Tracking.Event
track msg =
    case msg of
        SquareClicked _ _ _ ->
            "square-clicked"
                |> Tracking.noProps

        SquareRightClicked _ _ ->
            "square-right-clicked"
                |> Tracking.noProps

        AddSquareClicked ->
            "add-square-clicked"
                |> Tracking.noProps
