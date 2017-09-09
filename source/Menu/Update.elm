module Menu.Update exposing (update)

import Main.Model exposing (Model)
import Menu.Download.Incorporate as Download
import Menu.Download.Update as Download
import Menu.Import.Incorporate as Import
import Menu.Import.Update as Import
import Menu.Scale.Incorporate as Scale
import Menu.Scale.Update as Scale
import Menu.Types exposing (Menu(..), Message(..))


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case ( message, model.menu ) of
        ( DownloadMessage subMsg, Download subModel ) ->
            subModel
                |> Download.update subMsg
                |> Download.incorporate model
                |> Tuple.mapSecond (Cmd.map DownloadMessage)

        ( ImportMessage subMsg, Import subModel ) ->
            subModel
                |> Import.update subMsg
                |> Import.incorporate model
                |> Tuple.mapSecond (Cmd.map ImportMessage)

        ( ScaleMessage subMsg, Scale subModel ) ->
            subModel
                |> Scale.update subMsg
                |> Scale.incorporate model
                |> Tuple.mapSecond (Cmd.map ScaleMessage)

        _ ->
            model ! []
