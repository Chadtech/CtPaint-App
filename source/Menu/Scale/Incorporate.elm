module Menu.Scale.Incorporate exposing (incorporate)

import Menu exposing (Menu(..))
import Menu.Scale.Types as Scale
    exposing
        ( ExternalMsg(..)
        , Msg(..)
        )
import Types exposing (Model)
import Util exposing ((&))


incorporate : Model -> ( Scale.Model, ExternalMsg ) -> ( Model, Cmd Msg )
incorporate model ( scaleModel, externalMsg ) =
    case externalMsg of
        DoNothing ->
            { model
                | menu = Scale scaleModel
            }
                & Cmd.none

        Finish ->
            model & Cmd.none

        Close ->
            { model | menu = None } & Menu.returnFocus ()
