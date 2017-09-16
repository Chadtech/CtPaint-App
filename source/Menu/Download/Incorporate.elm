module Menu.Download.Incorporate exposing (incorporate)

import Menu.Download.Ports as Ports
import Menu.Download.Types as Download exposing (ExternalMsg(..), Msg(..))
import Menu.Ports as Ports
import Menu.Types exposing (Menu(..))
import Types exposing (Model)


incorporate : Model -> ( Download.Model, ExternalMsg ) -> ( Model, Cmd Msg )
incorporate model ( downloadModel, externalmessage ) =
    case externalmessage of
        DoNothing ->
            { model
                | menu = Download downloadModel
            }
                ! []

        DownloadFile fileName ->
            { model
                | menu = None
            }
                ! [ Ports.download (fileName ++ ".png") ]

        Close ->
            { model | menu = None } ! [ Ports.returnFocus () ]
