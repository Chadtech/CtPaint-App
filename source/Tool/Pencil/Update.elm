module Tool.Pencil.Update exposing (..)

import Canvas exposing (DrawOp(..))
import Data.Tool exposing (Tool(Pencil))
import Draw
import History
import Mouse exposing (Position)
import Tool.Pencil exposing (Msg(..))
import Tool.Util exposing (adjustPosition)
import Types exposing (Model)
import Util exposing (tbw)


update : Msg -> Maybe Position -> Model -> Model
update message tool model =
    case ( message, tool ) of
        ( ScreenMouseDown { clientPos }, Nothing ) ->
            let
                adjustedPosition =
                    adjustPosition model tbw clientPos
            in
            { model
                | tool = Pencil (Just adjustedPosition)
                , pendingDraw =
                    Canvas.batch
                        [ model.pendingDraw
                        , Draw.line
                            model.swatches.primary
                            adjustedPosition
                            adjustedPosition
                        ]
            }
                |> History.addCanvas

        ( SubMouseMove position, Just priorPosition ) ->
            let
                adjustedPosition =
                    adjustPosition model tbw position
            in
            { model
                | tool = Pencil (Just adjustedPosition)
                , pendingDraw =
                    Canvas.batch
                        [ model.pendingDraw
                        , Draw.line
                            model.swatches.primary
                            priorPosition
                            adjustedPosition
                        ]
            }

        ( SubMouseUp, _ ) ->
            { model
                | tool = Pencil Nothing
            }

        _ ->
            model
