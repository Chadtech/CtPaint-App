module Types.Menu exposing (Menu(..))

import Transform.Types as Transform
import Taskbar.Download.Types as Download
import Taskbar.Import.Types as Import


type Menu
    = None
    | Transform Transform.Menu
    | Preferences
    | Help
    | Download Download.Model
    | Import Import.Model
