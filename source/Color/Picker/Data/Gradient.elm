module Color.Picker.Data.Gradient exposing
    ( Gradient(..)
    , toString
    )

-- TYPES --


type Gradient
    = Red
    | Green
    | Blue
    | Hue
    | Saturation
    | Lightness



-- HELPERS --


toString : Gradient -> String
toString gradient =
    case gradient of
        Red ->
            "red"

        Green ->
            "green"

        Blue ->
            "blue"

        Hue ->
            "hue"

        Saturation ->
            "saturation"

        Lightness ->
            "lightness"
