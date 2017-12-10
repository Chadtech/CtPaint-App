module Tool.Select.Update exposing (update)

import Canvas
import Draw
import Helpers.History as History
import Model exposing (Model)
import Tool.Select exposing (Msg(..), SelectModel)
import Tool.Util exposing (adjustPosition)
import Tuple.Infix exposing ((&))
import Util exposing (positionMin)


update : Msg -> SelectModel -> Model -> ( Model, SelectModel )
update message selectModel model =
    case ( message, selectModel ) of
        ( ScreenMouseDown { clientPos }, Nothing ) ->
            let
                adjustedPosition =
                    adjustPosition model clientPos

                newModel =
                    { model
                        | drawAtRender =
                            Draw.rectangle
                                model.color.swatches.primary
                                adjustedPosition
                                adjustedPosition
                    }
                        |> handleExistingSelection
            in
            newModel & Just adjustedPosition

        ( SubMouseMove position, Just priorPosition ) ->
            { model
                | drawAtRender =
                    Draw.rectangle
                        model.color.swatches.second
                        priorPosition
                        (adjustPosition model position)
            }
                & selectModel

        ( SubMouseUp position, Just priorPosition ) ->
            let
                adjustedPosition =
                    adjustPosition model position
            in
            if adjustedPosition == priorPosition then
                { model | drawAtRender = Canvas.batch [] }
                    & Nothing
            else
                let
                    ( newSelection, drawOp ) =
                        Draw.getSelection
                            adjustedPosition
                            priorPosition
                            model.color.swatches.second
                            model.canvas
                in
                { model
                    | pendingDraw =
                        [ model.pendingDraw
                        , drawOp
                        ]
                            |> Canvas.batch
                    , selection =
                        adjustedPosition
                            |> positionMin priorPosition
                            & newSelection
                            |> Just
                }
                    & Nothing

        _ ->
            model & selectModel



-- HELPER --


handleExistingSelection : Model -> Model
handleExistingSelection model =
    case model.selection of
        Just ( position, selection ) ->
            { model
                | pendingDraw =
                    [ model.pendingDraw
                    , Draw.pasteSelection position selection
                    ]
                        |> Canvas.batch
                , selection = Nothing
            }
                |> History.canvas

        Nothing ->
            model
