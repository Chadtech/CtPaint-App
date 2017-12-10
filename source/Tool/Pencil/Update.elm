module Tool.Pencil.Update exposing (..)

import Canvas exposing (DrawOp(..))
import Data.Tool exposing (Tool(Pencil))
import Draw
import Helpers.History as History
import Model exposing (Model)
import Mouse exposing (Position)
import Tool.Pencil exposing (Msg(..))
import Tool.Util exposing (adjustPosition)


update : Msg -> Maybe Position -> Model -> Model
update message tool model =
    case ( message, tool ) of
        ( ScreenMouseDown { clientPos }, Nothing ) ->
            let
                position =
                    adjustPosition model clientPos
            in
            { model
                | tool = Pencil (Just position)
                , pendingDraw =
                    [ model.pendingDraw
                    , Draw.line
                        model.color.swatches.primary
                        position
                        position
                    ]
                        |> Canvas.batch
            }
                |> History.canvas

        ( SubMouseMove position, Just priorPosition ) ->
            let
                adjustedPosition =
                    adjustPosition model position
            in
            { model
                | tool = Pencil (Just adjustedPosition)
                , pendingDraw =
                    Canvas.batch
                        [ model.pendingDraw
                        , Draw.line
                            model.color.swatches.primary
                            priorPosition
                            adjustedPosition
                        ]
            }

        ( SubMouseUp, _ ) ->
            { model | tool = Pencil Nothing }

        _ ->
            model
