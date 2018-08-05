module Canvas.Data.Params
    exposing
        ( CanvasParams
        , decoder
        , toCanvas
        )

import Canvas exposing (Canvas)
import Canvas.Data.BackgroundColor as BackgroundColor
    exposing
        ( BackgroundColor(Black, White)
        )
import Canvas.Helpers
import Data.Size exposing (Size)
import Json.Decode as JD exposing (Decoder)
import Json.Decode.Pipeline as JDP


-- TYPES --


type alias CanvasParams =
    { name : Maybe String
    , width : Maybe Int
    , height : Maybe Int
    , backgroundColor : Maybe BackgroundColor
    }



-- DECODER --


decoder : Decoder CanvasParams
decoder =
    JDP.decode CanvasParams
        |> maybeField "name" JD.string
        |> maybeField "width" JD.int
        |> maybeField "height" JD.int
        |> maybeField "background" BackgroundColor.decoder


maybeField : String -> Decoder a -> Decoder (Maybe a -> b) -> Decoder b
maybeField field decoder =
    JDP.optional field (JD.map Just decoder) Nothing



-- HELPERS --


toCanvas : CanvasParams -> Canvas
toCanvas params =
    let
        fromSize : Size -> Canvas
        fromSize size =
            size
                |> Canvas.initialize
                |> BackgroundColor.fill
                    (getColor params.backgroundColor)
    in
    case ( params.width, params.height ) of
        ( Just width, Just height ) ->
            { width = width
            , height = height
            }
                |> fromSize

        ( Just width, Nothing ) ->
            { width = width
            , height = width
            }
                |> fromSize

        ( Nothing, Just height ) ->
            { width = height
            , height = height
            }
                |> fromSize

        ( Nothing, Nothing ) ->
            fromSize Canvas.Helpers.defaultSize


getColor : Maybe BackgroundColor -> BackgroundColor
getColor =
    Maybe.withDefault White
