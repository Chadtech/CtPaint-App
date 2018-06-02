module Incorporate.Menu exposing (incorporate)

import Canvas
import Data.Drawing as Drawing
import Data.Flags exposing (Init(NormalInit), projectNameGenerator)
import Data.Menu as Menu
import Data.Selection as Selection
import Data.Taco as Taco
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
import Return2 as R2
import Util


incorporate : Menu.Model -> Maybe Reply -> Model -> ( Model, Cmd Msg )
incorporate menu maybeReply model =
    case maybeReply of
        Nothing ->
            { model
                | menu = Just menu
            }
                |> R2.withNoCmd

        Just reply ->
            handleReply reply menu model


handleReply : Reply -> Menu.Model -> Model -> ( Model, Cmd Msg )
handleReply reply menu model =
    case reply of
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
                | menu = Nothing
                , taco =
                    user
                        |> User.initModel Drawing.Local
                        |> User.LoggedIn
                        |> Taco.setUser model.taco
            }
                |> R2.withNoCmd

        AttemptingLogin ->
            { model
                | menu = Just menu
                , taco =
                    User.LoggingIn
                        |> Taco.setUser model.taco
            }
                |> R2.withNoCmd

        NoLongerLoggingIn ->
            { model
                | menu = Just menu
                , taco =
                    User.LoggedOut
                        |> Taco.setUser model.taco
            }
                |> R2.withNoCmd

        ResizeTo position size ->
            model
                |> History.canvas
                |> Model.updateCanvas
                    (Draw.resize position size model.color.swatches.bottom)
                |> closeMenu

        IncorporateDrawing drawing ->
            { model
                | taco =
                    case model.taco.user of
                        User.LoggedIn user ->
                            user
                                |> User.setDrawing drawing
                                |> User.LoggedIn
                                |> Taco.setUser model.taco

                        _ ->
                            model.taco
            }
                |> closeMenu

        TrySaving ->
            Helpers.Drawing.save model

        Logout ->
            { windowSize = model.windowSize
            , isMac = model.taco.config.isMac
            , browser = model.taco.config.browser
            , user = User.LoggedOut
            , init = NormalInit
            , mountPath = model.taco.config.mountPath
            , buildNumber = model.taco.config.buildNumber
            , randomValues =
                let
                    ( newProjectName, newSeed ) =
                        identity
                            |> Random.from model.seed
                            |> Random.value projectNameGenerator
                in
                { sessionId = model.taco.config.sessionId
                , projectName = newProjectName
                , seed = newSeed
                }
            }
                |> Init.fromFlags
                |> R2.addCmd (Ports.send Ports.Logout)

        SaveDrawingAttrs name ->
            let
                newModel =
                    { model | drawingName = name }
            in
            case Model.toSavePayload newModel of
                Just savePayload ->
                    newModel
                        |> closeMenu
                        |> R2.addCmd
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
    { model | menu = Nothing }
        |> R2.withCmd Ports.returnFocus


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
        |> R2.withCmd Ports.returnFocus
