module Color.Data.Colors
    exposing
        ( ctPoint
        , ctPrettyBlue
        , ctRed
        , encode
        )

import Color exposing (Color)
import Color.Util
import Json.Encode as JE


-- CONSTANTS --


ctPoint : Color
ctPoint =
    Color.rgb 176 166 154


ctRed : Color
ctRed =
    Color.rgb 242 29 35


ctPrettyBlue : Color
ctPrettyBlue =
    Color.rgb 23 92 254



-- ENCODER --


encode : Color -> JE.Value
encode =
    Color.Util.toHexString >> JE.string
