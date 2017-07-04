module Toolbar.Vertical.View exposing (view)

import Html exposing (Html, div, a, p, text)
import Html.Attributes exposing (class)
import Main.Message exposing (Message(..))
import Types.Tools as Tools exposing (Tool)


view : Html Message
view =
    div
        [ class "vertical-tool-bar" ]
        (List.map buttonView Tools.all)



-- COMPONENTS --


buttonView : Tool -> Html Message
buttonView tool =
    a
        [ class "tool-button" ]
        [ text tool.icon ]
