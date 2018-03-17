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
import Open
import ReplaceColor
import Reply exposing (Reply(CloseMenu, NoReply))
import Resize
import Save
import Scale
import Text
import Tuple.Infix exposing ((&))
import Upload
import Util exposing (toolbarWidth)
import Window exposing (Size)


-- UPDATE --


update : Config -> Msg -> Model -> ( ( Model, Cmd Msg ), Reply )
update config msg model =
    case msg of
        XButtonMouseDown ->
            { model
                | click = XButtonIsDown
            }
                & Cmd.none
                & NoReply

        XButtonMouseUp ->
            model & Cmd.none & CloseMenu

        HeaderMouseDown { targetPos, clientPos } ->
            case model.click of
                XButtonIsDown ->
                    model & Cmd.none & NoReply

                _ ->
                    { model
                        | click =
                            { x = clientPos.x - targetPos.x
                            , y = clientPos.y - targetPos.y
                            }
                                |> ClickAt
                    }
                        & Cmd.none
                        & NoReply

        HeaderMouseMove p ->
            case model.click of
                ClickAt click ->
                    { model
                        | position =
                            { x = p.x - click.x - 4
                            , y = p.y - click.y - 4
                            }
                    }
                        & Cmd.none
                        & NoReply

                _ ->
                    model & Cmd.none & NoReply

        HeaderMouseUp ->
            { model | click = NoClick }
                & Cmd.none
                & NoReply

        ContentMsg subMsg ->
            updateContent config subMsg model


updateContent : Config -> ContentMsg -> Model -> ( ( Model, Cmd Msg ), Reply )
updateContent config msg model =
    case msg of
        DownloadMsg subMsg ->
            case model.content of
                Download subModel ->
                    let
                        ( newSubModel, cmd, reply ) =
                            Download.update subMsg subModel
                    in
                    { model
                        | content = Download newSubModel
                    }
                        & Cmd.map (ContentMsg << DownloadMsg) cmd
                        & reply

                _ ->
                    model & Cmd.none & NoReply

        ImportMsg subMsg ->
            case model.content of
                Import subModel ->
                    let
                        ( newSubModel, cmd, reply ) =
                            Import.update subMsg subModel
                    in
                    { model | content = Import newSubModel }
                        & Cmd.map (ContentMsg << ImportMsg) cmd
                        & reply

                _ ->
                    model & Cmd.none & NoReply

        ScaleMsg subMsg ->
            case model.content of
                Scale subModel ->
                    let
                        ( newSubModel, reply ) =
                            Scale.update subMsg subModel
                    in
                    { model | content = Scale newSubModel }
                        & Cmd.none
                        & reply

                _ ->
                    model & Cmd.none & NoReply

        TextMsg subMsg ->
            case model.content of
                Text subModel ->
                    let
                        ( newSubModel, reply ) =
                            Text.update subMsg subModel
                    in
                    { model | content = Text newSubModel }
                        & Cmd.none
                        & reply

                _ ->
                    model & Cmd.none & NoReply

        BugReportMsg subMsg ->
            case model.content of
                BugReport subModel ->
                    let
                        ( newSubModel, cmd, reply ) =
                            BugReport.update subMsg subModel
                    in
                    { model | content = BugReport newSubModel }
                        & Cmd.map (ContentMsg << BugReportMsg) cmd
                        & reply

                _ ->
                    model & Cmd.none & NoReply

        ReplaceColorMsg subMsg ->
            case model.content of
                ReplaceColor subModel ->
                    let
                        ( newSubModel, reply ) =
                            ReplaceColor.update subMsg subModel
                    in
                    { model | content = ReplaceColor newSubModel }
                        & Cmd.none
                        & reply

                _ ->
                    model & Cmd.none & NoReply

        LoginMsg subMsg ->
            case model.content of
                Login subModel ->
                    let
                        ( newSubModel, cmd, reply ) =
                            Login.update config subMsg subModel
                    in
                    { model | content = Login newSubModel }
                        & Cmd.map (ContentMsg << LoginMsg) cmd
                        & reply

                _ ->
                    model & Cmd.none & NoReply

        UploadMsg subMsg ->
            case model.content of
                Upload subModel ->
                    let
                        ( ( newSubModel, cmd ), reply ) =
                            Upload.update subMsg subModel
                    in
                    { model | content = Upload newSubModel }
                        & Cmd.map (ContentMsg << UploadMsg) cmd
                        & reply

                _ ->
                    model & Cmd.none & NoReply

        ResizeMsg subMsg ->
            case model.content of
                Resize subModel ->
                    let
                        ( newSubModel, reply ) =
                            Resize.update subMsg subModel
                    in
                    { model | content = Resize newSubModel }
                        & Cmd.none
                        & reply

                _ ->
                    model & Cmd.none & NoReply

        NewMsg subMsg ->
            case model.content of
                New subModel ->
                    let
                        ( newSubModel, reply ) =
                            New.update subMsg subModel
                    in
                    { model | content = New newSubModel }
                        & Cmd.none
                        & reply

                _ ->
                    model & Cmd.none & NoReply

        OpenMsg subMsg ->
            case model.content of
                Open subModel ->
                    let
                        ( newSubModel, _ ) =
                            Open.update subMsg subModel
                    in
                    { model | content = Open newSubModel }
                        & Cmd.none
                        & NoReply

                _ ->
                    model & Cmd.none & NoReply

        DrawingMsg subMsg ->
            case model.content of
                Drawing subModel ->
                    let
                        ( newSubModel, reply ) =
                            Drawing.update subMsg subModel
                    in
                    { model | content = Menu.Drawing newSubModel }
                        & Cmd.none
                        & reply

                _ ->
                    model & Cmd.none & NoReply

        SaveMsg subMsg ->
            case model.content of
                Save subModel ->
                    let
                        ( newSubModel, cmd, reply ) =
                            Save.update subMsg subModel
                    in
                    { model
                        | content =
                            Menu.Save newSubModel
                    }
                        & Cmd.map (ContentMsg << SaveMsg) cmd
                        & reply

                _ ->
                    model & Cmd.none & NoReply

        LogoutMsg subMsg ->
            case model.content of
                Logout ->
                    model & Cmd.none & Logout.update subMsg

                _ ->
                    model & Cmd.none & NoReply


mapContent : (a -> Menu) -> Model -> ( a, Cmd msg ) -> ( Model, Cmd msg )
mapContent toMenu model ( subModel, cmd ) =
    { model | content = toMenu subModel } & cmd


mapCmd : (msg -> ContentMsg) -> ( Model, Cmd msg ) -> ( Model, Cmd Msg )
mapCmd toMsg ( model, cmd ) =
    model & Cmd.map (ContentMsg << toMsg) cmd



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
            |> Html.Custom.cardBody []
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


contentView : Menu -> List (Html ContentMsg)
contentView menu =
    case menu of
        Download subModel ->
            List.map (Html.map DownloadMsg) <|
                Download.view subModel

        Import subModel ->
            List.map (Html.map ImportMsg) <|
                Import.view subModel

        Scale subModel ->
            List.map (Html.map ScaleMsg) <|
                Scale.view subModel

        Text subModel ->
            List.map (Html.map TextMsg) <|
                Text.view subModel

        BugReport subModel ->
            List.map (Html.map BugReportMsg) <|
                BugReport.view subModel

        About state ->
            About.view state

        ReplaceColor subModel ->
            List.map (Html.map ReplaceColorMsg) <|
                ReplaceColor.view subModel

        New subModel ->
            List.map (Html.map NewMsg) <|
                New.view subModel

        Open subModel ->
            List.map (Html.map OpenMsg) <|
                Open.view subModel

        Login subModel ->
            List.map (Html.map LoginMsg) <|
                Login.view subModel

        Loading subModel ->
            Loading.view subModel

        Upload subModel ->
            List.map (Html.map UploadMsg) <|
                Upload.view subModel

        Resize subModel ->
            List.map (Html.map ResizeMsg) <|
                Resize.view subModel

        Drawing subModel ->
            List.map (Html.map DrawingMsg) <|
                Drawing.view subModel

        Save subModel ->
            List.map (Html.map SaveMsg) <|
                Save.view subModel

        Logout ->
            List.map (Html.map LogoutMsg) <|
                Logout.view



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
