module Minimap exposing (..)

import Canvas exposing (Canvas)
import Html exposing (Html, a, div, p, text)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import Tool exposing (Tool(..))
import Util exposing ((&), height, left, top, width)
import Window exposing (Size)


-- TYPES --


type alias Model =
    { externalPosition : Position
    , internalPosition : Position
    , size : Size
    , zoom : Int
    , clickState : ClickState
    }


type ClickState
    = ClickedInHeaderAt Position
    | ClickedInScreenAt Position
    | NoClicks


type ExternalMsg
    = Close
    | DoNothing


type Msg
    = CloseClick
    | MouseDidSomething MouseHappening


type MouseHappening
    = HeaderMouseDown MouseEvent
    | ScreenMouseDown MouseEvent
    | MouseMoved Position
    | MouseUp



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
    , clickState = NoClicks
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

        Just model ->
            toSubscriptions model


toSubscriptions : Model -> Sub Msg
toSubscriptions model =
    case model.clickState of
        NoClicks ->
            Sub.none

        anythingElse ->
            Sub.batch
                [ Mouse.moves
                    (MouseDidSomething << MouseMoved)
                , Mouse.ups
                    (always (MouseDidSomething MouseUp))
                ]



-- UPDATE --


update : Msg -> Model -> ( Model, ExternalMsg )
update message model =
    case Debug.log "msg" message of
        CloseClick ->
            model & Close

        MouseDidSomething mouseHappening ->
            handleMouse mouseHappening model


handleMouse : MouseHappening -> Model -> ( Model, ExternalMsg )
handleMouse event model =
    case event of
        ScreenMouseDown { targetPos, clientPos } ->
            { model
                | clickState =
                    let
                        { x, y } =
                            model.internalPosition
                    in
                    { x = clientPos.x - x
                    , y = clientPos.y - y
                    }
                        |> ClickedInScreenAt
            }
                & DoNothing

        HeaderMouseDown { targetPos, clientPos } ->
            { model
                | clickState =
                    { x = clientPos.x - targetPos.x
                    , y = clientPos.y - targetPos.y
                    }
                        |> ClickedInHeaderAt
            }
                & DoNothing

        MouseMoved position ->
            case model.clickState of
                NoClicks ->
                    model & DoNothing

                ClickedInHeaderAt originalClick ->
                    { model
                        | externalPosition =
                            { x = position.x - originalClick.x
                            , y = position.y - originalClick.y
                            }
                    }
                        & DoNothing

                ClickedInScreenAt originalClick ->
                    { model
                        | internalPosition =
                            { x = position.x - originalClick.x
                            , y = position.y - originalClick.y
                            }
                    }
                        & DoNothing

        MouseUp ->
            { model
                | clickState = NoClicks
            }
                & DoNothing



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
            [ Canvas.toHtml
                [ style
                    [ left model.internalPosition.x
                    , top model.internalPosition.y
                    ]
                ]
                canvas
            , screen
            ]
        , a
            [ class "tool-button" ]
            [ text (Tool.icon ZoomIn) ]
        , a
            [ class "tool-button" ]
            [ text (Tool.icon ZoomOut) ]
        ]


screen : Html Msg
screen =
    div
        [ class "minimap-screen"
        , MouseEvents.onMouseDown
            (MouseDidSomething << ScreenMouseDown)
        ]
        []


header : Model -> Html Msg
header model =
    div
        [ class "header"
        , style [ width (model.size.width - extraWidth) ]
        , MouseEvents.onMouseDown
            (MouseDidSomething << HeaderMouseDown)
        ]
        [ p [] [ text "mini map" ]
        , a [ onClick CloseClick ] [ text "x" ]
        ]
