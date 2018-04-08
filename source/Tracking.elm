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
import Mouse exposing (Position)
import Util exposing (def)
import Window exposing (Size)


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
    | MenuLoginForgotPasswordClick
    | MenuLoginClick
    | MenuLoginEnterPress
    | MenuLoginResponse (Maybe Error)
    | MenuXMouseUp MenuName
    | MenuHeaderMouseDown Position MenuName
    | MenuHeaderMouseUp Position MenuName
    | MinimapXMouseUp
    | MinimapZoomInClick
    | MinimapZoomOutClick
    | MinimapZeroClick
    | MenuNewStartClick Size BackgroundColor
    | MenuNewStartEnterPress Size BackgroundColor
    | MenuNewColorClick BackgroundColor
    | KeyboardEvent String String
    | KeyboardEventFail Error


type alias BackgroundColor =
    String


type alias MenuName =
    String


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

        MenuLoginForgotPasswordClick ->
            [ "menu", "login", "forgot-password", "click" ]

        MenuLoginClick ->
            [ "menu", "login", "click" ]

        MenuLoginEnterPress ->
            [ "menu", "login", "enter", "press" ]

        MenuLoginResponse _ ->
            [ "menu", "login", "response" ]

        MenuXMouseUp _ ->
            [ "menu", "x", "mouse", "up" ]

        MenuHeaderMouseDown _ _ ->
            [ "menu", "header", "mouse", "down" ]

        MenuHeaderMouseUp _ _ ->
            [ "menu", "header", "mouse", "up" ]

        MinimapXMouseUp ->
            [ "minimap", "x", "mouse", "up" ]

        MinimapZoomInClick ->
            [ "minimap", "zoom-in", "click" ]

        MinimapZoomOutClick ->
            [ "minimap", "zoom-out", "click" ]

        MinimapZeroClick ->
            [ "minimap", "zero", "click" ]

        MenuNewStartClick _ _ ->
            [ "menu", "new", "start", "click" ]

        MenuNewStartEnterPress _ _ ->
            [ "menu", "new", "start", "enter", "press" ]

        MenuNewColorClick _ ->
            [ "menu", "new", "color", "click" ]

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

        MenuLoginForgotPasswordClick ->
            []

        MenuLoginClick ->
            []

        MenuLoginEnterPress ->
            []

        MenuLoginResponse maybeError ->
            [ maybeErrorField maybeError ]

        MenuXMouseUp menuName ->
            [ menuField menuName ]

        MenuHeaderMouseDown position menuName ->
            [ menuField menuName
            , positionField position
            ]

        MenuHeaderMouseUp position menuName ->
            [ menuField menuName
            , positionField position
            ]

        MinimapXMouseUp ->
            []

        MinimapZoomInClick ->
            []

        MinimapZoomOutClick ->
            []

        MinimapZeroClick ->
            []

        MenuNewStartClick size backgroundColor ->
            [ sizeField size
            , backgroundColorField backgroundColor
            ]

        MenuNewStartEnterPress size backgroundColor ->
            [ sizeField size
            , backgroundColorField backgroundColor
            ]

        MenuNewColorClick backgroundColor ->
            [ backgroundColorField backgroundColor ]

        KeyboardEvent keyCmd keyEvent ->
            [ def "cmd" <| Encode.string keyCmd
            , def "event" <| Encode.string keyEvent
            ]

        KeyboardEventFail err ->
            [ errorField err ]


backgroundColorField : String -> ( String, Value )
backgroundColorField =
    def "background-color" << Encode.string


sizeField : Size -> ( String, Value )
sizeField =
    def "size" << Util.encodeSize


positionField : Position -> ( String, Value )
positionField =
    def "position" << Util.encodePosition


menuField : String -> ( String, Value )
menuField =
    def "menu" << Encode.string


errorField : String -> ( String, Value )
errorField =
    def "error" << Encode.string


maybeErrorField : Maybe String -> ( String, Value )
maybeErrorField =
    def "error" << Encode.maybe Encode.string


drawingIdField : Origin -> ( String, Value )
drawingIdField =
    def "drawingId" << Util.encodeOrigin
