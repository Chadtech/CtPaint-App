module Taskbar.Util exposing (..)

import Taskbar.Types as Taskbar
import Taskbar.Download.Types as Download
import Main.Message as Main


download : Download.Message -> Main.Message
download =
    Taskbar.DownloadMessage >> Main.TaskbarMessage
