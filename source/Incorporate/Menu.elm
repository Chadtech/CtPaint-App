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
            closeMenu model

        IncorporateImageAsSelection image ->
            let
                size =
                    Canvas.getSize image

                canvas =
                    Canvas.getSize model.canvas
            in
            { model
                | selection =
                    { x = (canvas.width - size.width) // 2
                    , y = (canvas.height - size.height) // 2
                    }
                        & image
                        |> Just
            }
                |> closeMenu

        IncorporateImageAsCanvas image ->
            { model | canvas = image }
                |> closeMenu

        ScaleTo w h ->
            case model.selection of
                Nothing ->
                    { model
                        | canvas =
                            Canvas.scale w h model.canvas
                    }
                        |> History.canvas
                        |> closeMenu

                Just ( pos, selection ) ->
                    { model
                        | selection =
                            selection
                                |> Canvas.scale w h
                                |& pos
                                |> Just
                    }
                        |> closeMenu

        AddText str ->
            addText str model

        Replace target replacement ->
            case model.selection of
                Just ( position, selection ) ->
                    { model
                        | selection =
                            selection
                                |> Draw.replace target replacement
                                |& position
                                |> Just
                    }
                        |> closeMenu

                Nothing ->
                    { model
                        | canvas =
                            Draw.replace
                                target
                                replacement
                                model.canvas
                    }
                        |> History.canvas
                        |> closeMenu

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

        SetToLoggedOut ->
            { model
                | user = User.LoggedOut
                , menu = Just menu
            }
                & Cmd.none

        SetProject project ->
            { model | project = project }
                |> closeMenu

        ResizeTo left top width height ->
            { model
                | canvas =
                    Draw.resize
                        left
                        top
                        width
                        height
                        model.color.swatches.second
                        model.canvas
            }
                |> closeMenu


closeMenu : Model -> ( Model, Cmd msg )
closeMenu model =
    { model | menu = Nothing } & Ports.send ReturnFocus


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
