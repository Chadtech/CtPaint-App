module Palette.Update exposing (update)

import Color exposing (Color)
import Keyboard.Extra exposing (Key(..))
import List.Unique
import Palette.Types exposing (Msg(..))
import Types exposing (Model)
import Util exposing ((&))


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        --handleResize direction model
        WakeUpColorPicker color index ->
            wakeUp index color model & Cmd.none

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



-- RESIZE TOOL BAR --
--handleResize : Direction -> Model -> ( Model, Cmd Msg )
--handleResize direction model =
--    case direction of
--        Down _ ->
--            { model
--                | subMouseMove =
--                    Move
--                        >> ResizeToolbar
--                        >> MainMsg.PaletteMsg
--                        |> Just
--            }
--                ! []
--        Up _ ->
--            { model
--                | subMouseMove =
--                    Nothing
--            }
--                ! []
--        Move position ->
--            let
--                { width, height } =
--                    model.windowSize
--            in
--            { model
--                | horizontalToolbarHeight =
--                    height - position.y + 29
--            }
--                ! []
