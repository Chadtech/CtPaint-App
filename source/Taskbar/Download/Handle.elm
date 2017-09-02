module Taskbar.Download.Handle exposing (handle)

import Main.Model exposing (Model)
import Main.Message as Main
import Taskbar.Download.Types as Download exposing (Message(..), ExternalMessage(..))
import Types.Menu exposing (Menu(..))
import Taskbar.Util as Taskbar


handle :
    Model
    -> ( Download.Model, ExternalMessage, Cmd Message )
    -> ( Model, Cmd Message )
handle model ( downloadModel, externalmessage, cmd ) =
    case externalmessage of
        DoNothing ->
            { model
                | menu = Download downloadModel
            }
                ! [ cmd ]

        Close ->
            { model
                | menu = None
            }
                ! [ cmd ]
