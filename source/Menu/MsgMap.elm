module Menu.MsgMap exposing (..)

import Menu.Download.Types as Download
import Menu.Import.Types as Import
import Menu.Scale.Types as Scale
import Menu.Text.Types as Text
import Menu.Types as Menu
import Msg as Msg


download : Download.Msg -> Msg.Msg
download =
    Menu.DownloadMsg >> Msg.MenuMsg


import_ : Import.Msg -> Msg.Msg
import_ =
    Menu.ImportMsg >> Msg.MenuMsg


scale : Scale.Msg -> Msg.Msg
scale =
    Menu.ScaleMsg >> Msg.MenuMsg


text : Text.Msg -> Msg.Msg
text =
    Menu.TextMsg >> Msg.MenuMsg
