module Model
    exposing
        ( Model
        , applyTo
        , canvasPosInCenterOfWindow
        , centerInWorkarea
        , centerOfWorkarea
        , closeMenu
        , copy
        , cut
        , getBuildNumber
        , getConfig
        , getMountPath
        , getSessionId
        , getUser
        , getWindowSize
        , initAbout
        , initDownload
        , initDrawing
        , initLogin
        , initLogout
        , initReplaceColorMenu
        , initResize
        , initScaleMenu
        , initTextMenu
        , initUpload
        , mapCanvasModel
        , mapMainCanvas
        , moveTowardsClickPosition
        , paste
        , positionOnCanvas
        , saveDrawing
        , setColorModel
        , setKeyAsDown
        , setKeyAsUp
        , setMenu
        , setMinimap
        , setShift
        , setUser
        , setWindowSize
        , swatchesTurnLeft
        , swatchesTurnRight
        , toSavePayload
        , toggleMinimapOpen
        , usersBrowser
        , usersComputerIsMac
        , zoomIn
        , zoomOut
        )

import Array
import Canvas exposing (Canvas)
import Canvas.Draw.Model as Draw
import Canvas.Model
import Clipboard.Model as Clipboard
import Color.Model as Color
import Color.Swatches.Data as Swatches
import Data.Config exposing (Config)
import Data.Drawing as Drawing
import Data.Keys as Key
import Data.Position as Position exposing (Position)
import Data.Size as Size exposing (Size)
import Data.User as User
import History.Model as History
import Id exposing (Id)
import Keyboard.Extra.Browser exposing (Browser)
import Menu.Model as Menu
import Minimap.Model as Minimap
import Ports exposing (SavePayload)
import Random.Pcg as Random exposing (Seed)
import Return2 as R2
import Selection.Model as Selection
import Style
import Taskbar.Data.Dropdown exposing (Dropdown)
import Tool.Data exposing (Tool)
import Tool.Zoom as Zoom exposing (zoom)
import Tool.Zoom.Data.Direction as Direction
    exposing
        ( Direction
        )


type alias Model =
    { canvas : Canvas.Model.Model
    , draws : Draw.Model
    , color : Color.Model
    , drawingName : String
    , drawingNameIsGenerated : Bool
    , tool : Tool
    , zoom : Int
    , galleryView : Bool
    , history : History.Model
    , mousePosition : Maybe Position
    , selection : Maybe Selection.Model
    , clipboard : Maybe Clipboard.Model
    , taskbarDropped : Maybe Dropdown
    , minimap : Minimap.Model
    , menu : Maybe Menu.Model
    , seed : Seed
    , eraserSize : Int
    , shiftIsDown : Bool
    , windowSize : Size
    , user : User.State
    , config : Config
    }



-- HELPERS --


applyTo : Model -> (Model -> Model) -> Model
applyTo model f =
    f model



-- SELECTORS --


getBuildNumber : Model -> Int
getBuildNumber =
    getConfig >> .buildNumber


getDrawingName : Model -> String
getDrawingName =
    .drawingName


getUser : Model -> User.State
getUser =
    .user


getConfig : Model -> Config
getConfig =
    .config


getMountPath : Model -> String
getMountPath =
    getConfig >> .mountPath


getSessionId : Model -> Id
getSessionId =
    getConfig >> .sessionId



-- USER --


setUser : User.State -> Model -> Model
setUser user model =
    { model | user = user }



-- ENVIRONMENT --


usersComputerIsMac : Model -> Bool
usersComputerIsMac =
    getConfig >> .isMac


usersBrowser : Model -> Browser
usersBrowser =
    getConfig >> .browser



-- CANVAS --


mapMainCanvas : (Canvas -> Canvas) -> Model -> Model
mapMainCanvas f model =
    { model | canvas = Canvas.Model.mapMain f model.canvas }


mapCanvasModel : (Canvas.Model.Model -> Canvas.Model.Model) -> Model -> Model
mapCanvasModel f model =
    { model | canvas = f model.canvas }



-- DRAWING --


toSavePayload : Model -> Maybe SavePayload
toSavePayload model =
    case getUser model of
        User.LoggedIn { user, drawing } ->
            { canvas = model.canvas.main
            , name = model.drawingName
            , nameIsGenerated = model.drawingNameIsGenerated
            , palette = model.color.palette
            , swatches = model.color.swatches
            , email = user.email
            , id = Drawing.toOrigin drawing
            }
                |> Just

        _ ->
            Nothing


saveDrawing : Model -> ( Model, Cmd msg )
saveDrawing model =
    case toSavePayload model of
        Just savePayload ->
            { model
                | menu =
                    Menu.initSave
                        savePayload.name
                        (getWindowSize model)
                        |> Just
            }
                |> R2.withCmd
                    (Ports.send (Ports.Save savePayload))

        Nothing ->
            model
                |> R2.withNoCmd



-- COLORS --


swatchesTurnLeft : Model -> Model
swatchesTurnLeft model =
    { model
        | color =
            Color.mapSwatches
                Swatches.turnLeft
                model.color
    }


swatchesTurnRight : Model -> Model
swatchesTurnRight model =
    { model
        | color =
            Color.mapSwatches
                Swatches.turnRight
                model.color
    }


setKeyAsUp : Model -> Model
setKeyAsUp model =
    { model
        | color =
            Color.mapSwatches
                Swatches.setKeyAsUp
                model.color
    }


setKeyAsDown : Model -> Model
setKeyAsDown model =
    { model
        | color =
            Color.mapSwatches
                Swatches.setKeyAsDown
                model.color
    }


setColorModel : Color.Model -> Model -> Model
setColorModel colorModel model =
    { model | color = colorModel }


initReplaceColorMenu : Model -> ( Model, Cmd msg )
initReplaceColorMenu model =
    Menu.initReplaceColor
        model.color.swatches.top
        model.color.swatches.bottom
        (Array.toList model.color.palette)
        |> initMenu model


initTextMenu : Model -> ( Model, Cmd msg )
initTextMenu model =
    initMenu model Menu.initText


initScaleMenu : Model -> ( Model, Cmd msg )
initScaleMenu model =
    model
        |> initScaleCanvas
        |> Canvas.getSize
        |> Menu.initScale
        |> initMenu model


initScaleCanvas : Model -> Canvas
initScaleCanvas model =
    case model.selection of
        Just { canvas } ->
            canvas

        Nothing ->
            model.canvas.main


initUpload : Model -> ( Model, Cmd msg )
initUpload model =
    initMenu model Menu.initUpload
        |> R2.addCmd
            (Ports.send Ports.OpenUpFileUpload)


initResize : Model -> ( Model, Cmd msg )
initResize model =
    model.canvas.main
        |> Canvas.getSize
        |> Menu.initResize
        |> initMenu model


initDownload : Model -> ( Model, Cmd msg )
initDownload model =
    { name = model.drawingName
    , nameIsGenerated =
        model.drawingNameIsGenerated
    }
        |> Menu.initDownload
        |> initMenu model


initLogin : Model -> ( Model, Cmd msg )
initLogin model =
    initMenu model Menu.initLogin
        |> R2.addCmd
            (Ports.send Ports.Logout)


initLogout : Model -> ( Model, Cmd msg )
initLogout model =
    initMenu model Menu.initLogout


initAbout : Model -> ( Model, Cmd msg )
initAbout model =
    model
        |> getBuildNumber
        |> Menu.initAbout
        |> initMenu model


initDrawing : Model -> ( Model, Cmd msg )
initDrawing model =
    model
        |> getDrawingName
        |> Menu.initDrawing
        |> initMenu model


initMenu : Model -> (Size -> Menu.Model) -> ( Model, Cmd msg )
initMenu model menuCtor =
    { model
        | menu =
            model
                |> getWindowSize
                |> menuCtor
                |> Just
    }
        |> R2.withCmd Ports.stealFocus


closeMenu : Model -> ( Model, Cmd msg )
closeMenu model =
    { model | menu = Nothing }
        |> R2.withCmd Ports.returnFocus



-- POSITIONING --


{-| Given the canvas position and the position
you clicked in the window, adjust the
click position to be relative to the canvas
-}
positionOnCanvas : Model -> Position -> Position
positionOnCanvas { canvas, zoom } position =
    position
        |> Position.subtract canvas.position
        |> Position.subtract Style.workareaOrigin
        |> Position.divideBy zoom


{-| There is the whole window. But in that window is a
work area. And in that workarea is a canvas. The canvas
has some position, and some zoom level. There is a position
on the canvas that is appearing in the middle of the window.

This function returns that position.

So for example, if the upper left corner of the canvas
was right in the middle of the window, this function should
return { x = 0, x = 0 }

-}
canvasPosInCenterOfWindow : Model -> Position
canvasPosInCenterOfWindow model =
    model
        |> getWindowSize
        |> Size.center
        |> Position.subtract model.canvas.position
        |> Position.divideBy model.zoom


centerOfWorkarea : Model -> Position
centerOfWorkarea model =
    model
        |> getWindowSize
        |> Size.subtractFromWidth Style.toolbarWidth
        |> Size.subtractFromHeight Style.taskbarHeight
        |> Size.center


{-| In many cases, we need to put a new canvas right
in the center of the work area (new canvases, imported
images, text). This function calculates where to position
the new canvas in the work area, such that its right
in the center.
-}
centerInWorkarea : Model -> Size -> Position
centerInWorkarea model canvasSize =
    Size.centerIn (workareaSize model) canvasSize


workareaSize : Model -> Size
workareaSize model =
    model
        |> getWindowSize
        |> Size.subtractFromWidth Style.toolbarWidth
        |> Size.subtractFromHeight Style.taskbarHeight


getWindowSize : Model -> Size
getWindowSize model =
    model.windowSize


setWindowSize : Size -> Model -> Model
setWindowSize windowSize model =
    { model | windowSize = windowSize }



-- ZOOM --


zoomIn : Model -> Model
zoomIn model =
    let
        newZoom : Int
        newZoom =
            Zoom.nextLevelIn model.zoom

        newCanvasPosition : Position
        newCanvasPosition =
            zoom
                model.zoom
                newZoom
                (centerOfWorkarea model)
                model.canvas.position
    in
    { model
        | zoom = newZoom
        , canvas =
            Canvas.Model.setPosition
                newCanvasPosition
                model.canvas
    }


zoomOut : Model -> Model
zoomOut model =
    let
        newZoom : Int
        newZoom =
            Zoom.nextLevelOut model.zoom

        newCanvasPosition : Position
        newCanvasPosition =
            zoom
                model.zoom
                newZoom
                (centerOfWorkarea model)
                model.canvas.position
    in
    { model
        | zoom = newZoom
        , canvas =
            Canvas.Model.setPosition
                newCanvasPosition
                model.canvas
    }


{-| When users click to zoom in, they dont then just
zoom in. Also the perspective moves closer to where
they clicked. This function does that moving.
-}
moveTowardsClickPosition : Position -> Direction -> Model -> Model
moveTowardsClickPosition clickInWindowPosition direction model =
    { model
        | canvas =
            model
                |> centerOfWorkarea
                |> Position.subtractFrom clickInWindowPosition
                ----^ the position relative to the
                --    center of the work area
                |> Position.divideBy model.zoom
                |> Position.multiplyBy (Direction.toInt direction)
                ----^ the distance multiplied by
                --    the the zoom and whether
                --    the zoom is in or out
                |> Position.add model.canvas.position
                ----^ the canvas position moved by
                --    the previously calculated
                --    position
                |> Canvas.Model.setPosition
                |> Canvas.Model.applyTo model.canvas
    }



-- MINIMAP --


toggleMinimapOpen : Model -> Model
toggleMinimapOpen model =
    { model
        | minimap =
            Minimap.toggleOpen
                (getWindowSize model)
                model.minimap
    }


setMinimap : Minimap.Model -> Model -> Model
setMinimap minimapModel model =
    { model | minimap = minimapModel }


setMenu : Menu.Model -> Model -> Model
setMenu menu model =
    { model | menu = Just menu }



-- CLIPBOARD --


copy : Model -> Model
copy model =
    { model
        | clipboard =
            Maybe.map
                Selection.toClipboard
                model.selection
    }


cut : Model -> Model
cut model =
    { model
        | clipboard =
            Maybe.map
                Selection.toClipboard
                model.selection
        , selection = Nothing
    }


paste : Model -> Model
paste model =
    { model
        | selection =
            Maybe.map
                Selection.fromClipboard
                model.clipboard
    }



-- KEYS --


setShift : Key.Event -> Model -> Model
setShift event model =
    { model | shiftIsDown = event.shift }
