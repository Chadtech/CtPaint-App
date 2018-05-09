module Taskbar exposing (Msg(..), css, update, view)

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Data.Keys as Key exposing (Cmd(..), QuickKey)
import Data.Minimap exposing (State(..))
import Data.Taco as Taco exposing (Taco)
import Data.Taskbar as Taskbar exposing (Dropdown(..))
import Data.Tool as Tool exposing (Tool)
import Data.User as User exposing (User)
import Data.Window as Window exposing (Window(..))
import Helpers.Keys
import Html exposing (Attribute, Html, a, div, input, p)
import Html.CssHelpers
import Html.Custom exposing (outdent)
import Html.Events
    exposing
        ( onClick
        , onInput
        , onMouseOver
        )
import Keys
import Menu
import Model exposing (Model)
import Platform.Cmd as Platform
import Ports
    exposing
        ( JsMsg
            ( Logout
            , OpenNewWindow
            , OpenUpFileUpload
            , StealFocus
            )
        )
import Return2 as R2
import Tool
import Tracking
    exposing
        ( Event
            ( TaskbarAboutClick
            , TaskbarDrawingClick
            , TaskbarDropdownClick
            , TaskbarDropdownHoverOnto
            , TaskbarDropdownOutClick
            , TaskbarKeyCmdClick
            , TaskbarLoginClick
            , TaskbarLogoutClick
            , TaskbarOpenImageLinkClick
            , TaskbarReportBugClick
            , TaskbarToolClick
            , TaskbarUploadClick
            , TaskbarUserClick
            , TaskbarWindowClick
            )
        )
import Util exposing (toolbarWidth)


-- TYPES --


type Msg
    = DropdownClickedOut
    | DropdownClicked Dropdown
    | HoveredOnto Dropdown
    | LoginClicked
    | UserClicked
    | LogoutClicked
    | AboutClicked
    | ReportBugClicked
    | KeyCmdClicked Key.Cmd
    | NewWindowClicked Window
    | UploadClicked
    | ToolClicked Tool
    | DrawingClicked
    | OpenImageLinkClicked



-- UPDATE --


update : Msg -> Model -> ( Model, Platform.Cmd msg )
update msg model =
    case msg of
        DropdownClickedOut ->
            TaskbarDropdownOutClick
                |> Ports.track model.taco
                |> R2.withModel
                    { model
                        | taskbarDropped = Nothing
                    }

        DropdownClicked dropdown ->
            TaskbarDropdownClick (Taskbar.toString dropdown)
                |> Ports.track model.taco
                |> R2.withModel
                    { model
                        | taskbarDropped = Just dropdown
                    }

        HoveredOnto dropdown ->
            hoverOnto dropdown model

        LoginClicked ->
            { model
                | menu =
                    model.windowSize
                        |> Menu.initLogin
                        |> Just
            }
                |> R2.withCmds
                    [ Ports.stealFocus
                    , Ports.send Ports.Logout
                    , TaskbarLoginClick
                        |> Ports.track model.taco
                    ]

        UserClicked ->
            case model.taco.user of
                User.LoggedIn user ->
                    user
                        |> User.toggleOptionsDropped
                        |> User.LoggedIn
                        |> Taco.setUser model.taco
                        |> Model.setTaco model
                        |> R2.withCmd
                            (Ports.track model.taco TaskbarUserClick)

                _ ->
                    model |> R2.withNoCmd

        LogoutClicked ->
            { model
                | menu =
                    model.windowSize
                        |> Menu.initLogout
                        |> Just
            }
                |> R2.withCmd
                    (Ports.track model.taco TaskbarLogoutClick)

        AboutClicked ->
            { model
                | menu =
                    model.windowSize
                        |> Menu.initAbout
                            model.taco.config.buildNumber
                        |> Just
            }
                |> R2.withCmd
                    (Ports.track model.taco TaskbarAboutClick)

        ReportBugClicked ->
            { model
                | menu =
                    model.windowSize
                        |> Menu.initBugReport
                            (User.isLoggedIn model.taco.user)
                        |> Just
            }
                |> R2.withCmds
                    [ Ports.stealFocus
                    , TaskbarReportBugClick
                        |> Ports.track model.taco
                    ]

        KeyCmdClicked keyCmd ->
            Keys.exec keyCmd model
                |> R2.addCmd
                    (trackKeyCmdClick model.taco keyCmd)

        NewWindowClicked window ->
            [ window
                |> Window.toUrl model.taco.config.mountPath
                |> Ports.OpenNewWindow
                |> Ports.send
            , window
                |> Window.toString
                |> TaskbarWindowClick
                |> Ports.track model.taco
            ]
                |> Cmd.batch
                |> R2.withModel model

        UploadClicked ->
            [ Ports.send OpenUpFileUpload
            , TaskbarUploadClick
                |> Ports.track model.taco
            ]
                |> Cmd.batch
                |> R2.withModel model

        ToolClicked tool ->
            tool
                |> Tool.name
                |> TaskbarToolClick
                |> Ports.track model.taco
                |> R2.withModel
                    { model | tool = tool }

        DrawingClicked ->
            { model
                | menu =
                    Menu.initDrawing
                        model.drawingName
                        model.windowSize
                        |> Just
            }
                |> R2.withCmds
                    [ Ports.stealFocus
                    , TaskbarDrawingClick
                        |> Ports.track model.taco
                    ]

        OpenImageLinkClicked ->
            case User.getPublicId model.taco.user of
                Just publicId ->
                    [ publicId
                        |> Window.Drawing
                        |> Window.toUrl model.taco.config.mountPath
                        |> OpenNewWindow
                        |> Ports.send
                    , TaskbarOpenImageLinkClick
                        |> Ports.track model.taco
                    ]
                        |> Cmd.batch
                        |> R2.withModel model

                _ ->
                    model |> R2.withNoCmd


trackKeyCmdClick : Taco -> Key.Cmd -> Platform.Cmd msg
trackKeyCmdClick taco keyCmd =
    keyCmd
        |> toString
        |> TaskbarKeyCmdClick
        |> Ports.track taco


hoverOnto : Dropdown -> Model -> ( Model, Platform.Cmd msg )
hoverOnto dropdown model =
    case model.taskbarDropped of
        Nothing ->
            model
                |> R2.withNoCmd

        Just currentDropdown ->
            if currentDropdown == dropdown then
                dropdown
                    |> trackHoverOnto model.taco
                    |> R2.withModel model
            else
                dropdown
                    |> trackHoverOnto model.taco
                    |> R2.withModel
                        { model
                            | taskbarDropped = Just dropdown
                        }


trackHoverOnto : Taco -> Dropdown -> Platform.Cmd msg
trackHoverOnto taco dropdown =
    dropdown
        |> Taskbar.toString
        |> TaskbarDropdownHoverOnto
        |> Ports.track taco



-- STYLES --


type Class
    = Taskbar
    | InvisibleWall
    | Button
    | Right
    | UserButton
    | Null
    | Dropped
    | Divider
    | Strike
    | Option
    | Disabled
    | Options
    | Seam
    | Dropdown Dropdown
    | Spinner
    | NameField


css : Stylesheet
css =
    [ Css.class Taskbar
        [ backgroundColor Ct.ignorable2
        , height (px toolbarWidth)
        , width (calc (pct 100) minus (px toolbarWidth))
        , left (px (toolbarWidth - 1))
        , top (px 0)
        , position absolute
        , borderBottom3 (px 1) solid Ct.ignorable3
        ]
    , Css.class InvisibleWall
        [ width (calc (pct 100) plus (px toolbarWidth))
        , height (vh 100)
        , position absolute
        , top (px 0)
        , left (px -toolbarWidth)
        , zIndex (int 1)
        ]
    , Css.class Button
        [ zIndex (int 2)
        , position relative
        , padding2 (px 2) (px 4)
        , withClass Dropped
            (outdent ++ [ zIndex (int 3) ])
        , active outdent
        , border3 (px 2) solid Ct.ignorable2
        ]
    , Css.class Right
        [ float right
        , marginRight (px 2)
        ]
    , Css.class UserButton
        [ float right
        , marginRight (px 2)
        , children
            [ Css.class Options
                [ right (px -2)
                , left unset
                ]
            , Css.class seam
                [ right (px 0)
                , left unset
                ]
            ]
        ]
    , Css.class Null
        [ backgroundColor Ct.ignorable3 ]
    , Css.class Seam
        [ backgroundColor Ct.ignorable2
        , height (px 2)
        , left (px 0)
        , zIndex (int 4)
        , width (calc (pct 100) plus (px 2))
        , position absolute
        ]
    , (Css.class Options << List.append outdent)
        [ position absolute
        , left (px -2)
        , backgroundColor Ct.ignorable2
        , width (px 340)
        , giveDropdownWidth (Dropdown Help) 180
        , giveDropdownWidth (Dropdown View) 200
        , giveDropdownWidth (Dropdown Edit) 220
        , giveDropdownWidth (Dropdown File) 280
        , giveDropdownWidth (Dropdown Tools) 300
        , giveDropdownWidth (Dropdown Taskbar.Colors) 390
        , giveDropdownWidth (Dropdown Taskbar.User) 150
        , hover [ color Ct.point0 ]
        ]
    , Css.class Divider
        [ height (px 16)
        , position relative
        ]
    , Css.class Strike
        [ position absolute
        , top (px 6)
        , left (px 4)
        , height (px 0)
        , width (px 332)
        , borderTop3 (px 2) solid Ct.ignorable3
        , borderBottom3 (px 2) solid Ct.ignorable1
        ]
    , Css.class Option
        [ height (px 32)
        , width (px 336)
        , position relative
        , justifyContent spaceBetween
        , verticalAlign middle
        , displayFlex
        , margin (px 0)
        , children
            [ Css.Elements.p
                [ height (px 32)
                , display tableCell
                , marginLeft (px 4)
                , marginTop (px 5)
                , marginRight (px 4)
                ]
            ]
        , hover
            [ backgroundColor Ct.point0
            , children
                [ Css.Elements.p
                    [ color Ct.ignorable3 ]
                ]
            ]
        , Css.withClass Disabled
            [ children
                [ Css.Elements.p
                    [ color Ct.ignorable1 ]
                ]
            , hover
                [ backgroundColor Ct.ignorable2 ]
            ]
        ]
    , Css.class Spinner
        [ height (px 24)
        , float right
        ]
    , Css.class NameField
        [ display inlineBlock
        , height (px 28)
        ]
    ]
        |> namespace taskbarNamespace
        |> stylesheet


giveDropdownWidth : Class -> Float -> Style
giveDropdownWidth dropdownClass dropdownWidth =
    withClass dropdownClass
        [ width (px dropdownWidth)
        , children
            [ Css.class Option
                [ width (px dropdownWidth) ]
            , Css.class Divider
                [ children
                    [ Css.class Strike
                        [ width (px (dropdownWidth - 8)) ]
                    ]
                ]
            ]
        ]


taskbarNamespace : String
taskbarNamespace =
    Html.Custom.makeNamespace "Taskbar"



-- VIEW --


{ class, classList } =
    Html.CssHelpers.withNamespace taskbarNamespace


view : Model -> Html Msg
view ({ taskbarDropped, taco } as model) =
    div
        [ class [ Taskbar ] ]
        [ file model
        , edit model
        , transform model
        , tools model
        , colors model
        , view_ model
        , help taskbarDropped
        , homeButton taco.user
        , userButton taco.user
        , invisibleWall taskbarDropped
        ]


homeButton : User.State -> Html Msg
homeButton userModel =
    case userModel of
        User.LoggedOut ->
            a
                [ class [ Button, Right ]
                , onClick (NewWindowClicked Home)
                ]
                [ Html.text "home" ]

        _ ->
            Html.text ""


userButton : User.State -> Html Msg
userButton userModel =
    case userModel of
        User.LoggedOut ->
            loginButton

        User.Offline ->
            offlineButton

        User.AllowanceExceeded ->
            loginButton

        User.LoggingIn ->
            spinner

        User.LoggingOut ->
            spinner

        User.LoggedIn user ->
            userOptions user


spinner : Html Msg
spinner =
    Html.Custom.spinner [ class [ Spinner ] ]


offlineButton : Html Msg
offlineButton =
    a
        [ class [ Button, UserButton ] ]
        [ Html.text "offline" ]


userOptions : User.Model -> Html Msg
userOptions { user, optionsDropped } =
    if optionsDropped then
        a
            [ class [ Button, UserButton, Dropped ]
            , onClick UserClicked
            ]
            [ Html.text user.name
            , seam
            , userDropdown user
            ]
    else
        a
            [ class [ Button, UserButton ]
            , onClick UserClicked
            ]
            [ Html.text user.name
            ]


userDropdown : User -> Html Msg
userDropdown user =
    [ option
        { label = "settings"
        , cmdKeys = ""
        , clickMsg = NewWindowClicked Settings
        , disabled = False
        }
    , option
        { label = "home"
        , cmdKeys = ""
        , clickMsg = NewWindowClicked Home
        , disabled = False
        }
    , divider
    , option
        { label = "log out"
        , cmdKeys = ""
        , clickMsg = LogoutClicked
        , disabled = False
        }
    ]
        |> dropdownView Taskbar.User


loginButton : Html Msg
loginButton =
    a
        [ class [ Button, Right ]
        , onClick LoginClicked
        ]
        [ Html.text "login" ]


invisibleWall : Maybe Dropdown -> Html Msg
invisibleWall maybeTaskbarDropdown =
    case maybeTaskbarDropdown of
        Just _ ->
            div
                [ class [ InvisibleWall ]
                , onClick DropdownClickedOut
                ]
                []

        Nothing ->
            Html.text ""


help : Maybe Dropdown -> Html Msg
help maybeHelp =
    case maybeHelp of
        Just Help ->
            [ option
                { label = "about"
                , cmdKeys = ""
                , clickMsg = AboutClicked
                , disabled = False
                }
            , option
                { label = "report bug"
                , cmdKeys = ""
                , clickMsg = ReportBugClicked
                , disabled = False
                }
            ]
                |> taskbarButtonOpen "help" Help

        _ ->
            taskbarButtonClose "help" Help



-- VIEW --


view_ : Model -> Html Msg
view_ model =
    case model.taskbarDropped of
        Just View ->
            [ option
                { label = "gallery view"
                , cmdKeys = keysLabel model SwitchGalleryView

                --, cmdKeys = "tab"
                , clickMsg = KeyCmdClicked SwitchGalleryView
                , disabled = False
                }
            , option
                { label = minimapLabel model
                , cmdKeys = keysLabel model ToggleMinimap
                , clickMsg = KeyCmdClicked ToggleMinimap
                , disabled = False
                }
            ]
                |> taskbarButtonOpen "view" View

        _ ->
            taskbarButtonClose "view" View


minimapLabel : Model -> String
minimapLabel model =
    case model.minimap of
        Opened _ ->
            "hide mini map"

        _ ->
            "show mini map"



-- TRANSFORM --


transform : Model -> Html Msg
transform model =
    case model.taskbarDropped of
        Just Transform ->
            transformOpen model

        _ ->
            taskbarButtonClose "transform" Transform


transformOpen : Model -> Html Msg
transformOpen model =
    [ option
        { label = "flip horizontal"
        , cmdKeys = keysLabel model FlipHorizontal
        , clickMsg = KeyCmdClicked FlipHorizontal
        , disabled = False
        }
    , option
        { label = "flip vertical"
        , cmdKeys = keysLabel model FlipVertical
        , clickMsg = KeyCmdClicked FlipVertical
        , disabled = False
        }
    , divider
    , option
        { label = "rotate 90"
        , cmdKeys = keysLabel model Rotate90
        , clickMsg = KeyCmdClicked Rotate90
        , disabled = False
        }
    , option
        { label = "rotate 180"
        , cmdKeys = keysLabel model Rotate180
        , clickMsg = KeyCmdClicked Rotate180
        , disabled = False
        }
    , option
        { label = "rotate 270"
        , cmdKeys = keysLabel model Rotate270
        , clickMsg = KeyCmdClicked Rotate270
        , disabled = False
        }
    , divider
    , option
        { label = "scale"
        , cmdKeys = keysLabel model InitScale
        , clickMsg = KeyCmdClicked InitScale
        , disabled = False
        }
    , option
        { label = "resize canvas"
        , cmdKeys = keysLabel model InitResize
        , clickMsg = KeyCmdClicked InitResize
        , disabled = False
        }
    , option
        { label = "replace color"
        , cmdKeys = keysLabel model InitReplaceColor
        , clickMsg = KeyCmdClicked InitReplaceColor
        , disabled = False
        }
    , option
        { label = "invert"
        , cmdKeys = keysLabel model InvertColors
        , clickMsg = KeyCmdClicked InvertColors
        , disabled = False
        }
    , divider
    , option
        { label = "text"
        , cmdKeys = keysLabel model InitText
        , clickMsg = KeyCmdClicked InitText
        , disabled = False
        }
    , option
        { label = "transparency"
        , cmdKeys = keysLabel model SetTransparency
        , clickMsg = KeyCmdClicked SetTransparency
        , disabled = model.selection == Nothing
        }
    ]
        |> taskbarButtonOpen "transform" Transform



-- COLORS --


colors : Model -> Html Msg
colors model =
    case model.taskbarDropped of
        Just Colors ->
            colorsDropped model

        _ ->
            taskbarButtonClose "colors" Colors


colorsDropped : Model -> Html Msg
colorsDropped model =
    [ option
        { label = "turn swatches left"
        , cmdKeys = keysLabel model SwatchesTurnLeft
        , clickMsg = KeyCmdClicked SwatchesTurnLeft
        , disabled = False
        }
    , option
        { label = "turn swatches right"
        , cmdKeys = keysLabel model SwatchesTurnRight
        , clickMsg = KeyCmdClicked SwatchesTurnRight
        , disabled = False
        }
    , divider
    , option
        { label = colorPickerLabel model
        , cmdKeys = keysLabel model ToggleColorPicker
        , clickMsg = KeyCmdClicked ToggleColorPicker
        , disabled = False
        }
    ]
        |> taskbarButtonOpen "colors" Colors


colorPickerLabel : Model -> String
colorPickerLabel model =
    if model.color.picker.window.show then
        "hide color picker"
    else
        "show color picker"



-- TOOLS --


tools : Model -> Html Msg
tools model =
    case model.taskbarDropped of
        Just Tools ->
            toolsDropped model

        _ ->
            taskbarButtonClose "tools" Tools


toolsDropped : Model -> Html Msg
toolsDropped model =
    [ option
        { label = "select"
        , cmdKeys = keysLabel model SetToolToSelect
        , clickMsg = KeyCmdClicked SetToolToSelect
        , disabled = False
        }
    , option
        { label = "zoom in"
        , cmdKeys = keysLabel model ZoomIn
        , clickMsg = ToolClicked Tool.ZoomIn
        , disabled = False
        }
    , option
        { label = "zoom out"
        , cmdKeys = keysLabel model ZoomOut
        , clickMsg = ToolClicked Tool.ZoomOut
        , disabled = False
        }
    , option
        { label = "hand"
        , cmdKeys = keysLabel model SetToolToHand
        , clickMsg = KeyCmdClicked SetToolToHand
        , disabled = False
        }
    , option
        { label = "sample"
        , cmdKeys = keysLabel model SetToolToSample
        , clickMsg = KeyCmdClicked SetToolToSample
        , disabled = False
        }
    , option
        { label = "fill"
        , cmdKeys = keysLabel model SetToolToFill
        , clickMsg = KeyCmdClicked SetToolToFill
        , disabled = False
        }
    , option
        { label = "eraser"
        , cmdKeys = keysLabel model SetToolToEraser
        , clickMsg = KeyCmdClicked SetToolToEraser
        , disabled = False
        }
    , option
        { label = "pencil"
        , cmdKeys = keysLabel model SetToolToPencil
        , clickMsg = KeyCmdClicked SetToolToPencil
        , disabled = False
        }
    , option
        { label = "line"
        , cmdKeys = keysLabel model SetToolToLine
        , clickMsg = KeyCmdClicked SetToolToLine
        , disabled = False
        }
    , option
        { label = "rectangle"
        , cmdKeys = keysLabel model SetToolToRectangle
        , clickMsg = KeyCmdClicked SetToolToRectangle
        , disabled = False
        }
    , option
        { label = "rectangle filled"
        , cmdKeys = keysLabel model SetToolToRectangleFilled
        , clickMsg = KeyCmdClicked SetToolToRectangleFilled
        , disabled = False
        }
    ]
        |> taskbarButtonOpen "tools" Tools



-- EDIT --


edit : Model -> Html Msg
edit model =
    case model.taskbarDropped of
        Just Edit ->
            editDropped model

        _ ->
            taskbarButtonClose "edit" Edit


editDropped : Model -> Html Msg
editDropped model =
    [ option
        { label = "undo"
        , cmdKeys = keysLabel model Undo
        , clickMsg = KeyCmdClicked Undo
        , disabled = False
        }
    , option
        { label = "redo"
        , cmdKeys = keysLabel model Redo
        , clickMsg = KeyCmdClicked Redo
        , disabled = False
        }
    , divider
    , option
        { label = "cut"
        , cmdKeys = keysLabel model Cut
        , clickMsg = KeyCmdClicked Cut
        , disabled = model.selection == Nothing
        }
    , option
        { label = "copy"
        , cmdKeys = keysLabel model Copy
        , clickMsg = KeyCmdClicked Copy
        , disabled = model.selection == Nothing
        }
    , option
        { label = "paste"
        , cmdKeys = keysLabel model Paste
        , clickMsg = KeyCmdClicked Paste
        , disabled = model.clipboard == Nothing
        }
    , divider
    , option
        { label = "select all"
        , cmdKeys = keysLabel model SelectAll
        , clickMsg = KeyCmdClicked SelectAll
        , disabled = False
        }
    , divider
    , option
        { label = "settings"
        , cmdKeys = ""
        , clickMsg = NewWindowClicked Settings
        , disabled = False
        }
    ]
        |> taskbarButtonOpen "edit" Edit



-- FILE --


file : Model -> Html Msg
file model =
    case model.taskbarDropped of
        Just File ->
            fileDropped model

        _ ->
            taskbarButtonClose "file" File


fileDropped : Model -> Html Msg
fileDropped model =
    [ option
        { label = "save"
        , cmdKeys = keysLabel model Save
        , clickMsg = KeyCmdClicked Save
        , disabled = not <| User.isLoggedIn model.taco.user
        }
    , option
        { label = "download"
        , cmdKeys = keysLabel model InitDownload
        , clickMsg = KeyCmdClicked InitDownload
        , disabled = False
        }
    , option
        { label = "upload"
        , cmdKeys = keysLabel model InitUpload
        , clickMsg = KeyCmdClicked InitUpload
        , disabled = False
        }
    , option
        { label = "import from url"
        , cmdKeys = keysLabel model InitImport
        , clickMsg = KeyCmdClicked InitImport
        , disabled = False
        }
    , divider
    , option
        { label = "drawing"
        , cmdKeys = ""
        , clickMsg = DrawingClicked
        , disabled = False
        }
    , option
        { label = "open image link"
        , cmdKeys = ""
        , clickMsg = OpenImageLinkClicked
        , disabled = not <| User.drawingLoaded model.taco.user
        }
    ]
        |> taskbarButtonOpen "file" File



-- HELPERS --


keysLabel : Model -> Key.Cmd -> String
keysLabel model =
    Helpers.Keys.getKeysLabel model.taco.config


taskbarButtonClose : String -> Dropdown -> Html Msg
taskbarButtonClose label dropdown =
    a
        [ class [ Button ]
        , onClick (DropdownClicked dropdown)
        , onMouseOver (HoveredOnto dropdown)
        ]
        [ Html.text label ]


taskbarButtonOpen : String -> Dropdown -> List (Html Msg) -> Html Msg
taskbarButtonOpen label dropdown children =
    a
        [ class [ Button, Dropped ]
        , onClick DropdownClickedOut
        ]
        [ Html.text label
        , seam
        , dropdownView dropdown children
        ]


dropdownView : Dropdown -> List (Html Msg) -> Html Msg
dropdownView dropdown =
    div [ class [ Options, Dropdown dropdown ] ]


divider : Html Msg
divider =
    div
        [ class [ Divider ] ]
        [ div [ class [ Strike ] ] [] ]


type alias OptionModel =
    { label : String
    , cmdKeys : String
    , clickMsg : Msg
    , disabled : Bool
    }


option : OptionModel -> Html Msg
option { label, cmdKeys, clickMsg, disabled } =
    div
        (optionAttrs disabled clickMsg)
        [ p_ label
        , p_ cmdKeys
        ]


optionAttrs : Bool -> Msg -> List (Attribute Msg)
optionAttrs disabled clickMsg =
    if disabled then
        [ class [ Option, Disabled ] ]
    else
        [ class [ Option ]
        , onClick clickMsg
        ]


seam : Html Msg
seam =
    div [ class [ Seam ] ] []


p_ : String -> Html Msg
p_ =
    Html.text >> List.singleton >> p []
