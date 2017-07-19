module ColorPicker.Update exposing (update)

import ColorPicker.Types exposing (..)
import Mouse exposing (Position)
import Palette.Types as Palette


update : Message -> Model -> ( Model, Maybe ExternalMessage )
update message model =
    case message of
        HeaderMouseDown { targetPos, clientPos } ->
            let
                newModel =
                    { model
                        | clickState =
                            Position
                                (clientPos.x - targetPos.x)
                                (clientPos.y - targetPos.y)
                                |> Just
                    }
            in
                ( newModel, Nothing )

        HeaderMouseMove position ->
            case model.clickState of
                Nothing ->
                    ( model, Nothing )

                Just originalClick ->
                    let
                        x =
                            position.x - originalClick.x

                        y =
                            position.y - originalClick.y

                        newModel =
                            { model
                                | position =
                                    Position x y
                            }
                    in
                        ( newModel, Nothing )

        HeaderMouseUp _ ->
            let
                newModel =
                    { model
                        | clickState = Nothing
                    }
            in
                ( newModel, Nothing )

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

        SetColorFormat format ->
            let
                newModel =
                    { model
                        | colorFormat = format
                    }
            in
                ( newModel, Nothing )

        SetColorScale scale ->
            let
                newModel =
                    { model
                        | colorScale = scale
                    }
            in
                ( newModel, Nothing )

        HandleFocus focused ->
            ( model, Just (SetFocus focused) )

        UpdateColorHexField hex ->
            let
                newModel =
                    { model
                        | colorHexField = String.toUpper hex
                    }
            in
                setColorMaybe newModel

        StealSubmit ->
            ( model, Nothing )


setColorMaybe : Model -> ( Model, Maybe ExternalMessage )
setColorMaybe model =
    case Palette.toColor model.colorHexField of
        Just color ->
            let
                newModel =
                    { model
                        | color = color
                    }
            in
                ( newModel, Just (SetColor model.index color) )

        Nothing ->
            ( model, Nothing )
