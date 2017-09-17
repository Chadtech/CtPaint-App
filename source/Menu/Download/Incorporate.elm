module Menu.Download.Incorporate exposing (incorporate)

import Menu exposing (Menu(..))
import Menu.Download.Ports as Ports
import Menu.Download.Types as Download exposing (ExternalMsg(..), Msg(..))
import Types exposing (Model)
import Util exposing ((&))


incorporate : Model -> ( Download.Model, ExternalMsg ) -> ( Model, Cmd Msg )
incorporate model ( downloadModel, externalmessage ) =
    case externalmessage of
        DoNothing ->
            { model
                | menu = Download downloadModel
            }
                & Cmd.none

        DownloadFile fileName ->
            { model
                | menu = None
            }
                & Ports.download (fileName ++ ".png")

        Close ->
            { model | menu = None } & Menu.returnFocus ()
