module Menu exposing (..)

import About
import Color exposing (Color)
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Download
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
import Util exposing (height, left, top, width)
import Window exposing (Size)


-- TYPES --


type alias Model =
    { position : Mouse.Position
    , size : Size
    , click : ClickState
    , title : String
    , content : Menu
    }


type Menu
    = Download Download.Model
    | Import Import.Model
    | Scale Scale.Model
    | Text String
    | About
    | ReplaceColor ReplaceColor.Model
    | Imgur Imgur.Model
    | New New.Model
    | Open Open.Model
    | Login Login.Model


type ClickState
    = NoClick
    | ClickAt Mouse.Position


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



-- UPDATE --


update : Msg -> Model -> ( ( Model, Cmd Msg ), Reply )
update msg model =
    case msg of
        XClick ->
            model & Cmd.none & CloseMenu

        HeaderMouseDown { targetPos, clientPos } ->
            { model
                | click =
                    { x =
                        clientPos.x - targetPos.x
                    , y =
                        clientPos.y - targetPos.y
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
                            { x = p.x - click.x
                            , y = p.y - click.y
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

        _ ->
            model & Cmd.none & NoReply



-- STYLES --


type Class
    = MenuContainer


css : Stylesheet
css =
    [ Css.class MenuContainer
        [ position absolute ]
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
view { position, size, title, content } =
    Html.Custom.card
        [ style
            [ Util.top position.y
            , Util.left position.x
            ]
        , class [ MenuContainer ]
        ]
        [ Html.Custom.header
            { text = title
            , headerMouseDown = HeaderMouseDown
            , xClick = XClick
            }
        , contentView content
            |> Html.Custom.cardBody []
            |> Html.map ContentMsg
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



-- INIT --


initNew : Size -> Model
initNew windowSize =
    let
        size =
            { width = 400
            , height = 400
            }
    in
    { position =
        { x = (windowSize.width - size.width) // 2
        , y = (windowSize.height - size.height) // 2
        }
    , size = size
    , click = NoClick
    , title = "new"
    , content = New New.init
    }


initText : Size -> Model
initText windowSize =
    let
        size =
            { width = 500
            , height = 308
            }
    in
    { position =
        { x = (windowSize.width - size.width) // 2
        , y = (windowSize.height - size.height) // 2
        }
    , size = size
    , click = NoClick
    , title = "text"
    , content = Text Text.init
    }


initScale : Size -> Size -> Model
initScale canvasSize windowSize =
    let
        size =
            { width = 384
            , height = 196
            }
    in
    { position =
        { x = (windowSize.width - size.width) // 2
        , y = (windowSize.height - size.height) // 2
        }
    , size = size
    , click = NoClick
    , title = "scale"
    , content = Scale (Scale.init canvasSize)
    }


initImport : Size -> Model
initImport windowSize =
    let
        size =
            { width = 416
            , height = 112
            }
    in
    { position =
        { x = (windowSize.width - size.width) // 2
        , y = (windowSize.height - size.height) // 2
        }
    , size = size
    , click = NoClick
    , title = "import"
    , content = Import Import.init
    }


initDownload : Size -> Maybe String -> Seed -> ( Model, Seed )
initDownload windowSize maybeProjectName seed =
    let
        ( menu, newSeed ) =
            Download.init maybeProjectName seed

        size =
            { width = 416
            , height = 112
            }
    in
    { position =
        { x = (windowSize.width - size.width) // 2
        , y = (windowSize.height - size.height) // 2
        }
    , size = size
    , click = NoClick
    , title = "download"
    , content = Download menu
    }
        & newSeed


initAbout : Size -> Model
initAbout windowSize =
    let
        size =
            { width = 400
            , height = 400
            }
    in
    { position =
        { x = (windowSize.width - size.width) // 2
        , y = (windowSize.height - size.height) // 2
        }
    , size = size
    , click = NoClick
    , title = "about"
    , content = About
    }


initReplaceColor : Size -> Color.Color -> Color.Color -> List Color.Color -> Model
initReplaceColor windowSize target replacement palette =
    let
        size =
            { width = 196
            , height = 338
            }
    in
    { position =
        { x = (windowSize.width - size.width) // 2
        , y = (windowSize.height - size.height) // 2
        }
    , size = size
    , click = NoClick
    , title = "replace color"
    , content =
        ReplaceColor.init target replacement palette
            |> ReplaceColor
    }


initImgur : Size -> Model
initImgur windowSize =
    let
        size =
            { width = 400
            , height = 400
            }
    in
    { position =
        { x = (windowSize.width - size.width) // 2
        , y = (windowSize.height - size.height) // 2
        }
    , size = size
    , click = NoClick
    , title = "imgur"
    , content =
        Imgur Imgur.init
    }



-- SUBSCRIPTIONS --


subscriptions : Sub Msg
subscriptions =
    Sub.batch
        [ Mouse.moves HeaderMouseMove
        , Mouse.ups (always HeaderMouseUp)
        ]
