port module Ports exposing (..)

import Canvas exposing (Size)
import Json.Encode as Encode exposing (Value)
import Tuple.Infix exposing ((:=))


type JsMsg
    = StealFocus
    | ReturnFocus
    | SaveLocally Size String


jsMsg : String -> Value -> Cmd msg
jsMsg type_ payload =
    [ "type" := Encode.string type_
    , "payload" := payload
    ]
        |> Encode.object
        |> toJs


send : JsMsg -> Cmd msg
send msg =
    case msg of
        StealFocus ->
            jsMsg "steal focus" Encode.null

        ReturnFocus ->
            jsMsg "return focus" Encode.null

        SaveLocally { width, height } data ->
            let
                sizeJson =
                    [ "width" := Encode.int width
                    , "height" := Encode.int height
                    ]
                        |> Encode.object
            in
            [ "size" := sizeJson
            , "data" := Encode.string data
            ]
                |> Encode.object
                |> jsMsg "save"


port toJs : Value -> Cmd msg
