module Incorporate.Color
    exposing
        ( Reply(..)
        , picker
        )

import Array
import Color exposing (Color)
import ColorPicker
import Data.Color exposing (Model)
import Ports exposing (JsMsg(ReturnFocus, StealFocus))
import Tuple.Infix exposing ((&))


type Reply
    = NoReply
    | ColorHistory Int Color


picker : Model -> ( ColorPicker.Model, ColorPicker.Reply ) -> ( ( Model, Cmd msg ), Reply )
picker model ( picker, reply ) =
    case reply of
        ColorPicker.NoReply ->
            { model | picker = picker }
                & Cmd.none
                & NoReply

        ColorPicker.SetColor index color ->
            { model
                | picker = picker
                , palette =
                    Array.set index color model.palette
            }
                & Cmd.none
                & NoReply

        ColorPicker.UpdateHistory index color ->
            { model | picker = picker }
                & Cmd.none
                & ColorHistory index color

        ColorPicker.StealFocus ->
            model & Ports.send StealFocus & NoReply

        ColorPicker.ReturnFocus ->
            model & Ports.send ReturnFocus & NoReply
