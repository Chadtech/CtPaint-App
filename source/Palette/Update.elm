module Palette.Update exposing (update)

import ColorPicker.Util as ColorPicker
import Keyboard.Extra exposing (Key(..))
import List.Unique
import Model exposing (Model)
import Msg as MainMsg
import Palette.Types exposing (Msg(..))
import Types.Mouse exposing (Direction(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ResizeToolbar direction ->
            handleResize direction model

        WakeUpColorPicker color index ->
            let
                newModel =
                    ColorPicker.wakeUp
                        index
                        color
                        model
            in
            newModel ! []

        PaletteSquareClick color ->
            let
                { swatches } =
                    model
            in
            { model
                | swatches =
                    { swatches
                        | primary = color
                    }
            }
                ! []


shiftIsDown : Model -> Bool
shiftIsDown { keysDown } =
    List.Unique.member
        (Keyboard.Extra.toCode Shift)
        keysDown



-- RESIZE TOOL BAR --


handleResize : Direction -> Model -> ( Model, Cmd Msg )
handleResize direction model =
    case direction of
        Down _ ->
            { model
                | subMouseMove =
                    Move
                        >> ResizeToolbar
                        >> MainMsg.PaletteMsg
                        |> Just
            }
                ! []

        Up _ ->
            { model
                | subMouseMove =
                    Nothing
            }
                ! []

        Move position ->
            let
                { width, height } =
                    model.windowSize
            in
            { model
                | horizontalToolbarHeight =
                    height - position.y + 29
            }
                ! []
