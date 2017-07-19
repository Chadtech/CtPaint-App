module ColorPicker.View exposing (view)

import Html exposing (Html, div, p, text, a, input, form)
import Html.Attributes exposing (class, classList, style, spellcheck, value)
import Html.Events exposing (onClick, onSubmit, onMouseDown, onFocus, onBlur, onInput)
import ColorPicker.Types exposing (..)
import Util exposing ((:=), left, top, toPosition)
import MouseEvents as Events


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
            [ class "header"
            , Events.onMouseDown HeaderMouseDown
            ]
            [ p [] [ text "Color Editor" ]
            , a
                [ onClick Close ]
                [ text "x" ]
            ]
        , div
            [ class "body" ]
            [ a
                [ classList
                    [ "selected" := (model.colorFormat == Rgb) ]
                , onClick (SetColorFormat Rgb)
                ]
                [ text "RGB" ]
            , a
                [ classList
                    [ "selected" := (model.colorFormat == Hsl) ]
                , onClick (SetColorFormat Hsl)
                ]
                [ text "HSL" ]
            , a
                [ classList
                    [ "selected" := (model.colorScale == Abs)
                    , "break" := True
                    ]
                , onClick (SetColorScale Abs)
                ]
                [ text "Absolute" ]
            , a
                [ classList
                    [ "selected" := (model.colorScale == Rel) ]
                , onClick (SetColorScale Rel)
                ]
                [ text "Relative" ]
            , form
                [ onSubmit StealSubmit ]
                [ input
                    [ spellcheck False
                    , onFocus (HandleFocus True)
                    , onBlur (HandleFocus False)
                    , onInput UpdateColorHexField
                    , value model.colorHexField
                    ]
                    []
                ]
            ]
        ]
