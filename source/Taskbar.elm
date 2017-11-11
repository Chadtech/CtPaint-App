module Taskbar exposing (css, view)

import Chadtech.Colors exposing (ignorable1, ignorable2, ignorable3, point)
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Data.Taskbar exposing (DropDown(..))
import Dict exposing (Dict)
import Html exposing (Attribute, Html, a, div, p)
import Html.CssHelpers
import Html.Custom exposing (outdent)
import Html.Events exposing (onClick, onMouseOver)
import Tool
import Types
    exposing
        ( Command(..)
        , MinimapState(..)
        , Model
        , Msg(..)
        , NewWindow(..)
        , QuickKey
        )
import Util exposing (toolbarWidth)


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
    | DropDown DropDown


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
        , giveDropdownWidth (DropDown Help) 110
        , giveDropdownWidth (DropDown View) 200
        , giveDropdownWidth (DropDown Edit) 220
        , giveDropdownWidth (DropDown File) 220
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


invisibleWall : Maybe DropDown -> Html Msg
invisibleWall maybeTaskbarDropDown =
    case maybeTaskbarDropDown of
        Just _ ->
            div
                [ class [ InvisibleWall ]
                , onClick DropDownClickedOut
                ]
                []

        Nothing ->
            Html.text ""


help : Maybe DropDown -> Html Msg
help maybeHelp =
    case maybeHelp of
        Just Help ->
            [ option "About" "" (Command InitAbout)
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
                (Command SwitchGalleryView)
            , option
                (minimapLabel model)
                (getCmdStr model.quickKeys ToggleMinimap)
                (Command ToggleMinimap)
            , option
                "Color Picker"
                (getCmdStr model.quickKeys ToggleColorPicker)
                (Command ToggleColorPicker)
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
        (getCmdStr model.quickKeys FlipHorizontal)
        (Command FlipHorizontal)
    , option
        "Flip Vertical"
        (getCmdStr model.quickKeys FlipVertical)
        (Command FlipVertical)
    , divider
    , option
        "Rotate 90"
        (getCmdStr model.quickKeys Rotate90)
        (Command Rotate90)
    , option
        "Rotate 180"
        (getCmdStr model.quickKeys Rotate180)
        (Command Rotate180)
    , option
        "Rotate 270"
        (getCmdStr model.quickKeys Rotate270)
        (Command Rotate270)
    , divider
    , option
        "Scale"
        (getCmdStr model.quickKeys InitScale)
        (Command InitScale)
    , option
        "Replace Color"
        (getCmdStr model.quickKeys InitReplaceColor)
        (Command InitReplaceColor)
    , option
        "Invert"
        (getCmdStr model.quickKeys InvertColors)
        (Command InvertColors)
    , divider
    , option
        "Text"
        (getCmdStr model.quickKeys InitText)
        (Command InitText)
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
        (getCmdStr model.quickKeys SetToolToSelect)
        (Command SetToolToSelect)
    , option
        "Zoom In"
        (getCmdStr model.quickKeys ZoomIn)
        (SetTool Tool.ZoomIn)
    , option
        "Zoom Out"
        (getCmdStr model.quickKeys ZoomOut)
        (SetTool Tool.ZoomOut)
    , option
        "Hand"
        (getCmdStr model.quickKeys SetToolToHand)
        (Command SetToolToHand)
    , option
        "Sample"
        (getCmdStr model.quickKeys SetToolToSample)
        (Command SetToolToSample)
    , option
        "Fill"
        (getCmdStr model.quickKeys SetToolToFill)
        (Command SetToolToFill)
    , option
        "Pencil"
        (getCmdStr model.quickKeys SetToolToPencil)
        (Command SetToolToPencil)
    , option
        "Line"
        (getCmdStr model.quickKeys SetToolToLine)
        (Command SetToolToLine)
    , option
        "Rectangle"
        (getCmdStr model.quickKeys SetToolToRectangle)
        (Command SetToolToRectangle)
    , option
        "Rectangle Filled"
        (getCmdStr model.quickKeys SetToolToRectangleFilled)
        (Command SetToolToRectangleFilled)
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
        (getCmdStr model.quickKeys Undo)
        (Command Undo)
    , option
        "Redo"
        (getCmdStr model.quickKeys Redo)
        (Command Redo)
    , divider
    , option
        "Cut"
        (getCmdStr model.quickKeys Cut)
        (Command Cut)
    , option
        "Copy"
        (getCmdStr model.quickKeys Copy)
        (Command Copy)
    , option
        "Paste"
        (getCmdStr model.quickKeys Paste)
        (Command Paste)
    , divider
    , option
        "Select all"
        (getCmdStr model.quickKeys SelectAll)
        (Command SelectAll)
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
        (getCmdStr model.quickKeys Save)
        (Command Save)
    , option
        "Download"
        (getCmdStr model.quickKeys InitDownload)
        (Command InitDownload)
    , option
        "Import"
        (getCmdStr model.quickKeys InitImport)
        (Command InitImport)
    , divider
    , option "Imgur" "" InitImgur
    ]
        |> taskbarButtonOpen File



-- HELPERS --


getCmdStr : Dict String String -> Command -> String
getCmdStr cmdLookUp cmd =
    case Dict.get (toString cmd) cmdLookUp of
        Just keys ->
            keys

        Nothing ->
            ""


taskbarButtonClose : DropDown -> Html Msg
taskbarButtonClose option =
    a
        [ class [ Button ]
        , onClick (DropDownClicked option)
        , onMouseOver (HoverOnto option)
        ]
        [ Html.text (toString option) ]


taskbarButtonOpen : DropDown -> List (Html Msg) -> Html Msg
taskbarButtonOpen dropdown children =
    a
        [ class [ Button, Dropped ]
        , onClick DropDownClickedOut
        ]
        [ Html.text (toString dropdown)
        , seam
        , div
            [ class [ Options, DropDown dropdown ] ]
            children
        ]


divider : Html Msg
divider =
    div
        [ class [ Divider ] ]
        [ div [ class [ Strike ] ] [] ]


option : String -> String -> Msg -> Html Msg
option label cmdKeys message =
    div
        [ onClick message
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
