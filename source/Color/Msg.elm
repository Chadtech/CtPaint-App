module Color.Msg
    exposing
        ( Msg(..)
        )

import Color.Palette.Msg as Palette
import Color.Picker.Msg as Picker


type Msg
    = PickerMsg Picker.Msg
    | PaletteMsg Palette.Msg
