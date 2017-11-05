port module Stylesheets exposing (..)

import Css.File exposing (CssCompilerProgram, CssFileStructure)
import Styles
import Tuple.Infix exposing ((:=))


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    [ "./development/paint-app-styles-1.css" := Css.File.compile [ Styles.css ] ]
        |> Css.File.toFileStructure


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure
