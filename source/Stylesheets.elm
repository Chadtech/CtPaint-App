port module Stylesheets exposing (..)

import Color.Palette.View as Palette
import Color.Picker.View as Picker
import Color.Swatches.View as Swatches
import Css.File exposing (CssCompilerProgram, CssFileStructure)
import Error
import Html.Custom
import Menu.About as About
import Menu.BugReport as BugReport
import Menu.Drawing as Drawing
import Menu.Import as Import
import Menu.Loaded as Loaded
import Menu.Loading as Loading
import Menu.Login as Login
import Menu.Logout as Logout
import Menu.New as New
import Menu.ReplaceColor as ReplaceColor
import Menu.Resize as Resize
import Menu.Save as Save
import Menu.Scale as Scale
import Menu.Text as Text
import Menu.Upload as Upload
import Menu.View as Menu
import Minimap.View as Minimap
import Taskbar.View as Taskbar
import Tool.Eraser.View as Eraser
import Toolbar
import View


port files : CssFileStructure -> Cmd msg


main : CssCompilerProgram
main =
    [ Html.Custom.css
    , View.css
    , Toolbar.css
    , Taskbar.css
    , Palette.css
    , Swatches.css
    , Picker.css
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
    , Eraser.css
    , About.css
    , BugReport.css
    , Loaded.css
    , Save.css
    , New.css
    ]
        |> Css.File.compile
        |> (,) "./development/paint-app-styles.css"
        |> List.singleton
        |> Css.File.toFileStructure
        |> Css.File.compiler files
