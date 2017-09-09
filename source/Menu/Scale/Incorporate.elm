module Menu.Scale.Incorporate exposing (incorporate)

import Main.Model exposing (Model)
import Menu.Scale.Types as Scale exposing (ExternalMessage(..), Message(..))
import Menu.Types exposing (Menu(..))


incorporate : Model -> ( Scale.Model, ExternalMessage ) -> ( Model, Cmd Message )
incorporate model ( scaleModel, externalMessage ) =
    case externalMessage of
        DoNothing ->
            { model
                | menu = Scale scaleModel
            }
                ! []

        Close ->
            { model | menu = None } ! []
