module Color.Update
    exposing
        ( update
        )

import Color.Model exposing (Model)
import Color.Msg exposing (Msg(..))
import Color.Palette.Update as Palette
import Color.Picker.Update as Picker
import Color.Reply exposing (Reply)
import Return3 as R3 exposing (Return)


update : Msg -> Model -> Return Model Msg Reply
update msg model =
    case msg of
        PaletteMsg subMsg ->
            Palette.update subMsg model
                |> R3.withNothing

        PickerMsg subMsg ->
            model
                |> Picker.update subMsg
                |> R3.mapCmd PickerMsg
