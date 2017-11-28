module Menu exposing (..)

import About
import Color exposing (Color)
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Menu
    exposing
        ( ContentMsg(..)
        , Menu(..)
        , Model
        , Msg(..)
        )
import Download
import Error
import Html exposing (Attribute, Html, a, div, p, text)
import Html.Attributes exposing (class, style)
import Html.CssHelpers
import Html.Custom
import Imgur
import Import
import Loading
import Login
import Mouse exposing (Position)
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


-- UPDATE --


update : Msg -> Model -> ( ( Model, Cmd Msg ), Reply )
update msg model =
    case msg of
        XClick ->
            model & Cmd.none & CloseMenu

        HeaderMouseDown { targetPos, clientPos } ->
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
            , xClick = XClick
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
    case Debug.log "content" model.content of
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

        Loading subModel ->
            Loading.view subModel



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


initError : String -> Size -> Model
initError err =
    { width = 40
    , height = 40
    }
        |> init "error" (Error err)


initLogin : Size -> Model
initLogin =
    { width = 369
    , height = 147
    }
        |> init "login" (Login Login.init)


initNew : Size -> Model
initNew =
    { width = 10
    , height = 10
    }
        |> init "new" (New New.init)


initText : Size -> Model
initText =
    { width = 506
    , height = 313
    }
        |> init "text" (Text Text.init)


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


initDownload : Maybe String -> Seed -> Size -> ( Model, Seed )
initDownload maybeProjectName seed windowSize =
    let
        ( downloadModel, newSeed ) =
            Download.init maybeProjectName seed

        cardSize =
            { width = 365
            , height = 115
            }
    in
    init "download" (Download downloadModel) cardSize windowSize
        & seed


initAbout : Size -> Model
initAbout =
    { width = 10
    , height = 10
    }
        |> init "about" About


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


initImgur : Size -> Model
initImgur =
    { width = 10
    , height = 10
    }
        |> init "imgur" (Imgur Imgur.init)



-- SUBSCRIPTIONS --


subscriptions : Sub Msg
subscriptions =
    [ Mouse.moves HeaderMouseMove
    , Mouse.ups (always HeaderMouseUp)
    ]
        |> Sub.batch
