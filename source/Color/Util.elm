module Color.Util exposing (..)

import Color exposing (Color)
import Html exposing (Attribute)
import Html.Attributes exposing (style)
import ParseInt exposing (parseIntHex)


doesntHaveHue : Color -> Bool
doesntHaveHue color =
    let
        { red, green, blue } =
            Color.toRgb color
    in
    red == green && green == blue && blue == red


fromString : String -> Maybe Color
fromString str =
    if 6 == String.length str then
        let
            r =
                String.slice 0 2 str
                    |> parseIntHex

            g =
                String.slice 2 4 str
                    |> parseIntHex

            b =
                String.slice 4 6 str
                    |> parseIntHex
        in
        case ( r, g, b ) of
            ( Ok red, Ok green, Ok blue ) ->
                Just (Color.rgb red green blue)

            _ ->
                Nothing
    else
        Nothing


toHexString : Color -> String
toHexString color =
    let
        { red, green, blue } =
            Color.toRgb color
    in
    [ "#"
    , toHex red
    , toHex green
    , toHex blue
    ]
        |> String.concat


toHex : Int -> String
toHex =
    ParseInt.toHex >> toHexHelper


toHexHelper : String -> String
toHexHelper hex =
    if String.length hex > 1 then
        hex
    else
        "0" ++ hex



-- CSS -


background : Color -> Attribute msg
background color =
    color
        |> toHexString
        |> (,) "background"
        |> List.singleton
        |> style
