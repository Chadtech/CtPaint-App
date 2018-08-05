module Color.Reply
    exposing
        ( Reply(..)
        )

import Color exposing (Color)


type Reply
    = UpdateColorHistory Int Color
