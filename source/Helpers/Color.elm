module Helpers.Color
    exposing
        ( setKeyAsDown
        , setKeyAsUp
        , setPaletteColor
        , setPrimary
        , setSwatches
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


setPrimary : Color -> Swatches -> Swatches
setPrimary color swatches =
    { swatches | primary = color }


setSwatches : Swatches -> Model -> Model
setSwatches swatches model =
    { model | swatches = swatches }


setPaletteColor : Int -> Color -> Model -> Model
setPaletteColor index color ({ palette, picker } as model) =
    { model
        | palette = Array.set index color palette
        , picker =
            if picker.fields.index == index then
                let
                    { fields } =
                        picker
                in
                { picker
                    | fields = { fields | color = color }
                }
            else
                picker
    }


swatchesTurnLeft : Model -> Model
swatchesTurnLeft ({ swatches } as model) =
    { model
        | swatches =
            { swatches
                | primary = model.swatches.first
                , first = model.swatches.second
                , second = model.swatches.third
                , third = model.swatches.primary
            }
    }


swatchesTurnRight : Model -> Model
swatchesTurnRight ({ swatches } as model) =
    { model
        | swatches =
            { swatches
                | primary = model.swatches.third
                , first = model.swatches.primary
                , second = model.swatches.first
                , third = model.swatches.second
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
