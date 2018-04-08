module Tracking
    exposing
        ( Ctor
        , Event(..)
        , Payload
        , encode
        , makeCtor
        )

import Id exposing (Id, Origin)
import Json.Encode as Encode exposing (Value)
import Json.Encode.Extra as Encode
import Util exposing (def)


-- TYPES --


type alias Ctor =
    Event -> Payload


type alias Payload =
    { sessionId : Id
    , email : Maybe String
    , event : Event
    }


type Event
    = AppInit Origin
    | AppInitFail String
    | AllowanceExceed
    | ReportBug String
    | MenuDownloadClick
    | MenuDrawingSaveClick
    | MenuImportClick
    | MenuImportEnterPress
    | MenuImportTryAgainClick
    | MenuImportCanvasLoad (Maybe Error)
    | KeyboardEvent String String
    | KeyboardEventFail Error


type alias Error =
    String



-- PUBLIC --


encode : Payload -> Value
encode payload =
    [ def "name" <| encodeName payload.event
    , def "properties" <| encodeProperties payload
    ]
        |> Encode.object


makeCtor : Id -> Maybe String -> Event -> Payload
makeCtor =
    Payload



-- PRIVATE HELPERS --


encodeName : Event -> Value
encodeName =
    Encode.string << toName


toName : Event -> String
toName =
    toNamePieces >> String.join "_"


toNamePieces : Event -> List String
toNamePieces event =
    case event of
        AppInit _ ->
            [ "app", "init" ]

        AppInitFail _ ->
            [ "app", "init", "fail" ]

        AllowanceExceed ->
            [ "allowance-exceed" ]

        ReportBug _ ->
            [ "report", "bug" ]

        MenuDownloadClick ->
            [ "menu", "download", "click" ]

        MenuDrawingSaveClick ->
            [ "menu", "drawing", "save", "click" ]

        MenuImportClick ->
            [ "menu", "import", "click" ]

        MenuImportEnterPress ->
            [ "menu", "import", "enter", "press" ]

        MenuImportTryAgainClick ->
            [ "menu", "import", "try-again", "click" ]

        MenuImportCanvasLoad _ ->
            [ "menu", "import", "canvas", "load" ]

        KeyboardEvent _ _ ->
            [ "keyboard", "event" ]

        KeyboardEventFail _ ->
            [ "keyboard", "event", "fail" ]


encodeProperties : Payload -> Value
encodeProperties payload =
    [ def "sessionId" <| Id.encode payload.sessionId
    , def "email" <| Encode.maybe Encode.string payload.email
    ]
        |> List.append (eventProperties payload.event)
        |> Encode.object


eventProperties : Event -> List ( String, Value )
eventProperties event =
    case event of
        AppInit drawingId ->
            [ drawingIdField drawingId ]

        AppInitFail problem ->
            [ def "problem" <| Encode.string problem ]

        AllowanceExceed ->
            []

        ReportBug bug ->
            [ def "bug" <| Encode.string bug ]

        MenuDownloadClick ->
            []

        MenuDrawingSaveClick ->
            []

        MenuImportClick ->
            []

        MenuImportEnterPress ->
            []

        MenuImportTryAgainClick ->
            []

        MenuImportCanvasLoad maybeError ->
            [ maybeErrorField maybeError ]

        KeyboardEvent keyCmd keyEvent ->
            [ def "cmd" <| Encode.string keyCmd
            , def "event" <| Encode.string keyEvent
            ]

        KeyboardEventFail err ->
            [ errorField err ]


errorField : String -> ( String, Value )
errorField =
    def "error" << Encode.string


maybeErrorField : Maybe String -> ( String, Value )
maybeErrorField =
    def "error" << Encode.maybe Encode.string


drawingIdField : Origin -> ( String, Value )
drawingIdField =
    def "drawingId" << Util.encodeOrigin
