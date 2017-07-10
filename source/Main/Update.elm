module Main.Update exposing (update)

import Main.Message exposing (Message(..))
import Main.Model exposing (Model)
import Toolbar.Horizontal.Update as HorizontalToolbar
import Tool.Hand.Update as Hand
import Tool.Pencil.Update as Pencil
import Tool.Types exposing (Tool(..))
import Canvas exposing (Size, DrawOp(..))


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
