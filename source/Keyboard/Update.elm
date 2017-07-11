module Keyboard.Update exposing (update)

import Main.Model exposing (Model)
import Keyboard.Types exposing (Message(..), Direction(..))
import Char
import Tool.Types exposing (Tool(..))


update : Message -> Model -> Model
update message model =
    case message of
        KeyEvent direction ->
            case direction of
                Up code ->
                    handleKeyUp (Char.fromCode code) model



-- KEY EVENTS --


handleKeyUp : Char -> Model -> Model
handleKeyUp char model =
    case char of
        'P' ->
            { model
                | tool = Pencil Nothing
            }

        'H' ->
            { model
                | tool = Hand Nothing
            }

        _ ->
            model
