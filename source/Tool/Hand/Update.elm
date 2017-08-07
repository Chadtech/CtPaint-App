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

                initialPosition =
                    case model.selection of
                        Just ( selectionPosition, _ ) ->
                            selectionPosition

                        Nothing ->
                            model.canvasPosition
            in
                { model
                    | tool =
                        (Hand << Just)
                            ( initialPosition
                            , Position position.x y
                            )
                }

        ( SubMouseMove movePosition, Just ( initialPosition, click ) ) ->
            case model.selection of
                Just ( _, selection ) ->
                    let
                        x =
                            List.sum
                                [ initialPosition.x
                                , (movePosition.x - click.x - tbw)
                                    // model.zoom
                                ]

                        y =
                            List.sum
                                [ initialPosition.y
                                , (movePosition.y - click.y)
                                    // model.zoom
                                ]
                    in
                        { model
                            | selection =
                                Just
                                    ( Position x y
                                    , selection
                                    )
                        }

                Nothing ->
                    let
                        x =
                            List.sum
                                [ initialPosition.x
                                , movePosition.x
                                , -click.x
                                , -tbw
                                ]

                        y =
                            List.sum
                                [ initialPosition.y
                                , movePosition.y
                                , -click.y
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
