module Menu.Scale.Update exposing (update)

import Menu.Scale.Types
    exposing
        ( ExternalMessage(..)
        , Field(..)
        , Message(..)
        , Model
        )
import Mouse exposing (Position)
import Util exposing (pack)


update : Message -> Model -> ( Model, ExternalMessage )
update message model =
    case message of
        UpdateField field string ->
            pack model DoNothing

        OkayClick ->
            pack model Finish

        CloseClick ->
            pack model Close

        HeaderMouseDown { targetPos, clientPos } ->
            pack
                { model
                    | clickState =
                        { x = clientPos.x - targetPos.x
                        , y = clientPos.y - targetPos.y
                        }
                            |> Just
                }
                DoNothing

        HeaderMouseMove position ->
            case model.clickState of
                Nothing ->
                    pack model DoNothing

                Just originalClick ->
                    pack
                        { model
                            | position =
                                Position
                                    (position.x - originalClick.x)
                                    (position.y - originalClick.y)
                        }
                        DoNothing

        HeaderMouseUp ->
            pack
                { model
                    | clickState = Nothing
                }
                DoNothing


updateField : Field -> String -> Model -> ( Model, ExternalMessage )
updateField field str model =
    case field of
        FixedWidth ->
            case String.toInt str of
                Ok fixedWidth ->
                    handleFixedWidth fixedWidth model

                Err err ->
                    pack model DoNothing

        FixedHeight ->
            case String.toInt str of
                Ok fixedHeight ->
                    handleFixedHeight fixedHeight model

                Err err ->
                    pack model DoNothing

        PercentWidth ->
            case String.toFloat str of
                Ok percentWidth ->
                    handlePercentWidth percentWidth model

                Err err ->
                    pack model DoNothing

        PercentHeight ->
            case String.toFloat str of
                Ok percentHeight ->
                    handlePercentHeight percentHeight model

                Err err ->
                    pack model DoNothing


handleFixedWidth : Int -> Model -> ( Model, ExternalMessage )
handleFixedWidth fixedWidth model =
    pack
        { model
            | fixedWidth = fixedWidth
            , percentWidth =
                let
                    fixedWidth_ =
                        toFloat fixedWidth

                    initialWidth =
                        toFloat model.initialSize.width
                in
                fixedWidth_ / initialWidth
        }
        DoNothing


handleFixedHeight : Int -> Model -> ( Model, ExternalMessage )
handleFixedHeight fixedHeight model =
    pack
        { model
            | fixedHeight = fixedHeight
            , percentHeight =
                let
                    fixedHeight_ =
                        toFloat fixedHeight

                    initialHeight =
                        toFloat model.initialSize.height
                in
                fixedHeight_ / initialHeight
        }
        DoNothing


handlePercentWidth : Float -> Model -> ( Model, ExternalMessage )
handlePercentWidth percentWidth model =
    pack
        { model
            | percentWidth = percentWidth
            , fixedWidth =
                let
                    initialWidth =
                        toFloat model.initialSize.width
                in
                round (initialWidth * (percentWidth / 100))
        }
        DoNothing


handlePercentHeight : Float -> Model -> ( Model, ExternalMessage )
handlePercentHeight percentHeight model =
    pack
        { model
            | percentHeight = percentHeight
            , fixedHeight =
                let
                    initialHeight =
                        toFloat model.initialSize.height
                in
                round (initialHeight * (percentHeight / 100))
        }
        DoNothing
