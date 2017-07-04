module Types.Tools exposing (..)


type Name
    = Hand
    | Pencil


type alias Tool =
    { name : Name
    , icon : String
    }



-- TOOLS --


all : List Tool
all =
    [ hand
    , pencil
    ]


hand : Tool
hand =
    { name = Hand
    , icon = "\xEA0A"
    }


pencil : Tool
pencil =
    { name = Pencil
    , icon = "\xEA02"
    }
