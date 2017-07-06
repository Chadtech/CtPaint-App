module Toolbar.Vertical.View exposing (view)

import Html exposing (Html, div, a, text)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import Main.Message exposing (Message(..))
import Main.Model exposing (Model)
import Tool.Types as Tool exposing (Tool(..))
import Util exposing ((:=))


view : Model -> Html Message
view model =
    div
        [ class "vertical-tool-bar" ]
        (List.map (buttonView model.tool) Tool.all)



-- COMPONENTS --


buttonView : Tool -> Tool -> Html Message
buttonView currentTool thisButtonsTool =
    let
        isSelected =
            (Tool.name currentTool) == (Tool.name thisButtonsTool)
    in
        a
            [ classList
                [ "tool-button" := True
                , "selected" := isSelected
                ]
            , onClick (SetTool thisButtonsTool)
            ]
            [ text (Tool.icon thisButtonsTool) ]
