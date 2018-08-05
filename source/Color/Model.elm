module Color.Model
    exposing
        ( Model
        , applyTo
        , getPickersColor
        , init
        , mapPaletteColor
        , mapPicker
        , mapPickersColor
        , mapSwatches
        , setPaletteColor
        , setPicker
        , setPickersColor
        , setSwatches
        , syncPickersFields
        , toggleColorPicker
        )

import Array exposing (Array)
import Color exposing (Color)
import Color.Palette.Data as Palette
import Color.Picker.Data as Picker
    exposing
        ( Picker
        )
import Color.Swatches.Data as Swatches
    exposing
        ( Swatches
        )


-- TYPES --


type alias Model =
    { palette : Array Color
    , swatches : Swatches
    , picker : Picker
    }



-- INIT --


init : Model
init =
    { palette = Palette.init
    , swatches = Swatches.init
    , picker =
        { show = False
        , index = 0
        , color = Color.black
        , position = { x = 50, y = 350 }
        }
            |> Picker.init
    }



-- PUBLIC HELPERS --


applyTo : Model -> (Model -> Model) -> Model
applyTo model f =
    f model


setPicker : Picker -> Model -> Model
setPicker picker model =
    { model | picker = picker }


mapPicker : (Picker -> Picker) -> Model -> Model
mapPicker f model =
    { model | picker = f model.picker }


toggleColorPicker : Model -> Model
toggleColorPicker ({ picker } as model) =
    { model
        | picker =
            { picker
                | show = not picker.show
            }
    }


getPickersColor : Model -> Maybe Color
getPickersColor model =
    Array.get model.picker.colorIndex model.palette


mapPickersColor : (Color -> Color) -> Model -> Model
mapPickersColor f model =
    mapPaletteColor model.picker.colorIndex f model
        |> syncPickersFields


syncPickersFields : Model -> Model
syncPickersFields model =
    case getPickersColor model of
        Just color ->
            Picker.setFieldsFromColor color
                |> mapPicker
                |> applyTo model

        Nothing ->
            Picker.setError Picker.NoColorAtIndex
                |> mapPicker
                |> applyTo model


setPickersColor : Color -> Model -> Model
setPickersColor color model =
    setPaletteColor model.picker.colorIndex color model
        |> syncPickersFields


setPaletteColor : Int -> Color -> Model -> Model
setPaletteColor index color ({ palette, picker } as model) =
    { model
        | palette = Array.set index color palette
    }


mapPaletteColor : Int -> (Color -> Color) -> Model -> Model
mapPaletteColor index f model =
    { model
        | palette =
            case Array.get index model.palette of
                Just color ->
                    Array.set index (f color) model.palette

                Nothing ->
                    model.palette
    }


mapSwatches : (Swatches -> Swatches) -> Model -> Model
mapSwatches f model =
    { model | swatches = f model.swatches }


setSwatches : Swatches -> Model -> Model
setSwatches swatches model =
    { model | swatches = swatches }
