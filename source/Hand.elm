module Hand
    exposing
        ( handleClientMouseMovement
        , handleScreenMouseDown
        )

import Data.Tool exposing (Tool(Hand))
import Model exposing (Model)
import Mouse exposing (Position)
import Tuple.Infix exposing ((&), (|&))


handleScreenMouseDown : Position -> Model -> Model
handleScreenMouseDown clientPos model =
    let
        initialPosition =
            case model.selection of
                Just ( selectionPosition, _ ) ->
                    selectionPosition

                Nothing ->
                    model.canvasPosition
    in
    { model
        | tool =
            initialPosition
                & clientPos
                |> Just
                |> Hand
    }


handleClientMouseMovement : Position -> ( Position, Position ) -> Model -> Model
handleClientMouseMovement newPosition ( initialPosition, click ) model =
    case model.selection of
        Just ( _, selection ) ->
            { model
                | tool = Hand (Just ( initialPosition, click ))
                , selection =
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
                        & selection
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
