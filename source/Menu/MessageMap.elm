module Menu.MessageMap exposing (..)

import Main.Message as Main
import Menu.Download.Types as Download
import Menu.Import.Types as Import
import Menu.Scale.Types as Scale
import Menu.Types as Menu


download : Download.Message -> Main.Message
download =
    Menu.DownloadMessage >> Main.MenuMessage


import_ : Import.Message -> Main.Message
import_ =
    Menu.ImportMessage >> Main.MenuMessage


scale : Scale.Message -> Main.Message
scale =
    Menu.ScaleMessage >> Main.MenuMessage
