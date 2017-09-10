module Menu.Types exposing (Menu(..), Message(..))

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


type Message
    = DownloadMessage Download.Message
    | ImportMessage Import.Message
    | ScaleMessage Scale.Message
    | TextMessage Text.Message
