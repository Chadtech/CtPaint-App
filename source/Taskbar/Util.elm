module Taskbar.Util exposing (..)

import Taskbar.Types as Taskbar
import Taskbar.Download.Types as Download
import Taskbar.Import.Types as Import
import Main.Message as Main


download : Download.Message -> Main.Message
download =
    Taskbar.DownloadMessage >> Main.TaskbarMessage


import_ : Import.Message -> Main.Message
import_ =
    Taskbar.ImportMessage >> Main.TaskbarMessage
