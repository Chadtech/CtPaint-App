module Helpers.Drawing exposing (save)

import Menu
import Model exposing (Model)
import Ports exposing (JsMsg(Save))
import Tuple.Infix exposing ((&))


save : Model -> ( Model, Cmd msg )
save model =
    case Model.toSavePayload model of
        Just savePayload ->
            { model
                | menu =
                    Menu.initSave
                        savePayload.name
                        model.windowSize
                        |> Just
            }
                & Ports.send
                    (Ports.Save savePayload)

        Nothing ->
            model & Cmd.none
