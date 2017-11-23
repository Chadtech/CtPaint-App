module Data.Project exposing (Project)

import Canvas exposing (Canvas)


type alias Project =
    { canvas : Canvas
    , name : String
    , id : Id
    }


type Id
    = Id String
    | New
