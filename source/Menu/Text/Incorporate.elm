module Menu.Text.Incorporate exposing (incorporate)

import Menu exposing (Menu(..))
import Menu.Text.Types as Text
    exposing
        ( ExternalMsg(..)
        , Msg(..)
        )
import Types exposing (Model)
import Util exposing ((&))


incorporate : Model -> ( Text.Model, ExternalMsg ) -> ( Model, Cmd Msg )
incorporate model ( textModel, externalMsg ) =
    case externalMsg of
        DoNothing ->
            { model
                | menu = Text textModel
            }
                & Cmd.none

        AddText ->
            model & Cmd.none

        Close ->
            { model | menu = None } & Menu.returnFocus ()
