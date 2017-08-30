module Minimap.Update exposing (update)

import Minimap.Types exposing (Model, Message(..), ExternalMessage(..))


update : Message -> Model -> ( Model, Maybe ExternalMessage )
update message model =
    ( model, Nothing )
