module Toolbar exposing (view)

import Html exposing (Html, a, div, text)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import Tool exposing (Tool(..))
import Types exposing (Model, Msg(..))
import Util exposing ((:=))


view : Model -> Html Msg
view model =
    div
        [ class "vertical-tool-bar" ]
        (List.map (buttonView model.tool) Tool.all)



-- COMPONENTS --


buttonView : Tool -> Tool -> Html Msg
buttonView currentTool thisButtonsTool =
    a
        [ classList
            [ "tool-button" := True
            , "selected"
                := isCurrentTool currentTool thisButtonsTool
            ]
        , onClick (SetTool thisButtonsTool)
        ]
        [ text (Tool.icon thisButtonsTool) ]



-- HELPERS --


isCurrentTool : Tool -> Tool -> Bool
isCurrentTool currentTool tool =
    Tool.name currentTool == Tool.name tool
