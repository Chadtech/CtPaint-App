module Data.Palette exposing (Swatches, initPalette, initSwatches)

import Array exposing (Array)
import Color exposing (Color)
import ColorPicker


-- TYPES --


type alias Model =
    { colors : Array Color
    , swatches : Swatches
    , picker : ColorPicker.Model
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
    [ Color.rgba 176 166 154 255
    , Color.black
    , Color.white
    , Color.rgba 101 92 74 255
    , Color.rgba 85 96 45 255
    , Color.rgba 172 214 48 255
    , Color.rgba 221 201 142 255
    , Color.rgba 243 210 21 255
    , Color.rgba 240 146 50 255
    , Color.rgba 255 91 49 255
    , Color.rgba 212 51 27 255
    , Color.rgba 242 29 35 255
    , Color.rgba 252 164 132 255
    , Color.rgba 230 121 166 255
    , Color.rgba 80 0 87 255
    , Color.rgba 240 224 214 255
    , Color.rgba 255 255 238 255
    , Color.rgba 157 144 136 255
    , Color.rgba 50 54 128 255
    , Color.rgba 36 33 157 255
    , Color.rgba 0 47 167 255
    , Color.rgba 23 92 254 255
    , Color.rgba 10 186 181 255
    , Color.rgba 159 170 210 255
    , Color.rgba 214 218 240 255
    , Color.rgba 238 242 255 255
    , Color.rgba 157 212 147 255
    , Color.rgba 170 211 13 255
    , Color.rgba 60 182 99 255
    , Color.rgba 10 202 26 255
    , Color.rgba 201 207 215 255
    ]
        |> Array.fromList


initSwatches : Swatches
initSwatches =
    { primary = Color.rgba 176 166 154 255
    , first = Color.black
    , second = Color.white
    , third = Color.rgba 241 29 35 255
    , keyIsDown = False
    }
