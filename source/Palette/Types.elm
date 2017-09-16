module Palette.Types exposing (..)

import Color exposing (Color)
import ParseInt


type Msg
    = PaletteSquareClick Color
    | WakeUpColorPicker Color Int


type alias Swatches =
    { primary : Color
    , first : Color
    , second : Color
    , third : Color
    , keyIsDown : Bool
    }



-- HELPERS --


toHex : Color -> String
toHex color =
    let
        { red, green, blue } =
            Color.toRgb color
    in
    [ "#"
    , toHexHelper <| ParseInt.toHex red
    , toHexHelper <| ParseInt.toHex green
    , toHexHelper <| ParseInt.toHex blue
    ]
        |> String.concat


toHexHelper : String -> String
toHexHelper hex =
    if String.length hex > 1 then
        hex
    else
        "0" ++ hex


toColor : String -> Maybe Color
toColor colorMaybe =
    if isSixChars colorMaybe then
        let
            r =
                String.slice 0 2 colorMaybe
                    |> ParseInt.parseIntHex

            g =
                String.slice 2 4 colorMaybe
                    |> ParseInt.parseIntHex

            b =
                String.slice 4 6 colorMaybe
                    |> ParseInt.parseIntHex
        in
        case ( r, g, b ) of
            ( Ok red, Ok green, Ok blue ) ->
                Just (Color.rgb red green blue)

            _ ->
                Nothing
    else
        Nothing


isSixChars : String -> Bool
isSixChars =
    (==) 6 << String.length
