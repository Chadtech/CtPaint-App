module Taskbar exposing (Msg(..), css, update, view)

import Chadtech.Colors exposing (ignorable1, ignorable2, ignorable3, point)
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
                & Ports.send StealFocus

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
        [ backgroundColor ignorable2
        , height (px toolbarWidth)
        , width (calc (pct 100) minus (px toolbarWidth))
        , left (px toolbarWidth)
        , top (px 0)
        , position absolute
        , borderBottom3 (px 1) solid ignorable3
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
        , withClass Dropped [ zIndex (int 3) ]
        , active outdent
        , marginRight (px 1)
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
        [ backgroundColor ignorable3 ]
    , Css.class Seam
        [ backgroundColor ignorable2
        , height (px 2)
        , left (px 0)
        , zIndex (int 4)
        , width (calc (pct 100) plus (px 2))
        , position absolute
        ]
    , (Css.class Options << List.append outdent)
        [ position absolute
        , left (px -2)
        , backgroundColor ignorable2
        , width (px 340)
        , giveDropdownWidth (Dropdown Help) 110
        , giveDropdownWidth (Dropdown View) 200
        , giveDropdownWidth (Dropdown Edit) 220
        , giveDropdownWidth (Dropdown File) 220
        , giveDropdownWidth (Dropdown Tools) 300
        , hover [ color point ]
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
        , borderTop3 (px 2) solid ignorable3
        , borderBottom3 (px 2) solid ignorable1
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
            [ backgroundColor point
            , children
                [ Css.Elements.p
                    [ color ignorable3 ]
                ]
            ]
        , Css.withClass Disabled
            []
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
            [ class [ Button, UserButton ]
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
    [ option "preferences" "" (NewWindowClicked Settings)
    , option "home" "" (NewWindowClicked Home)
    , divider
    , option "log out" "" LogoutClicked
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
            [ option "About" "" AboutClicked
            , option "Tutorial" "" (NewWindowClicked Tutorial)
            , option "Donate" "" (NewWindowClicked Donate)
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
                "Gallery view"
                "tab"
                (KeyCmdClicked SwitchGalleryView)
            , option
                (minimapLabel model)
                (keysLabel model ToggleMinimap)
                (KeyCmdClicked ToggleMinimap)
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
        "Flip Horiztonal"
        (keysLabel model FlipHorizontal)
        (KeyCmdClicked FlipHorizontal)
    , option
        "Flip Vertical"
        (keysLabel model FlipVertical)
        (KeyCmdClicked FlipVertical)
    , divider
    , option
        "Rotate 90"
        (keysLabel model Rotate90)
        (KeyCmdClicked Rotate90)
    , option
        "Rotate 180"
        (keysLabel model Rotate180)
        (KeyCmdClicked Rotate180)
    , option
        "Rotate 270"
        (keysLabel model Rotate270)
        (KeyCmdClicked Rotate270)
    , divider
    , option
        "Scale"
        (keysLabel model InitScale)
        (KeyCmdClicked InitScale)
    , option
        "Resize Canvas"
        (keysLabel model InitResize)
        (KeyCmdClicked InitResize)
    , option
        "Replace Color"
        (keysLabel model InitReplaceColor)
        (KeyCmdClicked InitReplaceColor)
    , option
        "Invert"
        (keysLabel model InvertColors)
        (KeyCmdClicked InvertColors)
    , divider
    , option
        "Text"
        (keysLabel model InitText)
        (KeyCmdClicked InitText)
    , optionIf
        (model.selection /= Nothing)
        "Transparency"
        (keysLabel model SetTransparency)
        (KeyCmdClicked SetTransparency)
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
        "Turn Swatches Left"
        (keysLabel model SwatchesTurnLeft)
        (KeyCmdClicked SwatchesTurnLeft)
    , option
        "Turn Swatches Right"
        (keysLabel model SwatchesTurnRight)
        (KeyCmdClicked SwatchesTurnRight)
    , divider
    , option
        (colorPickerLabel model)
        (keysLabel model ToggleColorPicker)
        (KeyCmdClicked ToggleColorPicker)
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
        "Select"
        (keysLabel model SetToolToSelect)
        (KeyCmdClicked SetToolToSelect)
    , option
        "Zoom In"
        (keysLabel model ZoomIn)
        (ToolClicked Tool.ZoomIn)
    , option
        "Zoom Out"
        (keysLabel model ZoomOut)
        (ToolClicked Tool.ZoomOut)
    , option
        "Hand"
        (keysLabel model SetToolToHand)
        (KeyCmdClicked SetToolToHand)
    , option
        "Sample"
        (keysLabel model SetToolToSample)
        (KeyCmdClicked SetToolToSample)
    , option
        "Fill"
        (keysLabel model SetToolToFill)
        (KeyCmdClicked SetToolToFill)
    , option
        "Pencil"
        (keysLabel model SetToolToPencil)
        (KeyCmdClicked SetToolToPencil)
    , option
        "Line"
        (keysLabel model SetToolToLine)
        (KeyCmdClicked SetToolToLine)
    , option
        "Rectangle"
        (keysLabel model SetToolToRectangle)
        (KeyCmdClicked SetToolToRectangle)
    , option
        "Rectangle Filled"
        (keysLabel model SetToolToRectangleFilled)
        (KeyCmdClicked SetToolToRectangleFilled)
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
        "Undo"
        (keysLabel model Undo)
        (KeyCmdClicked Undo)
    , option
        "Redo"
        (keysLabel model Redo)
        (KeyCmdClicked Redo)
    , divider
    , option
        "Cut"
        (keysLabel model Cut)
        (KeyCmdClicked Cut)
    , option
        "Copy"
        (keysLabel model Copy)
        (KeyCmdClicked Copy)
    , option
        "Paste"
        (keysLabel model Paste)
        (KeyCmdClicked Paste)
    , divider
    , option
        "Select all"
        (keysLabel model SelectAll)
        (KeyCmdClicked SelectAll)
    , divider
    , option
        "Settings"
        ""
        (NewWindowClicked Settings)
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
        "Save"
        (keysLabel model Save)
        (KeyCmdClicked Save)
    , option
        "Download"
        (keysLabel model InitDownload)
        (KeyCmdClicked InitDownload)
    , option
        "Upload"
        (keysLabel model InitUpload)
        (KeyCmdClicked InitUpload)
    , option
        "Import"
        (keysLabel model InitImport)
        (KeyCmdClicked InitImport)
    ]
        |> mixinProjectOption model
        |> taskbarButtonOpen "file" File


mixinProjectOption : Model -> List (Html Msg) -> List (Html Msg)
mixinProjectOption model children =
    case model.project of
        Just project ->
            children ++ projectOption project

        Nothing ->
            children


projectOption : Project -> List (Html Msg)
projectOption project =
    [ divider
    , option
        "Project"
        ""
        (ProjectClicked project)
    ]



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


optionIf : Bool -> String -> String -> Msg -> Html Msg
optionIf condition label cmdKeys clickListener =
    if condition then
        option label cmdKeys clickListener
    else
        disabledOption label cmdKeys


disabledOption : String -> String -> Html Msg
disabledOption label cmdKeys =
    div
        [ class [ Option, Disabled ] ]
        [ p_ label
        , p_ cmdKeys
        ]


option : String -> String -> Msg -> Html Msg
option label cmdKeys clickListener =
    div
        [ onClick clickListener
        , class [ Option ]
        ]
        [ p_ label
        , p_ cmdKeys
        ]


seam : Html Msg
seam =
    div [ class [ Seam ] ] []


p_ : String -> Html Msg
p_ =
    Html.text >> List.singleton >> p []
