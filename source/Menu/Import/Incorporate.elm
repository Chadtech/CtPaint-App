module Menu.Import.Incorporate exposing (incorporate)

import Canvas
import Main.Model exposing (Model)
import Menu.Import.Types as Import exposing (ExternalMessage(..), Message(..))
import Menu.Ports as Ports
import Menu.Types exposing (Menu(..))
import Task


incorporate : Model -> ( Import.Model, ExternalMessage ) -> ( Model, Cmd Message )
incorporate model ( importModel, externalmessage ) =
    case externalmessage of
        DoNothing ->
            { model
                | menu = Import importModel
            }
                ! []

        Close ->
            { model | menu = None } ! [ Ports.returnFocus () ]

        LoadImage ->
            { model
                | menu = Import importModel
            }
                ! [ loadCmd importModel.url ]

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
                ! [ Ports.returnFocus () ]


loadCmd : String -> Cmd Message
loadCmd url =
    Task.attempt
        ImageLoaded
        (Canvas.loadImage url)
