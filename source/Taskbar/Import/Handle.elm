module Taskbar.Import.Handle exposing (handle)

import Canvas
import Main.Model exposing (Model)
import Task
import Taskbar.Import.Types as Import exposing (ExternalMessage(..), Message(..))
import Types.Menu exposing (Menu(..))


handle : Model -> ( Import.Model, ExternalMessage ) -> ( Model, Cmd Message )
handle model ( downloadModel, externalmessage ) =
    case externalmessage of
        DoNothing ->
            { model
                | menu = Import downloadModel
            }
                ! []

        Close ->
            { model | menu = None } ! []

        LoadImage ->
            { model
                | menu = Import downloadModel
            }
                ! [ loadCmd downloadModel.url ]

        IncorporateImage image ->
            let
                size =
                    Canvas.getSize image

                canvas =
                    Canvas.getSize model.canvas

                imagePosition =
                    { x =
                        (canvas.width - size.width) // 2
                    , y =
                        (canvas.height - size.height) // 2
                    }
            in
            { model
                | selection = Just ( imagePosition, image )
                , menu = None
            }
                ! []


loadCmd : String -> Cmd Message
loadCmd url =
    Task.attempt
        ImageLoaded
        (Canvas.loadImage url)
