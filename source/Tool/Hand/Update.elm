module Tool.Hand.Update exposing (..)

import Main.Model exposing (Model)
import Tool.Hand.Types exposing (Message(..))
import Tool.Types exposing (Tool(..))
import ElementRelativeMouseEvents exposing (Point)
import Mouse exposing (Position)
import Util exposing (toPoint)


update : Message -> Maybe ( Point, Point ) -> Model -> ( Model, Cmd Message )
update message tool model =
    case ( message, tool ) of
        ( OnScreenMouseDown point, Nothing ) ->
            let
                canvasPosition =
                    toPoint model.canvasPosition
            in
                { model
                    | tool = Hand (Just ( canvasPosition, point ))
                }
                    ! []

        ( OnScreenMouseMove position, Just ( canvasPoint, originalClick ) ) ->
            let
                x =
                    List.sum
                        [ canvasPoint.x
                        , toFloat position.x
                        , -originalClick.x
                        ]

                y =
                    List.sum
                        [ canvasPoint.y
                        , toFloat position.y
                        , -originalClick.y
                        ]
            in
                { model
                    | canvasPosition =
                        Position
                            (floor x)
                            (floor y)
                }
                    ! []

        ( OnScreenMouseUp, _ ) ->
            { model
                | tool = Hand Nothing
            }
                ! []

        _ ->
            model ! []
