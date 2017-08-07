module Keyboard.Update exposing (update)

import Main.Model exposing (Model)
import Keyboard.Types exposing (Message(..), Direction(..))
import Tool.Types exposing (Tool(..))
import Tool.Zoom as Zoom
import Keyboard exposing (KeyCode)
import History.Update as History


update : Message -> Model -> Model
update message model =
    case message of
        KeyEvent direction ->
            case direction of
                Up code ->
                    handleKeyUp code model

                Down code ->
                    handleKeyDown code model



-- KEY EVENTS --


handleKeyDown : KeyCode -> Model -> Model
handleKeyDown code model =
    case code of
        16 ->
            { model
                | ctrlDown = True
            }

        49 ->
            if not model.swatches.keyIsDown then
                { model
                    | swatches =
                        { primary = model.swatches.first
                        , first = model.swatches.second
                        , second = model.swatches.third
                        , third = model.swatches.primary
                        , keyIsDown = True
                        }
                }
            else
                model

        50 ->
            if not model.swatches.keyIsDown then
                { model
                    | swatches =
                        { primary = model.swatches.second
                        , first = model.swatches.third
                        , second = model.swatches.primary
                        , third = model.swatches.first
                        , keyIsDown = True
                        }
                }
            else
                model

        51 ->
            if not model.swatches.keyIsDown then
                { model
                    | swatches =
                        { primary = model.swatches.third
                        , first = model.swatches.primary
                        , second = model.swatches.first
                        , third = model.swatches.second
                        , keyIsDown = True
                        }
                }
            else
                model

        _ ->
            model


handleKeyUp : KeyCode -> Model -> Model
handleKeyUp code model =
    case code of
        16 ->
            { model
                | ctrlDown = False
            }

        80 ->
            { model
                | tool = Pencil Nothing
            }

        72 ->
            { model
                | tool = Hand Nothing
            }

        -- S
        83 ->
            { model
                | tool = Select Nothing
            }

        88 ->
            { model
                | swatches =
                    { primary = model.swatches.first
                    , first = model.swatches.second
                    , second = model.swatches.third
                    , third = model.swatches.primary
                    , keyIsDown = model.swatches.keyIsDown
                    }
            }

        65 ->
            { model
                | swatches =
                    { primary = model.swatches.third
                    , first = model.swatches.primary
                    , second = model.swatches.first
                    , third = model.swatches.second
                    , keyIsDown = model.swatches.keyIsDown
                    }
            }

        49 ->
            { model
                | swatches =
                    { primary = model.swatches.third
                    , first = model.swatches.primary
                    , second = model.swatches.first
                    , third = model.swatches.second
                    , keyIsDown = False
                    }
            }

        50 ->
            { model
                | swatches =
                    { primary = model.swatches.second
                    , first = model.swatches.third
                    , second = model.swatches.primary
                    , third = model.swatches.first
                    , keyIsDown = False
                    }
            }

        51 ->
            { model
                | swatches =
                    { primary = model.swatches.first
                    , first = model.swatches.second
                    , second = model.swatches.third
                    , third = model.swatches.primary
                    , keyIsDown = False
                    }
            }

        90 ->
            History.undo model

        89 ->
            History.redo model

        -- This is the plus sign
        187 ->
            let
                newZoom =
                    Zoom.next model.zoom
            in
                if model.zoom == newZoom then
                    model
                else
                    Zoom.set newZoom model

        189 ->
            let
                newZoom =
                    Zoom.prev model.zoom
            in
                if model.zoom == newZoom then
                    model
                else
                    Zoom.set newZoom model

        _ ->
            model
