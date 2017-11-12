module Taskbar exposing (Msg(..), css, update, view)

import Chadtech.Colors exposing (ignorable1, ignorable2, ignorable3, point)
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Data.Keys exposing (KeyCmd(..), QuickKey)
import Data.Taskbar exposing (Dropdown(..))
import Data.User exposing (User)
import Dict exposing (Dict)
import Html exposing (Attribute, Html, a, div, p)
import Html.CssHelpers
import Html.Custom exposing (outdent)
import Html.Events exposing (onClick, onMouseOver)
import Keys
import Menu
import Tool exposing (Tool)
import Tuple.Infix exposing ((&))
import Types
    exposing
        ( MinimapState(..)
        , Model
        , NewWindow(..)
        )
import Util exposing (toolbarWidth)


-- TYPES --


type Msg
    = DropdownClickedOut
    | DropdownClicked Dropdown
    | HoveredOnto Dropdown
    | LoginClicked
    | AboutClicked
    | KeyCmdClicked KeyCmd
    | NewWindowClicked NewWindow
    | ToolClicked Tool



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd msg )
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
                | menu = Just (Menu.initLogin model.windowSize)
            }
                & Cmd.none

        AboutClicked ->
            { model
                | menu = Just (Menu.initAbout model.windowSize)
            }
                & Cmd.none

        KeyCmdClicked keyCmd ->
            Keys.exec keyCmd model

        NewWindowClicked window ->
            model & Cmd.none

        ToolClicked tool ->
            { model | tool = tool } & Cmd.none



-- STYLES --


type Class
    = Taskbar
    | InvisibleWall
    | Button
    | LoginButton
    | Dropped
    | Divider
    | Strike
    | Option
    | Options
    | Seam
    | Dropdown Dropdown


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
        ]
    , Css.class LoginButton
        [ float right
        , marginRight (px 2)
        ]
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
        , width (px 300)
        , giveDropdownWidth (Dropdown Help) 110
        , giveDropdownWidth (Dropdown View) 200
        , giveDropdownWidth (Dropdown Edit) 220
        , giveDropdownWidth (Dropdown File) 220
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
        , width (px 292)
        , borderTop3 (px 2) solid ignorable3
        , borderBottom3 (px 2) solid ignorable1
        ]
    , Css.class Option
        [ height (px 32)
        , width (px 296)
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
    "Taskbar"



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
        , view_ model
        , help taskbarDropped
        , userButton user
        , invisibleWall taskbarDropped
        ]


userButton : Maybe User -> Html Msg
userButton maybeUser =
    case maybeUser of
        Just user ->
            userOptions user

        Nothing ->
            loginButton


userOptions : User -> Html Msg
userOptions user =
    a
        [ class [ Button ] ]
        [ Html.text user.name
        , Util.viewIf user.optionsIsOpen seam
        , Util.viewIf user.optionsIsOpen (userDropdown user)
        ]


userDropdown : User -> Html Msg
userDropdown user =
    []
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
                (getKeyCmdStr model.config.quickKeys ToggleMinimap)
                (KeyCmdClicked ToggleMinimap)
            , option
                "Color Picker"
                (getKeyCmdStr model.config.quickKeys ToggleColorPicker)
                (KeyCmdClicked ToggleColorPicker)
            ]
                |> taskbarButtonOpen "view" View

        _ ->
            taskbarButtonClose "view" View


minimapLabel : Model -> String
minimapLabel model =
    case model.minimap of
        Minimap _ ->
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
        (getKeyCmdStr model.config.quickKeys FlipHorizontal)
        (KeyCmdClicked FlipHorizontal)
    , option
        "Flip Vertical"
        (getKeyCmdStr model.config.quickKeys FlipVertical)
        (KeyCmdClicked FlipVertical)
    , divider
    , option
        "Rotate 90"
        (getKeyCmdStr model.config.quickKeys Rotate90)
        (KeyCmdClicked Rotate90)
    , option
        "Rotate 180"
        (getKeyCmdStr model.config.quickKeys Rotate180)
        (KeyCmdClicked Rotate180)
    , option
        "Rotate 270"
        (getKeyCmdStr model.config.quickKeys Rotate270)
        (KeyCmdClicked Rotate270)
    , divider
    , option
        "Scale"
        (getKeyCmdStr model.config.quickKeys InitScale)
        (KeyCmdClicked InitScale)
    , option
        "Replace Color"
        (getKeyCmdStr model.config.quickKeys InitReplaceColor)
        (KeyCmdClicked InitReplaceColor)
    , option
        "Invert"
        (getKeyCmdStr model.config.quickKeys InvertColors)
        (KeyCmdClicked InvertColors)
    , divider
    , option
        "Text"
        (getKeyCmdStr model.config.quickKeys InitText)
        (KeyCmdClicked InitText)
    ]
        |> taskbarButtonOpen "transform" Transform



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
        (getKeyCmdStr model.config.quickKeys SetToolToSelect)
        (KeyCmdClicked SetToolToSelect)
    , option
        "Zoom In"
        (getKeyCmdStr model.config.quickKeys ZoomIn)
        (ToolClicked Tool.ZoomIn)
    , option
        "Zoom Out"
        (getKeyCmdStr model.config.quickKeys ZoomOut)
        (ToolClicked Tool.ZoomOut)
    , option
        "Hand"
        (getKeyCmdStr model.config.quickKeys SetToolToHand)
        (KeyCmdClicked SetToolToHand)
    , option
        "Sample"
        (getKeyCmdStr model.config.quickKeys SetToolToSample)
        (KeyCmdClicked SetToolToSample)
    , option
        "Fill"
        (getKeyCmdStr model.config.quickKeys SetToolToFill)
        (KeyCmdClicked SetToolToFill)
    , option
        "Pencil"
        (getKeyCmdStr model.config.quickKeys SetToolToPencil)
        (KeyCmdClicked SetToolToPencil)
    , option
        "Line"
        (getKeyCmdStr model.config.quickKeys SetToolToLine)
        (KeyCmdClicked SetToolToLine)
    , option
        "Rectangle"
        (getKeyCmdStr model.config.quickKeys SetToolToRectangle)
        (KeyCmdClicked SetToolToRectangle)
    , option
        "Rectangle Filled"
        (getKeyCmdStr model.config.quickKeys SetToolToRectangleFilled)
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
        (getKeyCmdStr model.config.quickKeys Undo)
        (KeyCmdClicked Undo)
    , option
        "Redo"
        (getKeyCmdStr model.config.quickKeys Redo)
        (KeyCmdClicked Redo)
    , divider
    , option
        "Cut"
        (getKeyCmdStr model.config.quickKeys Cut)
        (KeyCmdClicked Cut)
    , option
        "Copy"
        (getKeyCmdStr model.config.quickKeys Copy)
        (KeyCmdClicked Copy)
    , option
        "Paste"
        (getKeyCmdStr model.config.quickKeys Paste)
        (KeyCmdClicked Paste)
    , divider
    , option
        "Select all"
        (getKeyCmdStr model.config.quickKeys SelectAll)
        (KeyCmdClicked SelectAll)
    , divider
    , option
        "Preferences"
        ""
        (NewWindowClicked Preferences)
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
        (getKeyCmdStr model.config.quickKeys Save)
        (KeyCmdClicked Save)
    , option
        "Download"
        (getKeyCmdStr model.config.quickKeys InitDownload)
        (KeyCmdClicked InitDownload)
    , option
        "Import"
        (getKeyCmdStr model.config.quickKeys InitImport)
        (KeyCmdClicked InitImport)
    , divider
    , option "Imgur" "" (KeyCmdClicked InitImgur)
    ]
        |> taskbarButtonOpen "file" File



-- HELPERS --


getKeyCmdStr : Dict String String -> KeyCmd -> String
getKeyCmdStr cmdLookUp op =
    case Dict.get (toString op) cmdLookUp of
        Just keys ->
            keys

        Nothing ->
            ""


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
