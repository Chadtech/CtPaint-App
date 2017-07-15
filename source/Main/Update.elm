module Main.Update exposing (update)

import Main.Message exposing (Message(..))
import Main.Model exposing (Model)
import Toolbar.Horizontal.Update as HorizontalToolbar
import Tool.Hand.Update as Hand
import Tool.Pencil.Update as Pencil
import Tool.ZoomIn.Update as ZoomIn
import Tool.ZoomOut.Update as ZoomOut
import Tool.Types exposing (Tool(..))
import Canvas exposing (Size, DrawOp(..))
import Keyboard.Update as Keyboard


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case ( message, model.tool ) of
        ( HorizontalToolbarMessage subMessage, _ ) ->
            let
                ( newModel, cmd ) =
                    HorizontalToolbar.update subMessage model
            in
                ( newModel, Cmd.map HorizontalToolbarMessage cmd )

        ( GetWindowSize size, _ ) ->
            { model
                | windowSize = size
            }
                ! []

        ( SetTool tool, _ ) ->
            { model
                | tool = tool
            }
                ! []

        ( KeyboardMessage subMessage, _ ) ->
            let
                newModel =
                    Keyboard.update subMessage model
            in
                newModel ! []

        ( HandMessage subMessage, Hand subModel ) ->
            let
                newModel =
                    Hand.update subMessage subModel model
            in
                newModel ! []

        ( PencilMessage subMessage, Pencil subModel ) ->
            let
                newModel =
                    Pencil.update subMessage subModel model
            in
                newModel ! []

        ( ZoomInMessage subMessage, ZoomIn ) ->
            let
                newModel =
                    ZoomIn.update subMessage model
            in
                newModel ! []

        ( ZoomOutMessage subMessage, ZoomOut ) ->
            let
                newModel =
                    ZoomOut.update subMessage model
            in
                newModel ! []

        ( Tick dt, _ ) ->
            case model.pendingDraw of
                Batch [] ->
                    model ! []

                _ ->
                    { model
                        | canvas =
                            Canvas.draw
                                model.pendingDraw
                                model.canvas
                        , pendingDraw =
                            Canvas.batch []
                    }
                        ! []

        _ ->
            model ! []
