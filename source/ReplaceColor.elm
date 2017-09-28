module ReplaceColor exposing (..)

import Color exposing (Color)
import Html exposing (Html, p, text)
import Util exposing ((&))


type Msg
    = OkayClick


type ExternalMsg
    = DoNothing
    | Replace Color Color


type alias Model =
    { target : Color
    , replacement : Color
    }



-- UPDATE --


update : Msg -> Model -> ( Model, ExternalMsg )
update msg model =
    case msg of
        OkayClick ->
            model & Replace model.target model.replacement



-- VIEW --


view : Model -> List (Html Msg)
view model =
    []



-- INIT --


init : Color -> Color -> Model
init target replacement =
    { target = target
    , replacement = replacement
    }
