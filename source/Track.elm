module Track exposing (track)

import Data.Tracking as Tracking
import Json.Encode as JE
import Model exposing (Model)
import Msg exposing (Msg(..))
import Toolbar
import Util exposing (def)


{-|

    Much like the update function,
    however its meant to map the incoming
    Msgs to a tracking event.

-}
track : Msg -> Model -> Maybe Tracking.Event
track msg model =
    case msg of
        WindowSizeReceived { width, height } ->
            [ def "width" <| JE.int width
            , def "height" <| JE.int height
            ]
                |> def "window size received"
                |> Just

        -- ToolbarMsg subMsg ->
        -- Toolbar.track subMsg
        _ ->
            Nothing
