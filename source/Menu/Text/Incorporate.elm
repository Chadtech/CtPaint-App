module Menu.Text.Incorporate exposing (incorporate)

import Menu.Ports as Ports
import Menu.Text.Types as Text
    exposing
        ( ExternalMsg(..)
        , Msg(..)
        )
import Menu.Types exposing (Menu(..))
import Types exposing (Model)


incorporate : Model -> ( Text.Model, ExternalMsg ) -> ( Model, Cmd Msg )
incorporate model ( textModel, externalMsg ) =
    case externalMsg of
        DoNothing ->
            { model
                | menu = Text textModel
            }
                ! []

        AddText ->
            model ! []

        Close ->
            ( { model | menu = None }, Ports.returnFocus () )
