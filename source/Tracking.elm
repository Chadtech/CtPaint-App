module Tracking
    exposing
        ( Ctor
        , Event(..)
        , Payload
        , encode
        )

import Id exposing (Id, Origin)
import Json.Encode as Encode exposing (Value)
import Json.Encode.Extra as Encode
import Keyboard.Extra.Browser exposing (Browser)
import Mouse exposing (Position)
import Util exposing (def)
import Window exposing (Size)


-- TYPES --


type alias Ctor =
    Event -> Payload


type alias Payload =
    { sessionId : Id
    , email : Maybe String
    , buildNumber : Int
    , event : Event
    }


type alias InitValues =
    { windowSize : Size
    , isMac : Bool
    , browser : Browser
    , buildNumber : Int
    , drawingId : Origin
    }


type Event
    = AppInit InitValues
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
    | PaletteSquareClick Int Color Bool
    | PaletteSquareRightClick Int Color
    | PaletteAddSquareClick
    | MenuReplaceColorReplaceClick Color Color
    | MenuReplaceColorColorClick
    | MenuResizeClick Size Size
    | MenuSaveTryAgainClick
    | MenuSaveOpenHomeClick
    | MenuSaveUpdateResponse (Maybe Error)
    | MenuSaveCreateResponse (Maybe Error)
    | MenuScaleLockClick
    | MenuScaleClick Size Size
    | TaskbarDropdownOutClick
    | TaskbarDropdownClick String
    | TaskbarDropdownHoverOnto String
    | TaskbarLoginClick
    | TaskbarUserClick
    | TaskbarLogoutClick
    | TaskbarAboutClick
    | TaskbarReportBugClick
    | TaskbarKeyCmdClick String
    | TaskbarWindowClick String
    | TaskbarUploadClick
    | TaskbarToolClick String
    | TaskbarDrawingClick
    | TaskbarOpenImageLinkClick
    | MenuTextClick Int
    | ToolbarToolButtonClick String
    | ToolbarOtherButtonClick String
    | ToolbarIncreaseEraserClick Int
    | ToolbarDecreaseEraserClick Int
    | ClientMouseUp Position
    | ScreenMouseDown Position
    | WindowSize Size
    | KeyboardEvent String String
    | KeyboardEventFail Error
    | Logout (Maybe Error)
    | MsgDecodeFail Error
    | InitFromUrl (Maybe Error)


type alias Color =
    String


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



-- PRIVATE HELPERS --


encodeName : Event -> Value
encodeName =
    Encode.string << (++) "paint-app_" << toName


toName : Event -> String
toName =
    toNameSpaces
        >> String.split " "
        >> String.join "_"


toNameSpaces : Event -> String
toNameSpaces event =
    case event of
        AppInit _ ->
            "app init"

        AppInitFail _ ->
            "app init fail"

        AllowanceExceed ->
            "allowance-exceed"

        ReportBug _ ->
            "report bug"

        MenuDownloadClick ->
            "menu download click"

        MenuDrawingSaveClick ->
            "menu drawing save click"

        MenuImportClick ->
            "menu import click"

        MenuImportEnterPress ->
            "menu import enter press"

        MenuImportTryAgainClick ->
            "menu import try-again click"

        MenuImportCanvasLoad _ ->
            "menu import canvas load"

        MenuLoginForgotPasswordClick ->
            "menu login forgot-password click"

        MenuLoginClick ->
            "menu login click"

        MenuLoginEnterPress ->
            "menu login enter press"

        MenuLoginResponse _ ->
            "menu login response"

        MenuXMouseUp _ ->
            "menu x mouse up"

        MenuHeaderMouseDown _ _ ->
            "menu header mouse down"

        MenuHeaderMouseUp _ _ ->
            "menu header mouse up"

        MinimapXMouseUp ->
            "minimap x mouse up"

        MinimapZoomInClick ->
            "minimap zoom-in click"

        MinimapZoomOutClick ->
            "minimap zoom-out click"

        MinimapZeroClick ->
            "minimap zero click"

        MenuNewStartClick _ _ ->
            "menu new start click"

        MenuNewStartEnterPress _ _ ->
            "menu new start enter press"

        MenuNewColorClick _ ->
            "menu new color click"

        PaletteSquareClick _ _ _ ->
            "palette square click"

        PaletteSquareRightClick _ _ ->
            "palette square right click"

        PaletteAddSquareClick ->
            "palette add square click"

        MenuReplaceColorReplaceClick _ _ ->
            "menu replace color replace click"

        MenuReplaceColorColorClick ->
            "menu replace color click"

        MenuResizeClick _ _ ->
            "menu resize click"

        MenuSaveTryAgainClick ->
            "menu save try-again click"

        MenuSaveOpenHomeClick ->
            "menu save open-home click"

        MenuSaveUpdateResponse _ ->
            "menu save update response"

        MenuSaveCreateResponse _ ->
            "menu save create response"

        MenuScaleLockClick ->
            "menu scale lock click"

        MenuScaleClick _ _ ->
            "menu scale click"

        TaskbarDropdownOutClick ->
            "taskbar dropdown out click"

        TaskbarDropdownClick _ ->
            "taskbar dropdown click"

        TaskbarDropdownHoverOnto _ ->
            "taskbar dropdown hover-onto"

        TaskbarLoginClick ->
            "taskbar login click"

        TaskbarUserClick ->
            "taskbar user click"

        TaskbarLogoutClick ->
            "taskbar logout click"

        TaskbarAboutClick ->
            "taskbar about click"

        TaskbarReportBugClick ->
            "taskbar report-bug click"

        TaskbarKeyCmdClick _ ->
            "taskbar key-cmd click"

        TaskbarWindowClick _ ->
            "taskbar window click"

        TaskbarUploadClick ->
            "taskbar upload click"

        TaskbarToolClick _ ->
            "taskbar tool click"

        TaskbarDrawingClick ->
            "taskbar drawing click"

        TaskbarOpenImageLinkClick ->
            "task bar open-image-link click"

        MenuTextClick _ ->
            "menu text click"

        ToolbarToolButtonClick _ ->
            "toolbar tool button click"

        ToolbarOtherButtonClick _ ->
            "toolbar other button click"

        ToolbarIncreaseEraserClick _ ->
            "toolbar increase eraser click"

        ToolbarDecreaseEraserClick _ ->
            "toolbar decrease eraser click"

        ClientMouseUp _ ->
            "client mouse up"

        ScreenMouseDown _ ->
            "screen mouse down"

        WindowSize _ ->
            "window size"

        KeyboardEvent _ _ ->
            "keyboard event"

        KeyboardEventFail _ ->
            "keyboard event fail"

        Logout _ ->
            "logout"

        MsgDecodeFail _ ->
            "msg decode fail"

        InitFromUrl _ ->
            "init from url"


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
        AppInit initValues ->
            [ drawingIdField initValues.drawingId
            , initValues.isMac
                |> Encode.bool
                |> def "is-mac"
            , initValues.browser
                |> toString
                |> String.toLower
                |> Encode.string
                |> def "browser"
            , initValues.buildNumber
                |> Encode.int
                |> def "build-number"
            , initValues.windowSize
                |> Util.encodeSize
                |> def "window-size"
            ]

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

        PaletteSquareClick index color shift ->
            [ colorField color
            , indexField index
            , shiftField shift
            ]

        PaletteSquareRightClick index color ->
            [ colorField color
            , indexField index
            ]

        PaletteAddSquareClick ->
            []

        MenuReplaceColorReplaceClick target replacement ->
            [ def "target" <| Encode.string target
            , def "replacement" <| Encode.string replacement
            ]

        MenuReplaceColorColorClick ->
            []

        MenuResizeClick oldSize newSize ->
            [ def "old-size" <| Util.encodeSize oldSize
            , def "new-size" <| Util.encodeSize newSize
            ]

        MenuSaveTryAgainClick ->
            []

        MenuSaveOpenHomeClick ->
            []

        MenuSaveUpdateResponse maybeError ->
            [ maybeErrorField maybeError ]

        MenuSaveCreateResponse maybeError ->
            [ maybeErrorField maybeError ]

        MenuScaleLockClick ->
            []

        MenuScaleClick oldSize newSize ->
            [ def "old-size" <| Util.encodeSize oldSize
            , def "new-size" <| Util.encodeSize newSize
            ]

        TaskbarDropdownOutClick ->
            []

        TaskbarDropdownClick dropdown ->
            [ dropdownField dropdown ]

        TaskbarDropdownHoverOnto dropdown ->
            [ dropdownField dropdown ]

        TaskbarLoginClick ->
            []

        TaskbarUserClick ->
            []

        TaskbarLogoutClick ->
            []

        TaskbarAboutClick ->
            []

        TaskbarReportBugClick ->
            []

        TaskbarKeyCmdClick keyCmd ->
            [ cmdField keyCmd ]

        TaskbarWindowClick window ->
            [ def "window" <| Encode.string window ]

        TaskbarUploadClick ->
            []

        TaskbarToolClick tool ->
            [ toolField tool ]

        TaskbarDrawingClick ->
            []

        TaskbarOpenImageLinkClick ->
            []

        MenuTextClick length ->
            [ def "text-length" <| Encode.int length ]

        ToolbarToolButtonClick tool ->
            [ toolField tool ]

        ToolbarOtherButtonClick otherButton ->
            [ def "button" <| Encode.string otherButton ]

        ToolbarIncreaseEraserClick size ->
            [ def "eraser-size" <| Encode.int size ]

        ToolbarDecreaseEraserClick size ->
            [ def "eraser-size" <| Encode.int size ]

        ClientMouseUp position ->
            [ positionField position ]

        ScreenMouseDown position ->
            [ positionField position ]

        WindowSize size ->
            [ sizeField size ]

        KeyboardEvent keyCmd keyEvent ->
            [ cmdField keyCmd
            , def "event" <| Encode.string keyEvent
            ]

        KeyboardEventFail err ->
            [ errorField err ]

        Logout maybeError ->
            [ maybeErrorField maybeError ]

        MsgDecodeFail error ->
            [ errorField error ]

        InitFromUrl maybeError ->
            [ maybeErrorField maybeError ]


toolField : String -> ( String, Value )
toolField =
    def "tool" << Encode.string


cmdField : String -> ( String, Value )
cmdField =
    def "cmd" << Encode.string


dropdownField : String -> ( String, Value )
dropdownField =
    def "dropdown" << Encode.string


shiftField : Bool -> ( String, Value )
shiftField =
    def "shift-is-down" << Encode.bool


colorField : String -> ( String, Value )
colorField =
    def "color" << Encode.string


indexField : Int -> ( String, Value )
indexField =
    def "index" << Encode.int


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
