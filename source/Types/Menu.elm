module Types.Menu exposing (Menu(..))

import Transform.Types as Transform


type Menu
    = Transform Transform.Menu
    | Preferences
    | Help
    | Download
