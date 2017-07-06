module Tool.Pencil.Update exposing (..)

import Tool.Pencil.Types exposing (Message(..))
import Tool.Types exposing (Tool(..))
import Main.Model exposing (Model)
import Mouse exposing (Position)
import Draw.Line as Line
import Canvas


update : Message -> Maybe Position -> Model -> Model
update message tool model =
    case ( message, tool ) of
        ( OnScreenMouseDown position, Nothing ) ->
            { model
                | tool = Pencil (Just position)
            }

        ( SubMouseMove position, Just priorPosition ) ->
            { model
                | tool = Pencil (Just position)
                , pendingDraw =
                    Canvas.batch
                        [ model.pendingDraw
                        , Line.draw priorPosition position
                        ]
            }

        ( SubMouseUp, _ ) ->
            { model
                | tool = Pencil Nothing
            }

        _ ->
            model
