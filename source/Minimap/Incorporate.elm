module Minimap.Incorporate exposing (..)

import Main.Model exposing (Model)
import Minimap.Types as Minimap exposing (ExternalMessage(..))


incorporate : ( Minimap.Model, ExternalMessage ) -> Model -> Model
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
