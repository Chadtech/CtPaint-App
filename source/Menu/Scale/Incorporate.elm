module Menu.Scale.Incorporate exposing (incorporate)

import Menu.Ports as Ports
import Menu.Scale.Types as Scale
    exposing
        ( ExternalMsg(..)
        , Msg(..)
        )
import Menu.Types exposing (Menu(..))
import Model exposing (Model)


incorporate : Model -> ( Scale.Model, ExternalMsg ) -> ( Model, Cmd Msg )
incorporate model ( scaleModel, externalMsg ) =
    case externalMsg of
        DoNothing ->
            { model
                | menu = Scale scaleModel
            }
                ! []

        Finish ->
            model ! []

        Close ->
            ( { model | menu = None }, Ports.returnFocus () )
