module Tool.Hand.Update exposing (..)

import Mouse exposing (Position)
import Tool exposing (Tool(..))
import Tool.Hand.Types exposing (Msg(..))
import Types exposing (Model)


update : Msg -> Maybe ( Position, Position ) -> Model -> Model
update message tool model =
    case ( message, tool ) of
        ( ScreenMouseDown { clientPos }, Nothing ) ->
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
                    ( initialPosition
                    , clientPos
                    )
                        |> Just
                        |> Hand
            }

        ( SubMouseMove position, Just ( initialPosition, click ) ) ->
            case model.selection of
                Just ( _, selection ) ->
                    let
                        x =
                            List.sum
                                [ initialPosition.x
                                , (position.x - click.x)
                                    // model.zoom
                                ]

                        y =
                            List.sum
                                [ initialPosition.y
                                , (position.y - click.y)
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
                    { model
                        | canvasPosition =
                            { x =
                                List.sum
                                    [ initialPosition.x
                                    , position.x
                                    , -click.x
                                    ]
                            , y =
                                List.sum
                                    [ initialPosition.y
                                    , position.y
                                    , -click.y
                                    ]
                            }
                    }

        ( SubMouseUp, _ ) ->
            { model
                | tool = Hand Nothing
            }

        _ ->
            model
