module Menu.Types exposing (Menu(..))

import Menu.Download.Types as Download
import Menu.Import.Types as Import
import Menu.Scale.Types as Scale


type Menu
    = None
    | Scale Scale.Model
    | ReplaceColor
    | Preferences
    | Help
    | Download Download.Model
    | Import Import.Model
