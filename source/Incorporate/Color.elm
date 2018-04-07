module Incorporate.Color
    exposing
        ( Reply(..)
        , model
        , picker
        )

import Array
import Color exposing (Color)
import Data.Color as Color
import Data.Picker as Picker
import Helpers.History as History
import Model exposing (Model)
import Msg exposing (Msg)
import Return2 as R2
import Return3 as R3 exposing (Return)


type Reply
    = ColorHistory Int Color


model : Color.Model -> Maybe Reply -> Model -> ( Model, Cmd Msg )
model colorModel maybeReply model =
    case maybeReply of
        Nothing ->
            { model | color = colorModel }
                |> R2.withNoCmd

        Just (ColorHistory index color) ->
            { model | color = colorModel }
                |> History.color index color
                |> R2.withNoCmd


picker : Color.Model -> Return Picker.Model Msg Picker.Reply -> Return Color.Model Msg Reply
picker model ( picker, cmd, reply ) =
    case reply of
        Nothing ->
            { model | picker = picker }
                |> R2.withCmd cmd
                |> R3.withNoReply

        Just (Picker.SetColor index color) ->
            { model
                | picker = picker
                , palette =
                    Array.set index color model.palette
            }
                |> R2.withCmd cmd
                |> R3.withNoReply

        Just (Picker.UpdateHistory index color) ->
            { model | picker = picker }
                |> R2.withCmd cmd
                |> R3.withReply (ColorHistory index color)
