module Menu.Import.Incorporate exposing (incorporate)

import Canvas
import Menu exposing (Menu(..))
import Menu.Import.Types as Import exposing (ExternalMsg(..), Msg(..))
import Task
import Types exposing (Model)
import Util exposing ((&))


incorporate : Model -> ( Import.Model, ExternalMsg ) -> ( Model, Cmd Msg )
incorporate model ( importModel, externalmessage ) =
    case externalmessage of
        DoNothing ->
            { model
                | menu = Import importModel
            }
                & Cmd.none

        Close ->
            { model | menu = None } & Menu.returnFocus ()

        LoadImage ->
            let
                cmd =
                    [ "https://cors-anywhere.herokuapp.com/"
                    , importModel.url
                    ]
                        |> String.concat
                        |> Canvas.loadImage
                        |> Task.attempt ImageLoaded
            in
            { model
                | menu = Import importModel
            }
                & cmd

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
                & Menu.returnFocus ()
