module Menu.Update exposing (update)

import Menu.Download.Incorporate as Download
import Menu.Download.Update as Download
import Menu.Import.Incorporate as Import
import Menu.Import.Update as Import
import Menu.Scale.Incorporate as Scale
import Menu.Scale.Update as Scale
import Menu.Text.Incorporate as Text
import Menu.Text.Update as Text
import Menu.Types exposing (Menu(..), Msg(..))
import Model exposing (Model)


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case ( message, model.menu ) of
        ( DownloadMsg subMsg, Download subModel ) ->
            subModel
                |> Download.update subMsg
                |> Download.incorporate model
                |> Tuple.mapSecond (Cmd.map DownloadMsg)

        ( ImportMsg subMsg, Import subModel ) ->
            subModel
                |> Import.update subMsg
                |> Import.incorporate model
                |> Tuple.mapSecond (Cmd.map ImportMsg)

        ( ScaleMsg subMsg, Scale subModel ) ->
            subModel
                |> Scale.update subMsg
                |> Scale.incorporate model
                |> Tuple.mapSecond (Cmd.map ScaleMsg)

        ( TextMsg subMsg, Text subModel ) ->
            subModel
                |> Text.update subMsg
                |> Text.incorporate model
                |> Tuple.mapSecond (Cmd.map TextMsg)

        _ ->
            model ! []
