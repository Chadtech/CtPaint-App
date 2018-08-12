module Position.Helpers
    exposing
        ( canvasPosInCenterOfWindow
        , centerInWorkarea
        , centerOfWorkarea
        , onCanvas
        )

import Position.Data as Position
    exposing
        ( Position
        )
import Data.Size as Size exposing (Size)
import Model exposing (Model)
import Style


{-| Given the canvas position and the position
you clicked in the window, adjust the
click position to be relative to the canvas
-}
onCanvas : Model -> Position -> Position
onCanvas { canvas, zoom } position =
    position
        |> Position.subtract canvas.position
        |> Position.subtract Style.workareaOrigin
        |> Position.divideBy zoom


{-| In many cases, we need to put a new canvas right
in the center of the work area (new canvases, imported
images, text). This function calculates where to position
the new canvas in the work area, such that its right
in the center.
-}
centerInWorkarea : Size -> Size -> Position
centerInWorkarea windowSize canvasSize =
    windowSize
        |> Size.subtractFromWidth Style.toolbarWidth
        |> Size.subtractFromWidth canvasSize.width
        |> Size.subtractFromHeight Style.taskbarHeight
        |> Size.subtractFromHeight canvasSize.height
        |> Size.divideBy 2
        |> Size.toPosition


centerOfWorkarea : Model -> Position
centerOfWorkarea model =
    model.windowSize
        |> Size.subtractFromWidth Style.toolbarWidth
        |> Size.subtractFromHeight Style.taskbarHeight
        |> Size.center


{-| There is the whole window. But in that window is a
work area. And in that workarea is a canvas. The canvas
has some position, and some zoom level. There is a position
on the canvas that is appearing in the middle of the window.

This function returns that position.

So for example, if the upper left corner of the canvas
was right in the middle of the window, this function should
return { x = 0, x = 0 }

-}
canvasPosInCenterOfWindow : Model -> Position
canvasPosInCenterOfWindow model =
    model.windowSize
        |> Size.center
        |> Position.subtract model.canvas.position
        |> Position.divideBy model.zoom
