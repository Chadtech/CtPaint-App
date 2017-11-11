port module Stylesheets exposing (..)

import ColorPicker
import Css.File exposing (CssCompilerProgram, CssFileStructure)
import Html.Custom
import Palette
import Taskbar
import Toolbar
import Tuple.Infix exposing ((:=))
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
    ]
        |> Css.File.compile
        |> (,) "./development/paint-app-styles-1.css"
        |> List.singleton
        |> Css.File.toFileStructure
        |> Css.File.compiler files
