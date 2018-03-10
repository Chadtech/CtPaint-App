port module Stylesheets exposing (..)

import About
import BugReport
import ColorPicker
import Css.File exposing (CssCompilerProgram, CssFileStructure)
import Drawing
import Eraser
import Error
import Html.Custom
import Import
import Loading
import Login
import Logout
import Menu
import Minimap
import New
import Open
import Palette
import ReplaceColor
import Resize
import Save
import Scale
import Taskbar
import Text
import Toolbar
import Upload
import View


port files : CssFileStructure -> Cmd msg


main : CssCompilerProgram
main =
    [ Html.Custom.css
    , View.css
    , Toolbar.css
    , Taskbar.css
    , Palette.css
    , ColorPicker.css
    , Error.css
    , Loading.css
    , Logout.css
    , Upload.css
    , Login.css
    , Resize.css
    , Drawing.css
    , Loading.css
    , Minimap.css
    , Menu.css
    , ReplaceColor.css
    , Import.css
    , Scale.css
    , Text.css
    , Open.css
    , Eraser.css
    , About.css
    , BugReport.css
    , Save.css
    , New.css
    ]
        |> Css.File.compile
        |> (,) "./development/paint-app-styles.css"
        |> List.singleton
        |> Css.File.toFileStructure
        |> Css.File.compiler files
