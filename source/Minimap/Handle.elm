module Minimap.Handle exposing (..)

import Main.Model exposing (Model)
import Minimap.Types as Minimap exposing (ExternalMessage(..))


handle : ( Minimap.Model, ExternalMessage ) -> Model -> Model
handle ( minimap, message ) model =
    case message of
        DoNothing ->
            { model
                | minimap = Just minimap
            }

        Close ->
            { model
                | minimap = Nothing
            }
