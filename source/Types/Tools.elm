module Types.Tools exposing (..)

import Mouse exposing (Position)
import Main.Message exposing (Message(..))


type Name
    = Hand
    | Pencil


type alias Tool =
    { name : Name
    , icon : String
    , canvasMouseDown : Maybe (Position -> Message)
    , canvasMouseUp : Maybe (Position -> Message)
    , canvasMouseMove : Maybe (Position -> Message)
    , subMouseDown : Maybe (Position -> Message)
    , subMouseUp : Maybe (Position -> Message)
    , subMouseMove : Maybe (Position -> Message)
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
    , canvasMouseDown = Nothing
    , canvasMouseUp = Nothing
    , canvasMouseMove = Nothing
    , subMouseDown = Nothing
    , subMouseUp = Nothing
    , subMouseMove = Nothing
    }


pencil : Tool
pencil =
    { name = Pencil
    , icon = "\xEA02"
    , canvasMouseDown = Nothing
    , canvasMouseUp = Nothing
    , canvasMouseMove = Nothing
    , subMouseDown = Nothing
    , subMouseUp = Nothing
    , subMouseMove = Nothing
    }
