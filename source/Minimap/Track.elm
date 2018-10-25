module Minimap.Track exposing (track)

import Data.Tracking as Tracking
import Minimap.Msg exposing (Msg(..))


track : Msg -> Tracking.Event
track msg =
    case msg of
        XButtonMouseDown ->
            Tracking.none

        XButtonMouseUp ->
            "x-button-mouse-up"
                |> Tracking.noProps

        ZoomInClicked ->
            "zoom-in-clicked"
                |> Tracking.noProps

        ZoomOutClicked ->
            "zoom-out-clicked"
                |> Tracking.noProps

        CenterClicked ->
            "center-clicked"
                |> Tracking.noProps

        HeaderMouseDown _ ->
            "header-mouse-down"
                |> Tracking.noProps

        MinimapPortalMouseDown _ ->
            Tracking.none

        MouseMoved _ ->
            Tracking.none

        MouseUp ->
            Tracking.none
