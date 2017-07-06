module Tool.Types exposing (..)


type Tool
    = Hand
    | Pencil



-- PUBLIC HELPERS --


all : List Tool
all =
    [ Hand
    , Pencil
    ]


icon : Tool -> String
icon tool =
    case tool of
        Hand ->
            "/xEA0A"

        Pencil ->
            "\xEA02"


name : Tool -> String
name tool =
    case tool of
        Hand ->
            "hand"

        Pencil ->
            "pencil"
