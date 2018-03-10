module Download
    exposing
        ( Flags
        , Model
        , Msg
        , init
        , update
        , view
        )

import Html exposing (Html, a, form, input, p, text)
import Html.Attributes exposing (class, placeholder, value)
import Html.Custom
import Html.Events exposing (onClick, onInput, onSubmit)
import Ports exposing (JsMsg(Download))
import Reply exposing (Reply(CloseMenu, NoReply))


type Msg
    = FieldUpdated String
    | Submitted
    | DownloadButtonPressed


type alias Model =
    { field : String
    , placeholder : String
    }



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg, Reply )
update msg model =
    case msg of
        FieldUpdated str ->
            Reply.nothing { model | field = str }

        Submitted ->
            download model

        DownloadButtonPressed ->
            download model


download : Model -> ( Model, Cmd Msg, Reply )
download model =
    ( model
    , downloadCmd model
    , CloseMenu
    )


downloadCmd : Model -> Cmd Msg
downloadCmd =
    fileName >> Download >> Ports.send


fileName : Model -> String
fileName { field, placeholder } =
    case field of
        "" ->
            placeholder

        _ ->
            field



-- VIEW --


view : Model -> List (Html Msg)
view model =
    [ Html.Custom.field
        [ onSubmit Submitted
        ]
        [ p [] [ Html.text "file name" ]
        , input
            [ onInput FieldUpdated
            , value model.field
            , placeholder model.placeholder
            ]
            []
        ]
    , Html.Custom.menuButton
        [ onClick DownloadButtonPressed ]
        [ Html.text "download" ]
    ]



-- INIT --


type alias Flags =
    { name : String
    , nameIsGenerated : Bool
    }


init : Flags -> Model
init { name, nameIsGenerated } =
    { field =
        if nameIsGenerated then
            ""
        else
            name
    , placeholder = name
    }
