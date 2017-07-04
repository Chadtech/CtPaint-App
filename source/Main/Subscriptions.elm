module Main.Subscriptions exposing (subscriptions)

import Main.Model exposing (Model)
import Main.Message exposing (Message(..))
import Util exposing (maybeCons)
import Mouse
import Window


subscriptions : Model -> Sub Message
subscriptions model =
    [ Window.resizes GetWindowSize ]
        |> maybeCons (Maybe.map Mouse.moves model.subMouseMove)
        |> Sub.batch
