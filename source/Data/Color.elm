module Data.Color
    exposing
        ( BackgroundColor(..)
        , Model
        , Swatches
        , backgroundColorDecoder
        , encodeCanvas
        , encodePalette
        , encodeSwatches
        , init
        )

import Array exposing (Array)
import Canvas exposing (Canvas)
import Color exposing (Color)
import Data.Picker as Picker
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)
import Tuple.Infix exposing ((:=))
import Util


-- TYPES --


type alias Model =
    { palette : Array Color
    , swatches : Swatches
    , picker : Picker.Model
    }


type alias Swatches =
    { top : Color
    , left : Color
    , bottom : Color
    , right : Color
    , keyIsDown : Bool
    }


type BackgroundColor
    = Black
    | White



-- INIT --


init : Model
init =
    { palette = initPalette
    , swatches = initSwatches
    , picker = Picker.init False 0 (Color.rgb 176 166 154)
    }


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
    { top = Color.rgb 176 166 154
    , left = Color.black
    , bottom = Color.white
    , right = Color.rgb 241 29 35
    , keyIsDown = False
    }



-- ENCODER --


encodeCanvas : Canvas -> Value
encodeCanvas =
    Canvas.toDataUrl "image/png" 1 >> Encode.string


encodeColor : Color -> Value
encodeColor =
    Util.toHexColor >> Encode.string


encodeSwatches : Swatches -> Value
encodeSwatches { top, left, bottom, right } =
    [ "top" := encodeColor top
    , "left" := encodeColor left
    , "bottom" := encodeColor bottom
    , "right" := encodeColor right
    ]
        |> Encode.object


encodePalette : Array Color -> Value
encodePalette =
    Array.map encodeColor >> Encode.array



-- DECODER --


backgroundColorDecoder : Decoder BackgroundColor
backgroundColorDecoder =
    Decode.string
        |> Decode.andThen toBackgroundColor


toBackgroundColor : String -> Decoder BackgroundColor
toBackgroundColor str =
    case str of
        "black" ->
            Decode.succeed Black

        "white" ->
            Decode.succeed White

        _ ->
            Decode.fail ("Background color isnt black or white, its " ++ str)
