module Tool.Select.Update exposing (update)

import Tool.Select.Types exposing (..)
import Draw.Util exposing (makeRectParams)


update : Messsage -> Model -> ( Model, Maybe ExternalMessage )
update message model =
    case message of
        OnScreenMouseDown position ->
            let
                newModel =
                    { model
                        | click = position
                    }
            in
                ( newModel, Nothing )

        --SubMouseMove position ->
        --    let
        --        newModel =
        --            { model
        --                | selection = ( position)
        --            }
        --    in
        _ ->
            ( model, Nothing )
