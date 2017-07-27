module Tool.Hand.Update exposing (..)

import Main.Model exposing (Model)
import Tool.Hand.Types exposing (Message(..))
import Tool.Types exposing (Tool(..))
import Mouse exposing (Position)
import Util exposing (tbw)


update : Message -> Maybe ( Position, Position ) -> Model -> Model
update message tool model =
    case ( message, tool ) of
        ( OnScreenMouseDown position, Nothing ) ->
            let
                y =
                    position.y + 29
            in
                { model
                    | tool =
                        (Hand << Just)
                            ( model.canvasPosition
                            , Position position.x y
                            )
                }

        ( SubMouseMove position, Just ( canvasPosition, originalClick ) ) ->
            let
                x =
                    List.sum
                        [ canvasPosition.x
                        , position.x
                        , -originalClick.x
                        , -tbw
                        ]

                y =
                    List.sum
                        [ canvasPosition.y
                        , position.y
                        , -originalClick.y
                        ]
            in
                { model
                    | canvasPosition =
                        Position x y
                }

        ( SubMouseUp, _ ) ->
            { model
                | tool = Hand Nothing
            }

        _ ->
            model
