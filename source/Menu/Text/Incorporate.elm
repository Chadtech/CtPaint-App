module Menu.Text.Incorporate exposing (incorporate)

import Main.Model exposing (Model)
import Menu.Ports as Ports
import Menu.Text.Types as Text
    exposing
        ( ExternalMessage(..)
        , Message(..)
        )
import Menu.Types exposing (Menu(..))


incorporate : Model -> ( Text.Model, ExternalMessage ) -> ( Model, Cmd Message )
incorporate model ( textModel, externalMessage ) =
    case externalMessage of
        DoNothing ->
            { model
                | menu = Text textModel
            }
                ! []

        AddText ->
            model ! []

        Close ->
            ( { model | menu = None }, Ports.returnFocus () )
