module Data.Palette exposing (Swatches, initPalette, initSwatches)

import Array exposing (Array)
import Color exposing (Color)
import Data.Picker as Picker


-- TYPES --


type alias Model =
    { colors : Array Color
    , swatches : Swatches
    , picker : Picker.Model
    }


type alias Swatches =
    { primary : Color
    , first : Color
    , second : Color
    , third : Color
    , keyIsDown : Bool
    }



-- INIT --


initPalette : Array Color
initPalette =
    [ Color.rgb 176 166 154
    , Color.black
    , Color.white
    , Color.rgb 101 92 74
    , Color.rgb 85 96 45
    , Color.rgb 172 214 48
    , Color.rgb 221 201 142
    , Color.rgb 243 210 21
    , Color.rgb 240 146 50
    , Color.rgb 255 91 49
    , Color.rgb 212 51 27
    , Color.rgb 242 29 35
    , Color.rgb 252 164 132
    , Color.rgb 230 121 166
    , Color.rgb 80 0 87
    , Color.rgb 240 224 214
    , Color.rgb 255 255 238
    , Color.rgb 157 144 136
    , Color.rgb 50 54 128
    , Color.rgb 36 33 157
    , Color.rgb 0 47 167
    , Color.rgb 23 92 254
    , Color.rgb 10 186 181
    , Color.rgb 159 170 210
    , Color.rgb 214 218 240
    , Color.rgb 238 242 255
    , Color.rgb 157 212 147
    , Color.rgb 170 211 13
    , Color.rgb 60 182 99
    , Color.rgb 10 202 26
    , Color.rgb 201 207 215
    ]
        |> Array.fromList


initSwatches : Swatches
initSwatches =
    { primary = Color.rgb 176 166 154
    , first = Color.black
    , second = Color.white
    , third = Color.rgb 241 29 35
    , keyIsDown = False
    }
