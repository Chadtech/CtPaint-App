module Tool.View exposing (infoBox)

import Data.Position exposing (Position)
import Tool.Data exposing (Tool(..))


infoBox : Maybe Position -> Tool -> List String
infoBox maybeMousePosition tool =
    tool
        |> infoBoxPieces maybeMousePosition
        |> List.map String.concat


infoBoxPieces : Maybe Position -> Tool -> List (List String)
infoBoxPieces maybeMousePosition tool =
    case tool of
        Select maybePosition ->
            case ( maybePosition, maybeMousePosition ) of
                ( Just origin, Just position ) ->
                    [ rectInfo origin position
                    , originInfo origin
                    ]

                _ ->
                    []

        Rectangle subModel ->
            case ( subModel, maybeMousePosition ) of
                ( Just { initialClickPositionOnCanvas }, Just position ) ->
                    [ rectInfo initialClickPositionOnCanvas position
                    , originInfo initialClickPositionOnCanvas
                    ]

                _ ->
                    []

        RectangleFilled subModel ->
            case ( subModel, maybeMousePosition ) of
                ( Just { initialClickPositionOnCanvas }, Just position ) ->
                    [ rectInfo initialClickPositionOnCanvas position
                    , originInfo initialClickPositionOnCanvas
                    ]

                _ ->
                    []

        Line subModel ->
            case ( subModel, maybeMousePosition ) of
                ( Just { initialClickPositionOnCanvas }, Just position ) ->
                    [ originInfo initialClickPositionOnCanvas
                    , lineInfo position
                    , lengthInfo initialClickPositionOnCanvas position
                    ]

                _ ->
                    []

        _ ->
            []


lengthInfo : Position -> Position -> List String
lengthInfo origin position =
    [ "length(~"
    , ((origin.x - position.x) ^ 2 + (origin.y - position.y) ^ 2)
        |> toFloat
        |> sqrt
        |> round
        |> toString
    , ")"
    ]


lineInfo : Position -> List String
lineInfo p =
    [ "to("
    , toString p.x
    , ","
    , toString p.y
    , ")"
    ]


rectInfo : Position -> Position -> List String
rectInfo origin position =
    [ "rect("
    , (origin.x - position.x + 1)
        |> abs
        |> toString
    , ","
    , (origin.y - position.y + 1)
        |> abs
        |> toString
    , ")"
    ]


originInfo : Position -> List String
originInfo p =
    [ "origin("
    , toString p.x
    , ","
    , toString p.y
    , ")"
    ]
