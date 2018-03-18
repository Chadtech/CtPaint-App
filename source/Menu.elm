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
import Reply exposing (Reply(CloseMenu, NoReply))
import Resize
import Save
import Scale
import Text
import Upload
import Util exposing (toolbarWidth)
import Window exposing (Size)


-- UPDATE --


update : Config -> Msg -> Model -> ( Model, Cmd Msg, Reply )
update config msg model =
    case msg of
        XButtonMouseDown ->
            { model
                | click = XButtonIsDown
            }
                |> Reply.nothing

        XButtonMouseUp ->
            ( model
            , Cmd.none
            , CloseMenu
            )

        HeaderMouseDown { targetPos, clientPos } ->
            case model.click of
                XButtonIsDown ->
                    model
                        |> Reply.nothing

                _ ->
                    { model
                        | click =
                            { x = clientPos.x - targetPos.x
                            , y = clientPos.y - targetPos.y
                            }
                                |> ClickAt
                    }
                        |> Reply.nothing

        HeaderMouseMove p ->
            case model.click of
                ClickAt click ->
                    { model
                        | position =
                            { x = p.x - click.x - 4
                            , y = p.y - click.y - 4
                            }
                    }
                        |> Reply.nothing

                _ ->
                    model
                        |> Reply.nothing

        HeaderMouseUp ->
            { model | click = NoClick }
                |> Reply.nothing

        ContentMsg subMsg ->
            updateContent config subMsg model


updateContent : Config -> ContentMsg -> Model -> ( Model, Cmd Msg, Reply )
updateContent config msg model =
    case msg of
        DownloadMsg subMsg ->
            case model.content of
                Download subModel ->
                    subModel
                        |> Download.update subMsg
                        |> return3 model Menu.Download DownloadMsg

                _ ->
                    model |> Reply.nothing

        ImportMsg subMsg ->
            case model.content of
                Import subModel ->
                    subModel
                        |> Import.update subMsg
                        |> return3 model Menu.Import ImportMsg

                _ ->
                    model |> Reply.nothing

        ScaleMsg subMsg ->
            case model.content of
                Scale subModel ->
                    subModel
                        |> Scale.update subMsg
                        |> noCmd model Menu.Scale

                _ ->
                    model |> Reply.nothing

        TextMsg subMsg ->
            case model.content of
                Text subModel ->
                    subModel
                        |> Text.update subMsg
                        |> noCmd model Menu.Text

                _ ->
                    model |> Reply.nothing

        BugReportMsg subMsg ->
            case model.content of
                BugReport subModel ->
                    subModel
                        |> BugReport.update subMsg
                        |> return3 model Menu.BugReport BugReportMsg

                _ ->
                    model |> Reply.nothing

        ReplaceColorMsg subMsg ->
            case model.content of
                ReplaceColor subModel ->
                    subModel
                        |> ReplaceColor.update subMsg
                        |> noCmd model Menu.ReplaceColor

                _ ->
                    model |> Reply.nothing

        LoginMsg subMsg ->
            case model.content of
                Login subModel ->
                    subModel
                        |> Login.update config subMsg
                        |> return3 model Menu.Login LoginMsg

                _ ->
                    model |> Reply.nothing

        UploadMsg subMsg ->
            case model.content of
                Upload subModel ->
                    subModel
                        |> Upload.update subMsg
                        |> return3 model Menu.Upload UploadMsg

                _ ->
                    model |> Reply.nothing

        ResizeMsg subMsg ->
            case model.content of
                Resize subModel ->
                    subModel
                        |> Resize.update subMsg
                        |> noCmd model Menu.Resize

                _ ->
                    model |> Reply.nothing

        NewMsg subMsg ->
            case model.content of
                New subModel ->
                    subModel
                        |> New.update subMsg
                        |> noCmd model Menu.New

                _ ->
                    model |> Reply.nothing

        DrawingMsg subMsg ->
            case model.content of
                Drawing subModel ->
                    subModel
                        |> Drawing.update subMsg
                        |> noCmd model Menu.Drawing

                _ ->
                    model |> Reply.nothing

        SaveMsg subMsg ->
            case model.content of
                Save subModel ->
                    subModel
                        |> Save.update config subMsg
                        |> return3 model Menu.Save SaveMsg

                _ ->
                    model |> Reply.nothing

        LogoutMsg subMsg ->
            case model.content of
                Logout ->
                    ( model
                    , Cmd.none
                    , Logout.update subMsg
                    )

                _ ->
                    model |> Reply.nothing


noCmd : Model -> (a -> Menu) -> ( a, Reply ) -> ( Model, Cmd Msg, Reply )
noCmd model toMenu ( subModel, reply ) =
    ( { model | content = toMenu subModel }
    , Cmd.none
    , reply
    )


return3 : Model -> (a -> Menu) -> (b -> ContentMsg) -> ( a, Cmd b, Reply ) -> ( Model, Cmd Msg, Reply )
return3 model toMenu toContentMsg ( subModel, cmd, reply ) =
    ( { model | content = toMenu subModel }
    , Cmd.map (toContentMsg >> ContentMsg) cmd
    , reply
    )



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
