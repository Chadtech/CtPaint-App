module Toolbar.Horizontal.Update exposing (update)

import Toolbar.Horizontal.Types exposing (Message(..))
import Types.Mouse exposing (Direction(..))
import Main.Model exposing (Model)
import Main.Message as MainMessage


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        ResizeToolbar direction ->
            handleResize direction model

        SetPrimarySwatch color ->
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



-- RESIZE TOOL BAR --


handleResize : Direction -> Model -> ( Model, Cmd Message )
handleResize direction model =
    case direction of
        Down _ ->
            { model
                | subMouseMove =
                    Move
                        >> ResizeToolbar
                        >> MainMessage.HorizontalToolbarMessage
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
                        height - position.y
                }
                    ! []
