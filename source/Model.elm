module Model
    exposing
        ( Model
        , applyTo
          -- , canvasPosInCenterOfWindow
        , closeMenu
        , initReplaceColorMenu
        , initScaleMenu
        , initTextMenu
        , mapCanvasModel
        , mapMainCanvas
        , setColorModel
        , setKeyAsDown
        , setKeyAsUp
        , setTaco
        , swatchesTurnLeft
        , swatchesTurnRight
        , toSavePayload
        )

import Array
import Canvas exposing (Canvas)
import Canvas.Model
import Clipboard.Model as Clipboard
import Color.Model as Color
import Color.Swatches.Data as Swatches
import Data.Drawing as Drawing
import Data.Minimap as Minimap
import Position.Data as Position exposing (Position)
import Data.Size as Size exposing (Size)
import Data.Taco exposing (Taco)
import Data.Taskbar exposing (Dropdown)
import Data.User as User
import Canvas.Draw.Model as Draw
import History.Model as History
import Menu.Model as Menu
import Ports exposing (SavePayload)
import Random.Pcg as Random exposing (Seed)
import Return2 as R2
import Selection.Model as Selection
import Tool.Data exposing (Tool)


type alias Model =
    { canvas : Canvas.Model.Model
    , draws : Draw.Model
    , color : Color.Model
    , drawingName : String
    , drawingNameIsGenerated : Bool
    , windowSize : Size
    , tool : Tool
    , zoom : Int
    , galleryView : Bool
    , history : History.Model
    , mousePosition : Maybe Position
    , selection : Maybe Selection.Model
    , clipboard : Maybe Clipboard.Model
    , taskbarDropped : Maybe Dropdown
    , minimap : Minimap.State
    , menu : Maybe Menu.Model
    , seed : Seed
    , eraserSize : Int
    , shiftIsDown : Bool
    , taco : Taco
    }



-- HELPERS --


applyTo : Model -> (Model -> Model) -> Model
applyTo model f =
    f model


setTaco : Model -> Taco -> Model
setTaco model taco =
    { model | taco = taco }


mapMainCanvas : (Canvas -> Canvas) -> Model -> Model
mapMainCanvas f model =
    { model | canvas = Canvas.Model.mapMain f model.canvas }


mapCanvasModel : (Canvas.Model.Model -> Canvas.Model.Model) -> Model -> Model
mapCanvasModel f model =
    { model | canvas = f model.canvas }


toSavePayload : Model -> Maybe SavePayload
toSavePayload model =
    case model.taco.user of
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
        model.windowSize
        |> initMenu model


initTextMenu : Model -> ( Model, Cmd msg )
initTextMenu model =
    model.windowSize
        |> Menu.initText
        |> initMenu model


initScaleMenu : Model -> ( Model, Cmd msg )
initScaleMenu model =
    Menu.initScale
        (Canvas.getSize (initScaleCanvas model))
        model.windowSize
        |> initMenu model


initScaleCanvas : Model -> Canvas
initScaleCanvas model =
    case model.selection of
        Just { canvas } ->
            canvas

        Nothing ->
            model.canvas.main


initMenu : Model -> Menu.Model -> ( Model, Cmd msg )
initMenu model menu =
    { model | menu = Just menu }
        |> R2.withCmd Ports.stealFocus


closeMenu : Model -> ( Model, Cmd msg )
closeMenu model =
    { model | menu = Nothing }
        |> R2.withCmd Ports.returnFocus
