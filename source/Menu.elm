module Menu exposing (..)

import Download
import Html exposing (Attribute, Html, a, div, p, text)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import Random exposing (Seed)
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


type ExternalMsg
    = DoNothing
    | Close
    | Cmd (Cmd Msg)



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
            let
                ( newMenu, cmd ) =
                    updateContent subMsg model
            in
            newMenu & Cmd (Cmd.map ContentMsg cmd)


updateContent : ContentMsg -> Model -> ( Model, Cmd ContentMsg )
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
                & Cmd.map DownloadMsg cmd



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
            Download.view subModel
                |> List.map (Html.map DownloadMsg)


header : String -> Html Msg
header title =
    div
        [ class "header"
        , MouseEvents.onMouseDown HeaderMouseDown
        ]
        [ p [] [ text title ]
        , a [ onClick XClick ] [ text "x" ]
        ]


menuClass : Menu -> String
menuClass content =
    case content of
        Download _ ->
            "download"



-- INIT --


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
