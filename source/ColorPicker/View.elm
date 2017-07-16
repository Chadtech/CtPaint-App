module ColorPicker.View exposing (view)

import Html exposing (Html, div, p, text, a)
import Html.Attributes exposing (class, style)
import ColorPicker.Types exposing (..)
import Util exposing (left, top)


view : Model -> Html Message
view model =
    div
        [ class "card color-picker"
        , style
            [ left model.position.x
            , top model.position.y
            ]
        ]
        [ div
            [ class "header" ]
            [ p [] [ text "Color Picker" ]
            , a
                []
                [ text "x" ]
            ]
        ]
