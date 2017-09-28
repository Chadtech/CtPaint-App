module Minimap exposing (..)

import Canvas exposing (Canvas)
import Html exposing (Html, a, div, p, text)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import Tool exposing (Tool(..))
import Util exposing (height, left, top, width)
import Window exposing (Size)


-- TYPES --


type alias Model =
    { externalPosition : Position
    , internalPosition : Position
    , size : Size
    , zoom : Int
    , clickState : Maybe Position
    }


type ExternalMsg
    = Close
    | DoNothing


type Msg
    = HeaderMouseDown MouseEvent
    | HeaderMouseMove Position
    | HeaderMouseUp
    | CloseClick



-- INIT --


init : Size -> Model
init { width, height } =
    let
        minimapSize =
            { width = 250 + extraWidth
            , height = 250 + extraHeight
            }
    in
    { externalPosition =
        { x = (width - minimapSize.width) // 2
        , y = (height - minimapSize.height) // 2
        }
    , internalPosition =
        { x = 0
        , y = 0
        }
    , size = minimapSize
    , zoom = 1
    , clickState = Nothing
    }


extraHeight : Int
extraHeight =
    64


extraWidth : Int
extraWidth =
    8



-- SUBSCRIPTIONS --


subscriptions : Maybe Model -> Sub Msg
subscriptions maybeModel =
    case maybeModel of
        Nothing ->
            Sub.none

        Just _ ->
            Sub.batch
                [ Mouse.moves HeaderMouseMove
                , Mouse.ups (always HeaderMouseUp)
                ]



-- UPDATE --


update : Msg -> Model -> ( Model, ExternalMsg )
update message model =
    case message of
        HeaderMouseDown { targetPos, clientPos } ->
            let
                newModel =
                    { model
                        | clickState =
                            Position
                                (clientPos.x - targetPos.x)
                                (clientPos.y - targetPos.y)
                                |> Just
                    }
            in
            ( newModel, DoNothing )

        HeaderMouseMove position ->
            case model.clickState of
                Nothing ->
                    ( model, DoNothing )

                Just originalClick ->
                    let
                        x =
                            position.x - originalClick.x

                        y =
                            position.y - originalClick.y

                        newModel =
                            { model
                                | externalPosition =
                                    Position x y
                            }
                    in
                    ( newModel, DoNothing )

        HeaderMouseUp ->
            let
                newModel =
                    { model
                        | clickState = Nothing
                    }
            in
            ( newModel, DoNothing )

        CloseClick ->
            ( model, Close )



-- VIEW --


view : Model -> Canvas -> Html Msg
view model canvas =
    div
        [ class "card mini-map"
        , style
            [ top model.externalPosition.y
            , left model.externalPosition.x
            , height model.size.height
            , width model.size.width
            ]
        ]
        [ header model
        , div
            [ class "canvas-container"
            , style
                [ height (model.size.height - extraHeight)
                , width (model.size.width - extraWidth)
                ]
            ]
            [ Canvas.toHtml [] canvas ]
        , a
            [ class "tool-button" ]
            [ text (Tool.icon ZoomIn) ]
        , a
            [ class "tool-button" ]
            [ text (Tool.icon ZoomOut) ]
        ]


header : Model -> Html Msg
header model =
    div
        [ class "header"
        , style [ width (model.size.width - extraWidth) ]
        , MouseEvents.onMouseDown HeaderMouseDown
        ]
        [ p [] [ text "mini map" ]
        , a [ onClick CloseClick ] [ text "x" ]
        ]
