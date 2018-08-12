module Tool.Eraser.View
    exposing
        ( css
        , view
        )

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html, input)
import Html.Attributes exposing (value)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)


-- TYPES --


type alias Payload msg =
    { size : Int
    , increaseMsg : msg
    , decreaseMsg : msg
    }



-- STYLES --


type Class
    = Plus
    | Button
    | Field


css : Stylesheet
css =
    [ Css.class Plus
        [ marginTop (px 24) ]
    , Css.class Button
        [ lineHeight (px 23)
        , marginBottom (px 1)
        ]
    , Css.class Field
        [ display block
        , width (px 24)
        , marginBottom (px 1)
        ]
    ]
        |> namespace eraserNamespace
        |> stylesheet


eraserNamespace : String
eraserNamespace =
    Html.Custom.makeNamespace "Eraser"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace eraserNamespace


view : Payload msg -> List (Html msg)
view { increaseMsg, decreaseMsg, size } =
    [ Html.Custom.toolbarButton
        { text = "+"
        , selected = False
        , attrs =
            [ class [ Plus, Button ]
            , onClick increaseMsg
            ]
        }
    , input
        [ class [ Field ]
        , value (toString size)
        ]
        []
    , Html.Custom.toolbarButton
        { text = "-"
        , selected = False
        , attrs =
            [ class [ Button ]
            , onClick decreaseMsg
            ]
        }
    ]
