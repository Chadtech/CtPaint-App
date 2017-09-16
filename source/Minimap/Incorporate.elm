module Minimap.Incorporate exposing (..)

import Minimap.Types as Minimap exposing (ExternalMsg(..))
import Model exposing (Model)


incorporate : ( Minimap.Model, ExternalMsg ) -> Model -> Model
incorporate ( minimap, message ) model =
    case message of
        DoNothing ->
            { model
                | minimap = Just minimap
            }

        Close ->
            { model
                | minimap = Nothing
            }
