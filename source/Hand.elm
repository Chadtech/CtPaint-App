module Hand
    exposing
        ( handleClientMouseMovement
        , handleScreenMouseDown
        )

import Data.Selection as Selection
import Data.Tool exposing (Tool(Hand))
import Model exposing (Model)
import Mouse exposing (Position)
import Tuple.Infix exposing ((&), (|&))


handleScreenMouseDown : Position -> Model -> Model
handleScreenMouseDown clientPos model =
    { model
        | tool =
            model
                |> getInitialPosition
                & clientPos
                |> Just
                |> Hand
    }


getInitialPosition : Model -> Position
getInitialPosition model =
    case model.selection of
        Just { position } ->
            position

        Nothing ->
            model.canvasPosition


handleClientMouseMovement : Position -> ( Position, Position ) -> Model -> Model
handleClientMouseMovement newPosition ( initialPosition, click ) model =
    case model.selection of
        Just selection ->
            { model
                | tool = Hand (Just ( initialPosition, click ))
                , selection =
                    Selection.setPosition
                        { x =
                            [ initialPosition.x
                            , (newPosition.x - click.x)
                                // model.zoom
                            ]
                                |> List.sum
                        , y =
                            [ initialPosition.y
                            , (newPosition.y - click.y)
                                // model.zoom
                            ]
                                |> List.sum
                        }
                        selection
                        |> Just
            }

        Nothing ->
            { model
                | tool = Hand (Just ( initialPosition, click ))
                , canvasPosition =
                    { x =
                        [ initialPosition.x
                        , newPosition.x
                        , -click.x
                        ]
                            |> List.sum
                    , y =
                        [ initialPosition.y
                        , newPosition.y
                        , -click.y
                        ]
                            |> List.sum
                    }
            }
