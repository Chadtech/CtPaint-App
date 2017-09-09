module Taskbar.Util exposing (..)

import Main.Message as Main
import Menu.Download.Types as Download
import Menu.Import.Types as Import
import Menu.Scale.Types as Scale
import Taskbar.Types as Taskbar


download : Download.Message -> Main.Message
download =
    Taskbar.DownloadMessage >> Main.TaskbarMessage


import_ : Import.Message -> Main.Message
import_ =
    Taskbar.ImportMessage >> Main.TaskbarMessage


scale : Scale.Message -> Main.Message
scale =
    Taskbar.ScaleMessage >> Main.TaskbarMessage
