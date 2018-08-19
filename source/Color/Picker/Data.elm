module Color.Picker.Data
    exposing
        ( ClickState(..)
        , Error(..)
        , Fields
        , Picker
        , close
        , init
        , mapFields
        , removeGradientClickedOn
        , setError
        , setFieldsFromColor
        , setGradientClickedOn
        , setHeaderClickState
        , setHexField
        , setPosition
        )

import Color exposing (Color)
import Color.Picker.Data.Gradient
    exposing
        ( Gradient
        )
import Color.Util
import Data.Position exposing (Position)
import Util


-- TYPES --


type alias Picker =
    { colorIndex : Int
    , fields : Fields
    , gradientClickedOn : Maybe Gradient
    , position : Position
    , headerClickState : ClickState
    , show : Bool
    , error : Maybe Error
    }


type alias Fields =
    { red : String
    , green : String
    , blue : String
    , hue : String
    , saturation : String
    , lightness : String
    , colorHex : String
    }


type Error
    = NoColorAtIndex


type ClickState
    = NoClicks
    | ClickAt Position
    | XButtonIsDown



-- INIT --


type alias Flags =
    { show : Bool
    , index : Int
    , color : Color
    , position : Position
    }


init : Flags -> Picker
init flags =
    { colorIndex = flags.index
    , fields = initFields flags.color
    , gradientClickedOn = Nothing
    , position = flags.position
    , headerClickState = NoClicks
    , show = flags.show
    , error = Nothing
    }


initFields : Color -> Fields
initFields color =
    let
        { red, green, blue } =
            Color.toRgb color

        { hue, saturation, lightness } =
            Color.toHsl color
    in
    { red = toString red
    , green = toString green
    , blue = toString blue
    , hue =
        (radians (Util.filterNan hue) / (2 * pi) * 360)
            |> floor
            |> toString
    , saturation =
        (saturation * 255)
            |> floor
            |> toString
    , lightness =
        (lightness * 255)
            |> floor
            |> toString
    , colorHex =
        color
            |> Color.Util.toHexString
            |> String.dropLeft 1
    }



-- PUBLIC HELPERS --


setPosition : Position -> Picker -> Picker
setPosition position picker =
    { picker
        | position = position
    }


setFieldsFromColor : Color -> Picker -> Picker
setFieldsFromColor color picker =
    { picker | fields = initFields color }


mapFields : (Fields -> Fields) -> Picker -> Picker
mapFields f picker =
    { picker | fields = f picker.fields }


setError : Error -> Picker -> Picker
setError error picker =
    { picker | error = Just error }


setGradientClickedOn : Gradient -> Picker -> Picker
setGradientClickedOn gradient picker =
    { picker | gradientClickedOn = Just gradient }


removeGradientClickedOn : Picker -> Picker
removeGradientClickedOn picker =
    { picker | gradientClickedOn = Nothing }


setHexField : String -> Picker -> Picker
setHexField str ({ fields } as picker) =
    { picker
        | fields = { fields | colorHex = str }
    }


close : Picker -> Picker
close picker =
    { picker
        | show = False
        , headerClickState = NoClicks
    }


setHeaderClickState : ClickState -> Picker -> Picker
setHeaderClickState clickState picker =
    { picker | headerClickState = clickState }
