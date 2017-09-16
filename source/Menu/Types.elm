module Menu.Types exposing (Menu(..), Msg(..))

import Menu.Download.Types as Download
import Menu.Import.Types as Import
import Menu.Scale.Types as Scale
import Menu.Text.Types as Text


type Menu
    = None
    | Scale Scale.Model
    | Download Download.Model
    | Import Import.Model
    | Text Text.Model


type Msg
    = DownloadMsg Download.Msg
    | ImportMsg Import.Msg
    | ScaleMsg Scale.Msg
    | TextMsg Text.Msg
