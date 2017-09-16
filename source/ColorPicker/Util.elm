module ColorPicker.Util exposing (doesntHaveHue, wakeUp)

import Color exposing (Color)
import Types exposing (Model)
import Util


doesntHaveHue : Color -> Bool
doesntHaveHue color =
    let
        { red, green, blue } =
            Color.toRgb color
    in
    Util.allTrue
        [ red == green
        , green == blue
        , blue == red
        ]


wakeUp : Int -> Color -> Model -> Model
wakeUp index color ({ colorPicker } as model) =
    { model
        | colorPicker =
            { colorPicker
                | color = color
                , index = index
                , show = True
            }
    }
