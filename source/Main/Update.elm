module Main.Update exposing (update)

import Main.Message exposing (Message(..))
import Main.Model exposing (Model)
import Toolbar.Horizontal.Update as HorizontalToolbar


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        HorizontalToolbarMessage subMessage ->
            let
                ( newModel, cmd ) =
                    HorizontalToolbar.update subMessage model
            in
                ( newModel, Cmd.map HorizontalToolbarMessage cmd )
