module Main.Model exposing (Model)

import Types.Session exposing (Session)


type alias Model =
    { session : Maybe Session }
