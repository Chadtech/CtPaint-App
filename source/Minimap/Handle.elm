module Minimap.Handle exposing (..)

import Main.Model exposing (Model)
import Minimap.Types as Minimap exposing (ExternalMessage(..))


handle : ( Minimap.Model, Maybe ExternalMessage ) -> Model -> Model
handle ( minimap, maybeMessage ) model =
    case maybeMessage of
        Nothing ->
            { model
                | minimap = Just minimap
            }

        Just Closed ->
            { model
                | minimap = Nothing
            }
