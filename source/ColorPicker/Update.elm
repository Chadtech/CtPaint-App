module ColorPicker.Update exposing (update)

import ColorPicker.Types exposing (..)
import Debug exposing (log)


update : Message -> Model -> ( Model, Maybe ExternalMessage )
update message model =
    case log "MESSAGE" message of
        HeaderMouseDown position ->
            ( model, Nothing )

        WakeUp color index ->
            let
                newModel =
                    { model
                        | color = color
                        , index = index
                        , show = True
                    }
            in
                ( newModel, Nothing )

        Close ->
            let
                newModel =
                    { model
                        | show = False
                    }
            in
                ( newModel, Nothing )
