module Color.Track exposing (track)

import Color.Msg exposing (Msg(..))
import Color.Palette.Track as Palette
import Color.Picker.Track as Picker
import Data.Tracking as Tracking


track : Msg -> Tracking.Event
track msg =
    case msg of
        PickerMsg subMsg ->
            Picker.track subMsg
                |> Tracking.namespace "picker"

        PaletteMsg subMsg ->
            Palette.track subMsg
                |> Tracking.namespace "palette"
