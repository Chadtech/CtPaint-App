module Taskbar exposing (Msg(..), Option(..), css, view)

import Chadtech.Colors exposing (ignorable1, ignorable2, ignorable3, point)
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Data.Taskbar exposing (Dropdown(..))
import Dict exposing (Dict)
import Html exposing (Attribute, Html, a, div, p)
import Html.CssHelpers
import Html.Custom exposing (outdent)
import Html.Events exposing (onClick, onMouseOver)
import Tool exposing (Tool)
import Types
    exposing
        ( MinimapState(..)
        , Model
        , NewWindow(..)
        , Op(..)
        , QuickKey
        )
import Util exposing (toolbarWidth)


-- TYPES --


type Msg
    = OptionClickedOn Option
    | DropdownClickedOut
    | DropdownClicked Dropdown
    | HoveredOnto Dropdown


type Option
    = RunOp Op
    | OpenNewWindow NewWindow
    | SetTool Tool



-- STYLES --


type Class
    = Taskbar
    | InvisibleWall
    | Button
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
view ({ taskbarDropped } as model) =
    div
        [ class [ Taskbar ] ]
        [ file model
        , edit model
        , transform model
        , tools model
        , view_ model
        , help taskbarDropped
        , invisibleWall taskbarDropped
        ]


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
            [ option "About" "" (RunOp InitAbout)
            , option "Tutorial" "" (OpenNewWindow Tutorial)
            , option "Donate" "" (OpenNewWindow Donate)
            ]
                |> taskbarButtonOpen Help

        _ ->
            taskbarButtonClose Help



-- VIEW --


view_ : Model -> Html Msg
view_ model =
    case model.taskbarDropped of
        Just View ->
            [ option
                "Gallery view"
                "tab"
                (RunOp SwitchGalleryView)
            , option
                (minimapLabel model)
                (getOpStr model.config.quickKeys ToggleMinimap)
                (RunOp ToggleMinimap)
            , option
                "Color Picker"
                (getOpStr model.config.quickKeys ToggleColorPicker)
                (RunOp ToggleColorPicker)
            ]
                |> taskbarButtonOpen View

        _ ->
            taskbarButtonClose View


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
            taskbarButtonClose Transform


transformOpen : Model -> Html Msg
transformOpen model =
    [ option
        "Flip Horiztonal"
        (getOpStr model.config.quickKeys FlipHorizontal)
        (RunOp FlipHorizontal)
    , option
        "Flip Vertical"
        (getOpStr model.config.quickKeys FlipVertical)
        (RunOp FlipVertical)
    , divider
    , option
        "Rotate 90"
        (getOpStr model.config.quickKeys Rotate90)
        (RunOp Rotate90)
    , option
        "Rotate 180"
        (getOpStr model.config.quickKeys Rotate180)
        (RunOp Rotate180)
    , option
        "Rotate 270"
        (getOpStr model.config.quickKeys Rotate270)
        (RunOp Rotate270)
    , divider
    , option
        "Scale"
        (getOpStr model.config.quickKeys InitScale)
        (RunOp InitScale)
    , option
        "Replace Color"
        (getOpStr model.config.quickKeys InitReplaceColor)
        (RunOp InitReplaceColor)
    , option
        "Invert"
        (getOpStr model.config.quickKeys InvertColors)
        (RunOp InvertColors)
    , divider
    , option
        "Text"
        (getOpStr model.config.quickKeys InitText)
        (RunOp InitText)
    ]
        |> taskbarButtonOpen Transform



-- TOOLS --


tools : Model -> Html Msg
tools model =
    case model.taskbarDropped of
        Just Tools ->
            toolsDropped model

        _ ->
            taskbarButtonClose Tools


toolsDropped : Model -> Html Msg
toolsDropped model =
    [ option
        "Select"
        (getOpStr model.config.quickKeys SetToolToSelect)
        (RunOp SetToolToSelect)
    , option
        "Zoom In"
        (getOpStr model.config.quickKeys ZoomIn)
        (SetTool Tool.ZoomIn)
    , option
        "Zoom Out"
        (getOpStr model.config.quickKeys ZoomOut)
        (SetTool Tool.ZoomOut)
    , option
        "Hand"
        (getOpStr model.config.quickKeys SetToolToHand)
        (RunOp SetToolToHand)
    , option
        "Sample"
        (getOpStr model.config.quickKeys SetToolToSample)
        (RunOp SetToolToSample)
    , option
        "Fill"
        (getOpStr model.config.quickKeys SetToolToFill)
        (RunOp SetToolToFill)
    , option
        "Pencil"
        (getOpStr model.config.quickKeys SetToolToPencil)
        (RunOp SetToolToPencil)
    , option
        "Line"
        (getOpStr model.config.quickKeys SetToolToLine)
        (RunOp SetToolToLine)
    , option
        "Rectangle"
        (getOpStr model.config.quickKeys SetToolToRectangle)
        (RunOp SetToolToRectangle)
    , option
        "Rectangle Filled"
        (getOpStr model.config.quickKeys SetToolToRectangleFilled)
        (RunOp SetToolToRectangleFilled)
    ]
        |> taskbarButtonOpen Tools



-- EDIT --


edit : Model -> Html Msg
edit model =
    case model.taskbarDropped of
        Just Edit ->
            editDropped model

        _ ->
            taskbarButtonClose Edit


editDropped : Model -> Html Msg
editDropped model =
    [ option
        "Undo"
        (getOpStr model.config.quickKeys Undo)
        (RunOp Undo)
    , option
        "Redo"
        (getOpStr model.config.quickKeys Redo)
        (RunOp Redo)
    , divider
    , option
        "Cut"
        (getOpStr model.config.quickKeys Cut)
        (RunOp Cut)
    , option
        "Copy"
        (getOpStr model.config.quickKeys Copy)
        (RunOp Copy)
    , option
        "Paste"
        (getOpStr model.config.quickKeys Paste)
        (RunOp Paste)
    , divider
    , option
        "Select all"
        (getOpStr model.config.quickKeys SelectAll)
        (RunOp SelectAll)
    , divider
    , option
        "Preferences"
        ""
        (OpenNewWindow Preferences)
    ]
        |> taskbarButtonOpen Edit



-- FILE --


file : Model -> Html Msg
file model =
    case model.taskbarDropped of
        Just File ->
            fileDropped model

        _ ->
            taskbarButtonClose File


fileDropped : Model -> Html Msg
fileDropped model =
    [ option
        "Save"
        (getOpStr model.config.quickKeys Save)
        (RunOp Save)
    , option
        "Download"
        (getOpStr model.config.quickKeys InitDownload)
        (RunOp InitDownload)
    , option
        "Import"
        (getOpStr model.config.quickKeys InitImport)
        (RunOp InitImport)
    , divider
    , option "Imgur" "" (RunOp InitImgur)
    ]
        |> taskbarButtonOpen File



-- HELPERS --


getOpStr : Dict String String -> Op -> String
getOpStr cmdLookUp op =
    case Dict.get (toString op) cmdLookUp of
        Just keys ->
            keys

        Nothing ->
            ""


taskbarButtonClose : Dropdown -> Html Msg
taskbarButtonClose dropdown =
    a
        [ class [ Button ]
        , onClick (DropdownClicked dropdown)
        , onMouseOver (HoveredOnto dropdown)
        ]
        [ Html.text (toString option) ]


taskbarButtonOpen : Dropdown -> List (Html Msg) -> Html Msg
taskbarButtonOpen dropdown children =
    a
        [ class [ Button, Dropped ]
        , onClick DropdownClickedOut
        ]
        [ Html.text (toString dropdown)
        , seam
        , div
            [ class [ Options, Dropdown dropdown ] ]
            children
        ]


divider : Html Msg
divider =
    div
        [ class [ Divider ] ]
        [ div [ class [ Strike ] ] [] ]


option : String -> String -> Option -> Html Msg
option label cmdKeys option =
    div
        [ onClick (OptionClickedOn option)
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
