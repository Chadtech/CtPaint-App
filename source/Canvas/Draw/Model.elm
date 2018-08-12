module Canvas.Draw.Model
    exposing
        ( Model
        , addToPending
        , applyTo
        , clearAtRender
        , clearPending
        , init
        , setAtRender
        )

import Canvas exposing (DrawOp)
import Canvas.Helpers


-- TYPES --


type alias Model =
    { atRender : DrawOp
    , pending : DrawOp
    }


init : Model
init =
    { atRender = Canvas.Helpers.noop
    , pending = Canvas.Helpers.noop
    }



-- HELPERS --


applyTo : Model -> (Model -> Model) -> Model
applyTo model f =
    f model


setAtRender : DrawOp -> Model -> Model
setAtRender drawOp model =
    { model | atRender = drawOp }


addToPending : DrawOp -> Model -> Model
addToPending drawOp model =
    { model
        | pending =
            [ model.pending, drawOp ]
                |> Canvas.batch
    }


clearAtRender : Model -> Model
clearAtRender model =
    { model | atRender = Canvas.Helpers.noop }


clearPending : Model -> Model
clearPending model =
    { model | pending = Canvas.Helpers.noop }
