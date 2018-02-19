module Incorporate.Color
    exposing
        ( Reply(..)
        , picker
        )

import Array
import Color exposing (Color)
import Data.Color exposing (Model)
import Data.Picker as Picker
import Ports
import Tuple.Infix exposing ((&))


type Reply
    = NoReply
    | ColorHistory Int Color


picker : Model -> ( Picker.Model, Picker.Reply ) -> ( ( Model, Cmd msg ), Reply )
picker model ( picker, reply ) =
    case reply of
        Picker.NoReply ->
            { model | picker = picker }
                & Cmd.none
                & NoReply

        Picker.SetColor index color ->
            { model
                | picker = picker
                , palette =
                    Array.set index color model.palette
            }
                & Cmd.none
                & NoReply

        Picker.UpdateHistory index color ->
            { model | picker = picker }
                & Cmd.none
                & ColorHistory index color

        Picker.StealFocus ->
            model & Ports.stealFocus & NoReply

        Picker.ReturnFocus ->
            model & Ports.returnFocus & NoReply
