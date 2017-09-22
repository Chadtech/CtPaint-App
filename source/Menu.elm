port module Menu exposing (..)

import Menu.Download.Types as Download
import Menu.Import.Types as Import
import Menu.Scale.Types as Scale
import Menu.Text.Types as Text


-- TYPES --


type Menu
    = None
    | Scale Scale.Model
    | Download Download.Model
    | Import Import.Model
    | Text Text.Model
    | About


type Msg
    = DownloadMsg Download.Msg
    | ImportMsg Import.Msg
    | ScaleMsg Scale.Msg
    | TextMsg Text.Msg
    | CloseAbout



-- PORTS --


port stealFocus : () -> Cmd msg


port returnFocus : () -> Cmd msg
