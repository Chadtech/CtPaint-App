module Helpers.Window exposing (openWindow)

import Data.Window as Window exposing (Window)
import Ports exposing (JsMsg(OpenNewWindow))


openWindow : String -> Window -> Cmd msg
openWindow mountPath window =
    window
        |> Window.toUrl mountPath
        |> OpenNewWindow
        |> Ports.send
