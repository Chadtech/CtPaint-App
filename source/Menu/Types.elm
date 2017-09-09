module Menu.Types exposing (Menu(..))

import Menu.Download.Types as Download
import Menu.Import.Types as Import


type Menu
    = None
    | Scale
    | ReplaceColor
    | Preferences
    | Help
    | Download Download.Model
    | Import Import.Model
