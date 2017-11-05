module Toolbar exposing (view)

import Html exposing (Html, a, div, text)
import Html.Attributes exposing (attribute, class, classList, title)
import Html.Events exposing (onClick)
import Tool exposing (Tool(..))
import Tuple.Infix exposing ((&), (:=))
import Types exposing (Command(..), Model, Msg(..))


view : Model -> Html Msg
view model =
    div
        [ class "vertical-tool-bar" ]
        (children model.tool)



-- COMPONENTS --


children : Tool -> List (Html Msg)
children currentTool =
    [ List.map (toolButton currentTool) Tool.all
    , List.map menuButton menus
    ]
        |> List.concat


menus : List ( String, String, Command )
menus =
    [ ( "\xEA19", "text", InitText )
    , ( "\xEA0F", "replace color", InitReplaceColor )
    , ( "\xEA0E", "invert colors", InvertColors )
    ]


menuButton : ( String, String, Command ) -> Html Msg
menuButton ( icon, name, command ) =
    a
        [ class "tool-button"
        , onClick (Command command)
        , attribute "data-toggle" "tooltip"
        , title name
        ]
        [ text icon ]


toolButton : Tool -> Tool -> Html Msg
toolButton currentTool thisButtonsTool =
    a
        [ classList
            [ "tool-button" := True
            , "selected"
                := isCurrentTool currentTool thisButtonsTool
            ]
        , attribute "data-toggle" "tooltip"
        , title (Tool.name thisButtonsTool)
        , onClick (SetTool thisButtonsTool)
        ]
        [ text (Tool.icon thisButtonsTool) ]



-- HELPERS --


isCurrentTool : Tool -> Tool -> Bool
isCurrentTool currentTool tool =
    Tool.name currentTool == Tool.name tool
