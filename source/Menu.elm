module Menu exposing (..)

import Canvas exposing (Canvas)
import Download
import Html exposing (Attribute, Html, a, div, p, text)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Import
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import Random exposing (Seed)
import Scale
import Text
import Util exposing ((&), height, left, top, width)
import Window exposing (Size)


type alias Model =
    { position : Position
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


type ClickState
    = NoClick
    | ClickAt Position


type Msg
    = HeaderMouseDown MouseEvent
    | HeaderMouseMove Position
    | HeaderMouseUp
    | XClick
    | ContentMsg ContentMsg


type ContentMsg
    = DownloadMsg Download.Msg
    | ImportMsg Import.Msg
    | ScaleMsg Scale.Msg
    | TextMsg Text.Msg


type ExternalMsg
    = DoNothing
    | Close
    | Cmd (Cmd Msg)
    | IncorporateImage Canvas
    | ScaleTo Int Int
    | AddText String



-- UPDATE --


update : Msg -> Model -> ( Model, ExternalMsg )
update msg model =
    case msg of
        XClick ->
            model & Close

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
                & DoNothing

        HeaderMouseMove p ->
            case model.click of
                ClickAt click ->
                    { model
                        | position =
                            { x = p.x - click.x
                            , y = p.y - click.y
                            }
                    }
                        & DoNothing

                NoClick ->
                    model & DoNothing

        HeaderMouseUp ->
            { model | click = NoClick } & DoNothing

        ContentMsg subMsg ->
            updateContent subMsg model


updateContent : ContentMsg -> Model -> ( Model, ExternalMsg )
updateContent msg model =
    case ( msg, model.content ) of
        ( DownloadMsg subMsg, Download subModel ) ->
            let
                ( newSubModel, cmd ) =
                    Download.update subMsg subModel

                contentCmd =
                    Cmd.map
                        (ContentMsg << DownloadMsg)
                        cmd
            in
            { model
                | content = Download newSubModel
            }
                & Cmd contentCmd

        ( ImportMsg subMsg, Import subModel ) ->
            let
                importUpdate =
                    Import.update subMsg subModel
            in
            incorporateImport importUpdate model

        ( ScaleMsg subMsg, Scale subModel ) ->
            let
                scaleUpdate =
                    Scale.update subMsg subModel
            in
            incorporateScale scaleUpdate model

        ( TextMsg subMsg, Text subModel ) ->
            let
                textUpdate =
                    Text.update subMsg subModel
            in
            incorporateText textUpdate model

        _ ->
            model & DoNothing


incorporateText :
    ( String, Text.ExternalMsg )
    -> Model
    -> ( Model, ExternalMsg )
incorporateText ( subModel, externalMsg ) model =
    case externalMsg of
        Text.DoNothing ->
            { model
                | content = Text subModel
            }
                & DoNothing

        Text.AddText text ->
            model & AddText text


incorporateScale :
    ( Scale.Model, Scale.ExternalMsg )
    -> Model
    -> ( Model, ExternalMsg )
incorporateScale ( subModel, externalMsg ) model =
    case externalMsg of
        Scale.DoNothing ->
            { model
                | content = Scale subModel
            }
                & DoNothing

        Scale.ScaleTo dw dh ->
            model & ScaleTo dw dh


incorporateImport :
    ( Import.Model, Import.ExternalMsg )
    -> Model
    -> ( Model, ExternalMsg )
incorporateImport ( subModel, externalMsg ) model =
    case externalMsg of
        Import.DoNothing ->
            { model
                | content = Import subModel
            }
                & DoNothing

        Import.IncorporateImage canvas ->
            model & IncorporateImage canvas

        Import.Cmd cmd ->
            let
                contentCmd =
                    Cmd.map
                        (ContentMsg << ImportMsg)
                        cmd
            in
            { model
                | content = Import subModel
            }
                & Cmd contentCmd



-- VIEW --


view : Model -> Html Msg
view { position, size, title, content } =
    let
        children =
            contentView content
                |> List.map (Html.map ContentMsg)
                |> (::) (header title)
    in
    div
        [ class "card menu"
        , style
            [ top position.y
            , left position.x
            , width size.width
            , height size.height
            ]
        ]
        children


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


header : String -> Html Msg
header title =
    div
        [ class "header" ]
        [ div
            [ class "click-screen"
            , MouseEvents.onMouseDown HeaderMouseDown
            ]
            []
        , p [] [ text title ]
        , a [ onClick XClick ] [ text "x" ]
        ]



-- INIT --


initText : Size -> Model
initText windowSize =
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
    , title = "text"
    , content = Text Text.init
    }


initScale : Size -> Size -> Model
initScale canvasSize windowSize =
    let
        size =
            { width = 424
            , height = 186
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



-- SUBSCRIPTIONS --


subscriptions : Sub Msg
subscriptions =
    Sub.batch
        [ Mouse.moves HeaderMouseMove
        , Mouse.ups (always HeaderMouseUp)
        ]
