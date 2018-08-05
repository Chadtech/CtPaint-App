module Helpers.Drawing exposing (save)

import Menu.Model as Menu
import Model exposing (Model)
import Ports exposing (JsMsg(Save))
import Return2 as R2


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
                |> R2.withCmd
                    (Ports.send (Ports.Save savePayload))

        Nothing ->
            model
                |> R2.withNoCmd
