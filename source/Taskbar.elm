module Taskbar exposing (Msg(..), css, update, view)

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Data.Keys as Key exposing (Cmd(..), QuickKey)
import Data.Minimap exposing (State(..))
import Data.Project exposing (Project)
import Data.Taskbar exposing (Dropdown(..))
import Data.Tool as Tool exposing (Tool)
import Data.User as User exposing (User)
import Data.Window exposing (Window(..))
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
import Ports exposing (JsMsg(Logout, OpenUpFileUpload, StealFocus))
import Tuple.Infix exposing ((&))
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
    | ProjectClicked Project



-- UPDATE --


update : Msg -> Model -> ( Model, Platform.Cmd msg )
update msg model =
    case msg of
        DropdownClickedOut ->
            { model
                | taskbarDropped = Nothing
            }
                & Cmd.none

        DropdownClicked dropdown ->
            { model
                | taskbarDropped = Just dropdown
            }
                & Cmd.none

        HoveredOnto dropdown ->
            case model.taskbarDropped of
                Nothing ->
                    model & Cmd.none

                Just currentDropdown ->
                    if currentDropdown == dropdown then
                        model & Cmd.none
                    else
                        { model
                            | taskbarDropped = Just dropdown
                        }
                            & Cmd.none

        LoginClicked ->
            { model
                | menu =
                    model.windowSize
                        |> Menu.initLogin
                        |> Just
            }
                & Ports.stealFocus

        UserClicked ->
            case model.user of
                User.LoggedIn user ->
                    { model
                        | user =
                            User.toggleOptionsDropped user
                                |> User.LoggedIn
                    }
                        & Cmd.none

                _ ->
                    model & Cmd.none

        LogoutClicked ->
            { model | user = User.LoggingOut }
                & Ports.send Logout

        AboutClicked ->
            { model
                | menu =
                    model.windowSize
                        |> Menu.initAbout
                            model.config.buildNumber
                        |> Just
            }
                & Cmd.none

        ReportBugClicked ->
            { model
                | menu =
                    model.windowSize
                        |> Menu.initBugReport
                        |> Just
            }
                & Ports.stealFocus

        KeyCmdClicked keyCmd ->
            Keys.exec keyCmd model

        NewWindowClicked window ->
            model & Cmd.none

        UploadClicked ->
            model & Ports.send OpenUpFileUpload

        ToolClicked tool ->
            { model | tool = tool } & Cmd.none

        ProjectClicked project ->
            { model
                | menu =
                    Menu.initProject
                        project
                        model.windowSize
                        |> Just
            }
                & Cmd.none



-- STYLES --


type Class
    = Taskbar
    | InvisibleWall
    | Button
    | LoginButton
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
        , marginRight (px 1)
        , border3 (px 2) solid Ct.ignorable2
        ]
    , Css.class LoginButton
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
        , giveDropdownWidth (Dropdown File) 220
        , giveDropdownWidth (Dropdown Tools) 300
        , giveDropdownWidth (Dropdown Data.Taskbar.User) 150
        , hover [ color Ct.point0 ]
        , padding (px 4)
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
                [ width (px (dropdownWidth - 6)) ]
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
view ({ taskbarDropped, user } as model) =
    div
        [ class [ Taskbar ] ]
        [ file model
        , edit model
        , transform model
        , tools model
        , colors model
        , view_ model
        , help taskbarDropped
        , userButton user
        , invisibleWall taskbarDropped
        ]


userButton : User.Model -> Html Msg
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
        [ class [ Button, UserButton, Null ] ]
        [ Html.text "offline" ]


userOptions : User -> Html Msg
userOptions user =
    if user.optionsDropped then
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
        |> dropdownView Data.Taskbar.User


loginButton : Html Msg
loginButton =
    a
        [ class [ Button, LoginButton ]
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
                , cmdKeys = "tab"
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
            "Hide Mini Map"

        _ ->
            "Show Mini Map"



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
        "Hide Color Picker"
    else
        "Show Color Picker"



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
        , disabled = False
        }
    , option
        { label = "copy"
        , cmdKeys = keysLabel model Copy
        , clickMsg = KeyCmdClicked Copy
        , disabled = False
        }
    , option
        { label = "paste"
        , cmdKeys = keysLabel model Paste
        , clickMsg = KeyCmdClicked Paste
        , disabled = False
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
        , disabled = not <| User.isLoggedIn model.user
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
        { label = "import"
        , cmdKeys = keysLabel model InitImport
        , clickMsg = KeyCmdClicked InitImport
        , disabled = False
        }
    , divider
    , option
        { label = "project"
        , cmdKeys = ""
        , clickMsg = ProjectClicked model.project
        , disabled = False
        }
    ]
        |> taskbarButtonOpen "file" File



-- HELPERS --


keysLabel : Model -> Key.Cmd -> String
keysLabel model =
    Helpers.Keys.getKeysLabel model.config


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
