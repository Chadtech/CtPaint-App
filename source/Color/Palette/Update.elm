module Color.Palette.Update
    exposing
        ( update
        )

import Array
import Color.Model exposing (Model)
import Color.Palette.Msg exposing (Msg(..))
import Color.Picker.Data as Picker
import Color.Swatches.Data as Swatches


update : Msg -> Model -> Model
update msg model =
    case msg of
        -- This bool represents if shift is down
        SquareClicked index color True ->
            { model
                | palette =
                    Array.set
                        index
                        model.swatches.top
                        model.palette
            }

        SquareClicked index color False ->
            { model
                | swatches =
                    Swatches.setTop
                        color
                        model.swatches
            }

        SquareRightClicked color index ->
            { model
                | picker =
                    { show = True
                    , index = index
                    , color = color
                    , position = model.picker.position
                    }
                        |> Picker.init
            }

        AddSquareClicked ->
            { model
                | palette =
                    Array.push
                        model.swatches.bottom
                        model.palette
            }
