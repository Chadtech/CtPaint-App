module Color.Swatches.Data
    exposing
        ( Swatches
        , encode
        , init
        , setKeyAsDown
        , setKeyAsUp
        , setTop
        , turnLeft
        , turnRight
        )

import Color exposing (Color)
import Color.Data.Colors as Colors
    exposing
        ( ctPrettyBlue
        , ctRed
        )
import Json.Encode as JE
import Util exposing (def)


-- TYPES --


type alias Swatches =
    { top : Color
    , left : Color
    , bottom : Color
    , right : Color
    , keyIsDown : Bool
    }


init : Swatches
init =
    { top = Color.black
    , left = ctPrettyBlue
    , bottom = Color.white
    , right = ctRed
    , keyIsDown = False
    }



-- ENCODER --


encode : Swatches -> JE.Value
encode { top, left, bottom, right } =
    [ def "top" <| Colors.encode top
    , def "left" <| Colors.encode left
    , def "bottom" <| Colors.encode bottom
    , def "right" <| Colors.encode right
    ]
        |> JE.object



-- PUBLIC HELPERS --


setTop : Color -> Swatches -> Swatches
setTop color swatches =
    { swatches | top = color }


turnLeft : Swatches -> Swatches
turnLeft swatches =
    { swatches
        | top = swatches.left
        , left = swatches.bottom
        , bottom = swatches.right
        , right = swatches.top
    }


turnRight : Swatches -> Swatches
turnRight swatches =
    { swatches
        | top = swatches.right
        , left = swatches.top
        , bottom = swatches.left
        , right = swatches.bottom
    }


setKeyAsUp : Swatches -> Swatches
setKeyAsUp swatches =
    { swatches | keyIsDown = False }


setKeyAsDown : Swatches -> Swatches
setKeyAsDown swatches =
    { swatches | keyIsDown = True }
