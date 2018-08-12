module Tool.Zoom.Helpers
    exposing
        ( in_
        , moveTowardsClickPosition
        , out
        )

import Canvas.Model as Canvas
import Position.Data as Position exposing (Position)
import Model exposing (Model)
import Position.Helpers
import Tool.Zoom as Zoom exposing (zoom)
import Tool.Zoom.Data.Direction as Direction
    exposing
        ( Direction
        )


in_ : Model -> Model
in_ model =
    let
        newZoom =
            Zoom.nextLevelIn model.zoom

        newCanvasPosition =
            zoom
                model.zoom
                newZoom
                (Position.Helpers.centerOfWorkarea model)
                model.canvas.position
    in
    { model
        | zoom = newZoom
        , canvas =
            Canvas.setPosition
                newCanvasPosition
                model.canvas
    }


out : Model -> Model
out model =
    let
        newZoom =
            Zoom.nextLevelOut model.zoom

        newCanvasPosition =
            zoom
                model.zoom
                newZoom
                (Position.Helpers.centerOfWorkarea model)
                model.canvas.position
    in
    { model
        | zoom = newZoom
        , canvas =
            Canvas.setPosition
                newCanvasPosition
                model.canvas
    }


moveTowardsClickPosition : Position -> Direction -> Model -> Model
moveTowardsClickPosition clickInWindowPosition direction model =
    { model
        | canvas =
            model
                |> Position.Helpers.centerOfWorkarea
                |> Position.subtractFrom clickInWindowPosition
                ----^ the position relative to the
                --    center of the work area
                |> Position.divideBy model.zoom
                |> Position.multiplyBy (Direction.toInt direction)
                ----^ the distance multiplied by
                --    the the zoom and whether
                --    the zoom is in or out
                |> Position.add model.canvas.position
                ----^ the canvas position moved by
                --    the previously calculated
                --    position
                |> Canvas.setPosition
                |> Canvas.applyTo model.canvas
    }
