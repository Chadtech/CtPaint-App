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
            if picker.index == index then
                { picker | color = color }
            else
                picker
    }


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
    { model
        | picker =
            { picker
                | show = not picker.show
            }
    }
