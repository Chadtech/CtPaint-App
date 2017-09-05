module Types.Menu exposing (Menu(..))

import Taskbar.Download.Types as Download
import Taskbar.Import.Types as Import
import Transform.Types as Transform


type Menu
    = None
    | Transform Transform.Menu
    | Preferences
    | Help
    | Download Download.Model
    | Import Import.Model
