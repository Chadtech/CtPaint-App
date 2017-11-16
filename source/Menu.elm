module Menu exposing (..)

import About
import Color exposing (Color)
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Menu exposing (Menu(..), Model)
import Download
import Error
import Html exposing (Attribute, Html, a, div, p, text)
import Html.Attributes exposing (class, style)
import Html.CssHelpers
import Html.Custom
import Imgur
import Import
import Login
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import New
import Open
import Random exposing (Seed)
import ReplaceColor
import Reply exposing (Reply(CloseMenu, NoReply))
import Scale
import Text
import Tuple.Infix exposing ((&))
import Util exposing (ClickState(..), toolbarWidth)
import Window exposing (Size)


-- TYPES --


type Msg
    = HeaderMouseDown MouseEvent
    | HeaderMouseMove Mouse.Position
    | HeaderMouseUp
    | XClick
    | ContentMsg ContentMsg


type ContentMsg
    = DownloadMsg Download.Msg
    | ImportMsg Import.Msg
    | ScaleMsg Scale.Msg
    | TextMsg Text.Msg
    | ReplaceColorMsg ReplaceColor.Msg
    | ImgurMsg Imgur.Msg
    | NewMsg New.Msg
    | OpenMsg Open.Msg
    | LoginMsg Login.Msg


loginFailed : String -> Msg
loginFailed =
    Login.LoginFailed >> LoginMsg >> ContentMsg



-- UPDATE --


update : Msg -> Model -> ( ( Model, Cmd Msg ), Reply )
update msg model =
    case msg of
        XClick ->
            model & Cmd.none & CloseMenu

        HeaderMouseDown { targetPos, clientPos } ->
            { model
                | click =
                    { x = clientPos.x - targetPos.x + floor toolbarWidth
                    , y = clientPos.y - targetPos.y + floor toolbarWidth
                    }
                        |> ClickAt
                , position =
                    { x = targetPos.x - floor toolbarWidth - 4
                    , y = targetPos.y - floor toolbarWidth - 4
                    }
                        |> Just
            }
                & Cmd.none
                & NoReply

        HeaderMouseMove p ->
            case model.click of
                ClickAt click ->
                    { model
                        | position =
                            { x = p.x - click.x
                            , y = p.y - click.y
                            }
                                |> Just
                    }
                        & Cmd.none
                        & NoReply

                NoClick ->
                    model & Cmd.none & NoReply

        HeaderMouseUp ->
            { model | click = NoClick }
                & Cmd.none
                & NoReply

        ContentMsg subMsg ->
            updateContent subMsg model


updateContent : ContentMsg -> Model -> ( ( Model, Cmd Msg ), Reply )
updateContent msg model =
    case ( msg, model.content ) of
        ( DownloadMsg subMsg, Download subModel ) ->
            let
                ( newSubModel, cmd ) =
                    Download.update subMsg subModel
            in
            { model
                | content = Download newSubModel
            }
                & Cmd.map (ContentMsg << DownloadMsg) cmd
                & NoReply

        ( ImportMsg subMsg, Import subModel ) ->
            let
                ( ( newSubModel, cmd ), reply ) =
                    Import.update subMsg subModel
            in
            { model | content = Import newSubModel }
                & Cmd.map (ContentMsg << ImportMsg) cmd
                & reply

        ( ScaleMsg subMsg, Scale subModel ) ->
            let
                ( newSubModel, reply ) =
                    Scale.update subMsg subModel
            in
            { model | content = Scale newSubModel }
                & Cmd.none
                & reply

        ( TextMsg subMsg, Text subModel ) ->
            let
                ( newSubModel, reply ) =
                    Text.update subMsg subModel
            in
            { model | content = Text newSubModel }
                & Cmd.none
                & reply

        ( ReplaceColorMsg subMsg, ReplaceColor subModel ) ->
            let
                ( newSubModel, reply ) =
                    ReplaceColor.update subMsg subModel
            in
            { model | content = ReplaceColor newSubModel }
                & Cmd.none
                & reply

        ( LoginMsg subMsg, Login subModel ) ->
            let
                ( ( newSubModel, cmd ), reply ) =
                    Login.update subMsg subModel
            in
            { model | content = Login newSubModel }
                & Cmd.map (ContentMsg << LoginMsg) cmd
                & reply

        _ ->
            model & Cmd.none & NoReply



-- STYLES --


type Class
    = MenuContainer
    | Unpositioned


css : Stylesheet
css =
    [ Css.class MenuContainer
        [ position absolute ]
    , Css.class Unpositioned
        [ margin auto
        , top (pct 25)
        , maxWidth fitContent
        , position relative
        ]
    ]
        |> namespace menuNamespace
        |> stylesheet


menuNamespace : String
menuNamespace =
    "Menu"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace menuNamespace


view : Model -> Html Msg
view { position, title, content } =
    Html.Custom.card
        (positioning position)
        [ Html.Custom.header
            { text = title
            , headerMouseDown = HeaderMouseDown
            , xClick = XClick
            }
        , contentView content
            |> Html.Custom.cardBody []
            |> Html.map ContentMsg
        ]


positioning : Maybe Mouse.Position -> List (Attribute Msg)
positioning maybePosition =
    case maybePosition of
        Just position ->
            [ style
                [ Util.top position.y
                , Util.left position.x
                ]
            , class [ MenuContainer ]
            ]

        Nothing ->
            [ class
                [ Unpositioned
                ]
            ]


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

        About ->
            About.view

        ReplaceColor subModel ->
            List.map (Html.map ReplaceColorMsg) <|
                ReplaceColor.view subModel

        Imgur subModel ->
            List.map (Html.map ImgurMsg) <|
                Imgur.view subModel

        New subModel ->
            List.map (Html.map NewMsg) <|
                New.view subModel

        Open subModel ->
            List.map (Html.map OpenMsg) <|
                Open.view subModel

        Login subModel ->
            List.map (Html.map LoginMsg) <|
                Login.view subModel

        Error subModel ->
            Error.view subModel



-- INIT --


init : String -> Menu -> Model
init title content =
    { position = Nothing
    , click = NoClick
    , title = title
    , content = content
    }


initError : String -> Model
initError err =
    init "error" (Error err)


initLogin : Model
initLogin =
    init "login" (Login Login.init)


initNew : Model
initNew =
    init "new" (New New.init)


initText : Model
initText =
    init "text" (Text Text.init)


initScale : Size -> Model
initScale canvasSize =
    canvasSize
        |> Scale.init
        |> Scale
        |> init "scale"


initImport : Model
initImport =
    init "import" (Import Import.init)


initDownload : Maybe String -> Seed -> ( Model, Seed )
initDownload maybeProjectName seed =
    Download.init maybeProjectName seed
        |> Tuple.mapFirst (Download >> init "download")


initAbout : Model
initAbout =
    init "about" About


initReplaceColor : Color.Color -> Color.Color -> List Color.Color -> Model
initReplaceColor target replacement palette =
    ReplaceColor.init target replacement palette
        |> ReplaceColor
        |> init "replace color"


initImgur : Model
initImgur =
    init "imgur" (Imgur Imgur.init)



-- SUBSCRIPTIONS --


subscriptions : Sub Msg
subscriptions =
    [ Mouse.moves HeaderMouseMove
    , Mouse.ups (always HeaderMouseUp)
    ]
        |> Sub.batch
