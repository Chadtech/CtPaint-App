module Minimap.Constants
    exposing
        ( centerOfPortal
        , portalSize
        )

import Data.Size as Size exposing (Size)
import Data.Position exposing (Position)


portalSize : Size
portalSize =
    { width = 250
    , height = 250
    }


centerOfPortal : Position
centerOfPortal =
    Size.center portalSize
