module Tool.Hand.Update exposing (update)

import Model exposing (Model)
import Mouse exposing (Position)
import Tool.Hand exposing (HandModel, Msg(..))
import Tuple.Infix exposing ((&))


update : Msg -> HandModel -> Model -> ( Model, HandModel )
update message toolModel model =
    case ( message, toolModel ) of
        ( ScreenMouseDown { clientPos }, Nothing ) ->
            let
                initialPosition =
                    case model.selection of
                        Just ( selectionPosition, _ ) ->
                            selectionPosition

                        Nothing ->
                            model.canvasPosition

                newToolModel =
                    ( initialPosition
                    , clientPos
                    )
                        |> Just
            in
            model & newToolModel

        ( SubMouseMove position, Just ( initialPosition, click ) ) ->
            case model.selection of
                Just ( _, selection ) ->
                    let
                        x =
                            [ initialPosition.x
                            , (position.x - click.x)
                                // model.zoom
                            ]
                                |> List.sum

                        y =
                            [ initialPosition.y
                            , (position.y - click.y)
                                // model.zoom
                            ]
                                |> List.sum
                    in
                    { model
                        | selection =
                            ( Position x y
                            , selection
                            )
                                |> Just
                    }
                        & toolModel

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
                        & toolModel

        ( SubMouseUp, _ ) ->
            model & Nothing

        _ ->
            model & toolModel
