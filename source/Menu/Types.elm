module Menu.Types exposing (Menu(..))

import Taskbar.Download.Types as Download
import Taskbar.Import.Types as Import


type Menu
    = None
    | Scale
    | ReplaceColor
    | Preferences
    | Help
    | Download Download.Model
    | Import Import.Model
