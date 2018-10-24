module Menu.Track exposing (track)

import Data.Tracking as Tracking
import Menu.Model exposing (Model)
import Menu.Msg exposing (Msg(..))


track : Msg -> Model -> Tracking.Event
track msg model =
    Tracking.none
