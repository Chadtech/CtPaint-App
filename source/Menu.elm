module Menu exposing (..)

import About
import BugReport
import Color
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Config exposing (Config)
import Data.Menu as Menu
    exposing
        ( ClickState(..)
        , ContentMsg(..)
        , Menu(..)
        , Model
        , Msg(..)
        )
import Download
import Drawing
import Html exposing (Attribute, Html, a, div, p, text)
import Html.Attributes exposing (class, style)
import Html.CssHelpers
import Html.Custom
import Import
import Loading
import Login
import Logout
import Mouse exposing (Position)
import New
import ReplaceColor
import Reply exposing (Reply(CloseMenu))
import Resize
import Return3 as R3 exposing (Return)
import Save
import Scale
import Text
import Upload
import Util exposing (toolbarWidth)
import Window exposing (Size)


-- UPDATE --


update : Config -> Msg -> Model -> Return Model Msg Reply
update config msg model =
    case msg of
        XButtonMouseDown ->
            { model
                | click = XButtonIsDown
            }
                |> R3.withNothing

        XButtonMouseUp ->
            CloseMenu
                |> R3.withTuple ( model, Cmd.none )

        HeaderMouseDown { targetPos, clientPos } ->
            case model.click of
                XButtonIsDown ->
                    model
                        |> R3.withNothing

                _ ->
                    { model
                        | click =
                            { x = clientPos.x - targetPos.x
                            , y = clientPos.y - targetPos.y
                            }
                                |> ClickAt
                    }
                        |> R3.withNothing

        HeaderMouseMove p ->
            case model.click of
                ClickAt click ->
                    { model
                        | position =
                            { x = p.x - click.x - 4
                            , y = p.y - click.y - 4
                            }
                    }
                        |> R3.withNothing

                _ ->
                    model
                        |> R3.withNothing

        HeaderMouseUp ->
            { model | click = NoClick }
                |> R3.withNothing

        ContentMsg subMsg ->
            updateContent config subMsg model


updateContent : Config -> ContentMsg -> Model -> Return Model Msg Reply
updateContent config msg model =
    case msg of
        DownloadMsg subMsg ->
            case model.content of
                Download subModel ->
                    subModel
                        |> Download.update subMsg
                        |> mapReturn model Menu.Download DownloadMsg

                _ ->
                    model |> R3.withNothing

        ImportMsg subMsg ->
            case model.content of
                Import subModel ->
                    subModel
                        |> Import.update subMsg
                        |> mapReturn model Menu.Import ImportMsg

                _ ->
                    model |> R3.withNothing

        ScaleMsg subMsg ->
            case model.content of
                Scale subModel ->
                    subModel
                        |> Scale.update subMsg
                        |> noCmd model Menu.Scale

                _ ->
                    model |> R3.withNothing

        TextMsg subMsg ->
            case model.content of
                Text subModel ->
                    subModel
                        |> Text.update subMsg
                        |> noCmd model Menu.Text

                _ ->
                    model |> R3.withNothing

        BugReportMsg subMsg ->
            case model.content of
                BugReport subModel ->
                    subModel
                        |> BugReport.update subMsg
                        |> mapReturn model Menu.BugReport BugReportMsg

                _ ->
                    model |> R3.withNothing

        ReplaceColorMsg subMsg ->
            case model.content of
                ReplaceColor subModel ->
                    subModel
                        |> ReplaceColor.update subMsg
                        |> noCmd model Menu.ReplaceColor

                _ ->
                    model |> R3.withNothing

        LoginMsg subMsg ->
            case model.content of
                Login subModel ->
                    subModel
                        |> Login.update config subMsg
                        |> mapReturn model Menu.Login LoginMsg

                _ ->
                    model |> R3.withNothing

        UploadMsg subMsg ->
            case model.content of
                Upload subModel ->
                    subModel
                        |> Upload.update subMsg
                        |> mapReturn model Menu.Upload UploadMsg

                _ ->
                    model |> R3.withNothing

        ResizeMsg subMsg ->
            case model.content of
                Resize subModel ->
                    subModel
                        |> Resize.update subMsg
                        |> noCmd model Menu.Resize

                _ ->
                    model |> R3.withNothing

        NewMsg subMsg ->
            case model.content of
                New subModel ->
                    subModel
                        |> New.update subMsg
                        |> noCmd model Menu.New

                _ ->
                    model |> R3.withNothing

        DrawingMsg subMsg ->
            case model.content of
                Drawing subModel ->
                    subModel
                        |> Drawing.update subMsg
                        |> noCmd model Menu.Drawing

                _ ->
                    model |> R3.withNothing

        SaveMsg subMsg ->
            case model.content of
                Save subModel ->
                    subModel
                        |> Save.update config subMsg
                        |> mapReturn model Menu.Save SaveMsg

                _ ->
                    model
                        |> R3.withNothing

        LogoutMsg subMsg ->
            case model.content of
                Logout ->
                    Logout.update subMsg
                        |> R3.withTuple ( model, Cmd.none )

                _ ->
                    model
                        |> R3.withNothing


noCmd : Model -> (a -> Menu) -> ( a, Maybe Reply ) -> Return Model Msg Reply
noCmd model toMenu ( subModel, reply ) =
    ( setContent toMenu model subModel
    , Cmd.none
    , reply
    )


mapReturn : Model -> (a -> Menu) -> (b -> ContentMsg) -> Return a b Reply -> Return Model Msg Reply
mapReturn model toMenu toContentMsg return =
    return
        |> R3.mapModel (setContent toMenu model)
        |> R3.mapCmd (toContentMsg >> ContentMsg)


setContent : (a -> Menu) -> Model -> a -> Model
setContent toMenu model subModel =
    { model | content = toMenu subModel }



-- STYLES --


type Class
    = MenuContainer
    | Unpositioned
    | ImportCard


css : Stylesheet
css =
    [ Css.class MenuContainer
        [ position absolute ]
    , Css.class Unpositioned
        [ left (pct 25)
        , top (pct 25)
        , display inlineBlock
        , position absolute
        ]
    , Css.class ImportCard
        [ width (px 420) ]
    ]
        |> namespace menuNamespace
        |> stylesheet


menuNamespace : String
menuNamespace =
    Html.Custom.makeNamespace "Menu"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace menuNamespace


view : Model -> Html Msg
view ({ title, content } as model) =
    Html.Custom.card
        (cardAttrs model)
        [ Html.Custom.header
            { text = title
            , headerMouseDown = HeaderMouseDown
            , xButtonMouseDown = XButtonMouseDown
            , xButtonMouseUp = XButtonMouseUp
            }
        , contentView content
            |> Html.map ContentMsg
        ]


cardAttrs : Model -> List (Attribute Msg)
cardAttrs ({ position } as model) =
    [ style
        [ Util.top position.y
        , Util.left position.x
        ]
    , [ MenuContainer ]
        |> Util.maybeCons (extraClass model)
        |> class
    ]


extraClass : Model -> Maybe Class
extraClass model =
    case model.content of
        Import _ ->
            Just ImportCard

        _ ->
            Nothing


contentView : Menu -> Html ContentMsg
contentView menu =
    case menu of
        Download subModel ->
            subModel
                |> Download.view
                |> Html.map DownloadMsg

        Import subModel ->
            subModel
                |> Import.view
                |> Html.map ImportMsg

        Scale subModel ->
            subModel
                |> Scale.view
                |> Html.map ScaleMsg

        Text subModel ->
            subModel
                |> Text.view
                |> Html.map TextMsg

        BugReport subModel ->
            subModel
                |> BugReport.view
                |> Html.map BugReportMsg

        About state ->
            About.view state

        ReplaceColor subModel ->
            subModel
                |> ReplaceColor.view
                |> Html.map ReplaceColorMsg

        New subModel ->
            subModel
                |> New.view
                |> Html.map NewMsg

        Login subModel ->
            subModel
                |> Login.view
                |> Html.map LoginMsg

        Loading subModel ->
            Loading.view subModel

        Upload subModel ->
            subModel
                |> Upload.view
                |> Html.map UploadMsg

        Resize subModel ->
            subModel
                |> Resize.view
                |> Html.map ResizeMsg

        Drawing subModel ->
            subModel
                |> Drawing.view
                |> Html.map DrawingMsg

        Save subModel ->
            subModel
                |> Save.view
                |> Html.map SaveMsg

        Logout ->
            Logout.view
                |> Html.map LogoutMsg



-- INIT --


init : String -> Menu -> Size -> Size -> Model
init title content cardSize windowSize =
    { position =
        { x = (windowSize.width - cardSize.width) // 2
        , y = (windowSize.height - cardSize.height) // 2
        }
    , click = NoClick
    , title = title
    , content = content
    }


initLogin : Size -> Model
initLogin =
    { width = 369
    , height = 147
    }
        |> init "login" (Login Login.init)


initNew : String -> Size -> Model
initNew name =
    { width = 466
    , height = 211
    }
        |> init "new" (New (New.init name))


initText : Size -> Model
initText =
    { width = 506
    , height = 313
    }
        |> init "text" (Text Text.init)


initBugReport : Bool -> Size -> Model
initBugReport loggedIn =
    { width = 420
    , height = 209
    }
        |> init
            "report bug"
            (BugReport (BugReport.init loggedIn))


initScale : Size -> Size -> Model
initScale canvasSize =
    let
        scale =
            canvasSize
                |> Scale.init
                |> Scale
    in
    { width = 730
    , height = 152
    }
        |> init "scale" scale


initImport : Size -> Model
initImport =
    { width = 420
    , height = 115
    }
        |> init "import" (Import Import.init)


initDownload : Download.Flags -> Size -> Model
initDownload flags =
    { width = 365
    , height = 155
    }
        |> init "download"
            (Download (Download.init flags))


initAbout : Int -> Size -> Model
initAbout buildNumber =
    { width = 416
    , height = 292
    }
        |> init "about"
            (About { buildNumber = buildNumber })


initReplaceColor : Color.Color -> Color.Color -> List Color.Color -> Size -> Model
initReplaceColor target replacement palette =
    let
        replaceColor =
            ReplaceColor.init target replacement palette
                |> ReplaceColor
    in
    init "replace color"
        replaceColor
        { width = 308
        , height = 196
        }


initUpload : Size -> Model
initUpload =
    { width = 524
    , height = 558
    }
        |> init "upload" (Upload Upload.init)


initResize : Size -> Size -> Model
initResize canvasSize =
    init "resize"
        (Resize (Resize.init canvasSize))
        { width = 180
        , height = 303
        }


initDrawing : String -> Size -> Model
initDrawing name =
    init "drawing"
        (Menu.Drawing (Drawing.init name))
        { width = 369
        , height = 115
        }


initLoading : Maybe String -> Size -> Model
initLoading maybeName =
    init "loading"
        (Loading (Loading.init maybeName))
        { width = 224
        , height = 99
        }


initLogout : Size -> Model
initLogout =
    { width = 420
    , height = 191
    }
        |> init "logout" Logout


initSave : String -> Size -> Model
initSave name =
    { width = 295
    , height = 99
    }
        |> init
            "saving"
            (Save (Save.init name))



-- SUBSCRIPTIONS --


subscriptions : Sub Msg
subscriptions =
    [ Mouse.moves HeaderMouseMove
    , Mouse.ups (always HeaderMouseUp)
    ]
        |> Sub.batch
