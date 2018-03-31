module Incorporate.Menu exposing (incorporate)

import Canvas
import Data.Drawing as Drawing
import Data.Flags exposing (Init(NormalInit), projectNameGenerator)
import Data.Menu as Menu
import Data.Selection as Selection
import Data.User as User
import Draw
import Helpers.Drawing
import Helpers.History as History
import Helpers.Random as Random
import Helpers.Zoom as Zoom
import Init
import Model exposing (Model)
import Msg exposing (Msg)
import Ports
import Reply exposing (Reply(..))
import Tuple.Infix exposing ((&), (|&))
import Util


incorporate : Reply -> Menu.Model -> Model -> ( Model, Cmd Msg )
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
                    { canvas = image
                    , position =
                        { x = (canvas.width - size.width) // 2
                        , y = (canvas.height - size.height) // 2
                        }
                    , origin = Selection.Other
                    }
                        |> Just
            }
                |> closeMenu

        IncorporateImageAsCanvas image ->
            { model
                | canvas = image
                , canvasPosition =
                    Util.center
                        model.windowSize
                        (Canvas.getSize image)
            }
                |> closeMenu

        ScaleTo w h ->
            case model.selection of
                Nothing ->
                    model
                        |> History.canvas
                        |> Model.updateCanvas (Canvas.scale w h)
                        |> closeMenu

                Just selection ->
                    { model
                        | selection =
                            Selection.updateCanvas
                                (Canvas.scale w h)
                                selection
                                |> Just
                    }
                        |> closeMenu

        AddText str ->
            addText str model

        Replace target replacement ->
            case model.selection of
                Just selection ->
                    { model
                        | selection =
                            Selection.updateCanvas
                                (Draw.replace target replacement)
                                selection
                                |> Just
                    }
                        |> closeMenu

                Nothing ->
                    model
                        |> History.canvas
                        |> Model.updateCanvas (Draw.replace target replacement)
                        |> closeMenu

        SetUser user ->
            { model
                | user =
                    user
                        |> User.initModel Drawing.Local
                        |> User.LoggedIn
                , menu = Nothing
            }
                & Cmd.none

        AttemptingLogin ->
            { model
                | user = User.LoggingIn
                , menu = Just menu
            }
                & Cmd.none

        NoLongerLoggingIn ->
            { model
                | user = User.LoggedOut
                , menu = Just menu
            }
                & Cmd.none

        ResizeTo position size ->
            model
                |> History.canvas
                |> Model.updateCanvas
                    (Draw.resize position size model.color.swatches.bottom)
                |> closeMenu

        IncorporateDrawing drawing ->
            { model
                | user =
                    case model.user of
                        User.LoggedIn user ->
                            user
                                |> User.setDrawing drawing
                                |> User.LoggedIn

                        _ ->
                            model.user
            }
                |> closeMenu

        TrySaving ->
            Helpers.Drawing.save model

        Logout ->
            { windowSize = model.windowSize
            , isMac = model.config.isMac
            , browser = model.config.browser
            , user = User.LoggedOut
            , init = NormalInit
            , mountPath = model.config.mountPath
            , buildNumber = model.config.buildNumber
            , randomValues =
                let
                    ( newProjectName, newSeed ) =
                        identity
                            |> Random.from model.seed
                            |> Random.value projectNameGenerator
                in
                { sessionId = model.config.sessionId
                , projectName = newProjectName
                , seed = newSeed
                }
            }
                |> Init.fromFlags
                |> Util.mixinCmd (Ports.send Ports.Logout)

        SaveDrawingAttrs name ->
            let
                newModel =
                    { model | drawingName = name }
            in
            case Model.toSavePayload newModel of
                Just savePayload ->
                    newModel
                        |> closeMenu
                        |> Util.mixinCmd
                            (Ports.send (Ports.Save savePayload))

                Nothing ->
                    newModel
                        |> closeMenu

        StartNewDrawing name nameIsGenerated canvas ->
            { model
                | canvas = canvas
                , canvasPosition =
                    Util.center
                        model.windowSize
                        (Canvas.getSize canvas)
                , drawingName = name
                , drawingNameIsGenerated = nameIsGenerated
            }
                |> closeMenu


closeMenu : Model -> ( Model, Cmd msg )
closeMenu model =
    { model | menu = Nothing } & Ports.returnFocus


addText : String -> Model -> ( Model, Cmd msg )
addText str ({ color } as model) =
    let
        selection =
            Draw.text str color.swatches.top

        { x, y } =
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
            { canvas = Draw.text str color.swatches.top
            , position =
                { x = x - (width // 2)
                , y = y - (height // 2)
                }
            , origin = Selection.Other
            }
                |> Just
    }
        & Ports.returnFocus
