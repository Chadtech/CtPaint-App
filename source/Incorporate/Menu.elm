module Incorporate.Menu exposing (incorporate)

import Canvas
import Data.Menu as Menu
import Data.User as User
import Draw
import Helpers.History as History
import Helpers.Zoom as Zoom
import Model exposing (Model)
import Ports exposing (JsMsg(ReturnFocus, StealFocus))
import Reply exposing (Reply(..))
import Tuple.Infix exposing ((&), (|&))


incorporate : Reply -> Menu.Model -> Model -> ( Model, Cmd msg )
incorporate reply menu model =
    case reply of
        NoReply ->
            { model
                | menu = Just menu
            }
                & Cmd.none

        CloseMenu ->
            { model
                | menu = Nothing
            }
                & Ports.send ReturnFocus

        IncorporateImageAsSelection image ->
            let
                size =
                    Canvas.getSize image

                canvas =
                    Canvas.getSize model.canvas

                imagePosition =
                    { x =
                        (canvas.width - size.width) // 2
                    , y =
                        (canvas.height - size.height) // 2
                    }
            in
            { model
                | selection =
                    { x = (canvas.width - size.width) // 2
                    , y = (canvas.height - size.height) // 2
                    }
                        & image
                        |> Just
                , menu = Nothing
            }
                & Ports.send ReturnFocus

        IncorporateImageAsCanvas image ->
            { model
                | canvas = image
                , menu = Nothing
            }
                & Ports.send ReturnFocus

        ScaleTo w h ->
            case model.selection of
                Nothing ->
                    { model
                        | menu = Nothing
                        , canvas =
                            Canvas.scale w h model.canvas
                    }
                        |> History.canvas
                        & Ports.send ReturnFocus

                Just ( pos, selection ) ->
                    { model
                        | menu = Nothing
                        , selection =
                            selection
                                |> Canvas.scale w h
                                |& pos
                                |> Just
                    }
                        & Ports.send ReturnFocus

        AddText str ->
            addText str model

        Replace target replacement ->
            case model.selection of
                Just ( position, selection ) ->
                    { model
                        | menu = Nothing
                        , selection =
                            selection
                                |> Draw.replace target replacement
                                |& position
                                |> Just
                    }
                        & Cmd.none

                Nothing ->
                    { model
                        | menu = Nothing
                        , canvas =
                            Draw.replace
                                target
                                replacement
                                model.canvas
                    }
                        |> History.canvas
                        & Cmd.none

        SetUser user ->
            { model
                | user = User.LoggedIn user
                , menu = Nothing
            }
                & Cmd.none

        AttemptingLogin ->
            { model
                | user = User.LoggingIn
                , menu = Just menu
            }
                & Cmd.none

        SetToNoSession ->
            { model
                | user = User.NoSession
                , menu = Just menu
            }
                & Cmd.none

        SetProject id project ->
            { model
                | project = Just project
                , menu = Nothing
            }
                & Cmd.none

        ResizeTo left top width height ->
            { model
                | menu = Nothing
                , canvas =
                    Draw.resize
                        left
                        top
                        width
                        height
                        model.color.swatches.second
                        model.canvas
            }
                & Ports.send ReturnFocus


addText : String -> Model -> ( Model, Cmd msg )
addText str model =
    let
        selection =
            Draw.text str model.color.swatches.primary

        position =
            Zoom.pointInMiddle
                model.windowSize
                model.zoom
                model.canvasPosition

        { width, height } =
            Canvas.getSize selection
    in
    { model
        | menu = Nothing
        , selection =
            { x = position.x - (width // 2)
            , y = position.y - (height // 2)
            }
                & selection
                |> Just
    }
        & Ports.send ReturnFocus
