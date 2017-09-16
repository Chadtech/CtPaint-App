module Tool.Select.Update exposing (update)

import Canvas exposing (Point, Size)
import Draw.Rectangle as Rectangle
import Draw.Select as Select
import History.Update as History
import Tool.Select exposing (Msg(..), SelectModel)
import Tool.Util exposing (adjustPosition)
import Types exposing (Model)
import Util exposing ((&), positionMin, tbw)


update : Msg -> SelectModel -> Model -> ( Model, SelectModel )
update message selectModel model =
    case ( message, selectModel ) of
        ( ScreenMouseDown { clientPos }, Nothing ) ->
            let
                adjustedPosition =
                    adjustPosition model 0 clientPos

                newModel =
                    { model
                        | drawAtRender =
                            Rectangle.draw
                                model.swatches.primary
                                adjustedPosition
                                adjustedPosition
                    }
                        |> handleExistingSelection
            in
            newModel & Just adjustedPosition

        ( SubMouseMove position, Just priorPosition ) ->
            { model
                | drawAtRender =
                    Rectangle.draw
                        model.swatches.second
                        priorPosition
                        (adjustPosition model tbw position)
            }
                & selectModel

        ( SubMouseUp position, Just priorPosition ) ->
            let
                adjustedPosition =
                    adjustPosition model tbw position
            in
            if adjustedPosition == priorPosition then
                { model | drawAtRender = Canvas.batch [] }
                    & Nothing
            else
                let
                    ( newSelection, drawOp ) =
                        Select.get
                            adjustedPosition
                            priorPosition
                            model.swatches.second
                            model.canvas
                in
                { model
                    | pendingDraw =
                        Canvas.batch
                            [ model.pendingDraw
                            , drawOp
                            ]
                    , selection =
                        ( positionMin
                            priorPosition
                            adjustedPosition
                        , newSelection
                        )
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
                    , Select.paste position selection
                    ]
                        |> Canvas.batch
                , selection = Nothing
            }
                |> History.addCanvas

        Nothing ->
            model
