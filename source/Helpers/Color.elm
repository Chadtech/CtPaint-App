module Helpers.Color
    exposing
        ( setKeyAsDown
        , setKeyAsUp
        , setPaletteColor
        , setSwatches
        , setTop
        , swatchesTurnLeft
        , swatchesTurnRight
        , toggleColorPicker
        )

import Array
import Color exposing (Color)
import Data.Color
    exposing
        ( Model
        , Swatches
        )
import Data.Picker as Picker


setTop : Color -> Swatches -> Swatches
setTop color swatches =
    { swatches | top = color }


setSwatches : Swatches -> Model -> Model
setSwatches swatches model =
    { model | swatches = swatches }


setPaletteColor : Int -> Color -> Model -> Model
setPaletteColor index color ({ palette, picker } as model) =
    { model
        | palette = Array.set index color palette
        , picker =
            if picker.fields.index == index then
                setPickerColor color picker
            else
                picker
    }


setPickerColor : Color -> Picker.Model -> Picker.Model
setPickerColor color ({ fields } as picker) =
    { picker | fields = { fields | color = color } }


swatchesTurnLeft : Model -> Model
swatchesTurnLeft ({ swatches } as model) =
    { model
        | swatches =
            { swatches
                | top = model.swatches.left
                , left = model.swatches.bottom
                , bottom = model.swatches.right
                , right = model.swatches.top
            }
    }


swatchesTurnRight : Model -> Model
swatchesTurnRight ({ swatches } as model) =
    { model
        | swatches =
            { swatches
                | top = model.swatches.right
                , left = model.swatches.top
                , bottom = model.swatches.left
                , right = model.swatches.bottom
            }
    }


setKeyAsUp : Model -> Model
setKeyAsUp ({ swatches } as model) =
    { model
        | swatches =
            { swatches | keyIsDown = False }
    }


setKeyAsDown : Model -> Model
setKeyAsDown ({ swatches } as model) =
    { model
        | swatches =
            { swatches | keyIsDown = True }
    }


toggleColorPicker : Model -> Model
toggleColorPicker ({ picker } as model) =
    let
        { window } =
            picker
    in
    { model
        | picker =
            { picker
                | window =
                    { window
                        | show = not window.show
                    }
            }
    }
