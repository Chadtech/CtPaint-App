module Color.Palette.Msg
    exposing
        ( Msg(..)
        )

import Color exposing (Color)


type Msg
    = SquareClicked Int Color Bool
    | SquareRightClicked Color Int
    | AddSquareClicked
