module Menu.MsgMap exposing (..)

import Menu.Download.Types as Download
import Menu.Import.Types as Import
import Menu.Scale.Types as Scale
import Menu.Text.Types as Text
import Menu.Types as Menu
import Types


download : Download.Msg -> Types.Msg
download =
    Menu.DownloadMsg >> Types.MenuMsg


import_ : Import.Msg -> Types.Msg
import_ =
    Menu.ImportMsg >> Types.MenuMsg


scale : Scale.Msg -> Types.Msg
scale =
    Menu.ScaleMsg >> Types.MenuMsg


text : Text.Msg -> Types.Msg
text =
    Menu.TextMsg >> Types.MenuMsg
