module Toolbar.Horizontal.Update exposing (update)

import Toolbar.Horizontal.Types exposing (Message(..), MouseDirection(..))
import Main.Model exposing (Model)
import Main.Message as MainMessage


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        ResizeToolbar direction ->
            handleResize direction model



-- RESIZE TOOL BAR --


handleResize : MouseDirection -> Model -> ( Model, Cmd Message )
handleResize direction model =
    case direction of
        Down _ ->
            { model
                | subMouseMove =
                    Move
                        >> ResizeToolbar
                        >> MainMessage.HorizontalToolbarMessage
                        |> Just
                    --, subMouseUp =
                    --    Up
                    --        >> ResizeToolbar
                    --        >> MainMessage.HorizontalToolbarMessage
                    --        |> Just
            }
                ! []

        Up _ ->
            { model
                | subMouseMove =
                    Nothing
                    --, subMouseUp = Nothing
            }
                ! []

        Move position ->
            { model
                | horizontalToolbarHeight =
                    model.windowHeight - position.y
            }
                ! []
