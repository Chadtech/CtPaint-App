module Toolbar.Top.View exposing (view)

import Html exposing (Html, Attribute, div, a, p, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick, onMouseOver)
import Main.Model exposing (Model)
import Toolbar.Top.Types exposing (Option(..), Message(..))


view : Model -> Html Message
view { taskbarDropped } =
    div
        [ class "top-tool-bar" ]
        [ file taskbarDropped
        , edit taskbarDropped
        , transform taskbarDropped
        , view_ taskbarDropped
        , help taskbarDropped
        , invisibleWall taskbarDropped
        ]


invisibleWall : Maybe Option -> Html Message
invisibleWall maybeOption =
    case maybeOption of
        Just _ ->
            div
                [ class "invisible-wall"
                , onClick (DropDown Nothing)
                ]
                []

        Nothing ->
            text ""


help : Maybe Option -> Html Message
help maybeHelp =
    case maybeHelp of
        Just Help ->
            taskbarButtonOpen
                [ text "Help"
                , seam
                , div
                    [ class "options help" ]
                    [ option ( "About", "", NoOp )
                    , option ( "Tutorial", "", NoOp )
                    , option ( "Donate", "", NoOp )
                    ]
                ]

        _ ->
            taskbarButtonClose Help


view_ : Maybe Option -> Html Message
view_ maybeView =
    case maybeView of
        Just View ->
            taskbarButtonOpen
                [ text "View"
                , seam
                , div
                    [ class "options view" ]
                    [ option ( "Gallery view", "tab", NoOp )
                    , option ( "Mini view", "on", NoOp )
                    ]
                ]

        _ ->
            taskbarButtonClose View


transform : Maybe Option -> Html Message
transform maybeTransform =
    case maybeTransform of
        Just Transform ->
            taskbarButtonOpen
                [ text "Transform"
                , seam
                , div
                    [ class "options transform" ]
                    [ option ( "Flip Horiztonal", "Shift + H", NoOp )
                    , option ( "Flip Vertical", "Shift + V", NoOp )
                    , divider
                    , option ( "Rotate 90", "Shift + R", NoOp )
                    , option ( "Rotate 180", "Shift + E", NoOp )
                    , option ( "Rotate 270", "Shift + D", NoOp )
                    , divider
                    , option ( "Scale", "Cmd + W", NoOp )
                    , option ( "Replace Color", "Cmd + R", NoOp )
                    , option ( "Invert", "Cmd + I", NoOp )
                    ]
                ]

        _ ->
            taskbarButtonClose Transform


edit : Maybe Option -> Html Message
edit maybeEdit =
    case maybeEdit of
        Just Edit ->
            taskbarButtonOpen
                [ text "Edit"
                , seam
                , div
                    [ class "options edit" ]
                    [ option ( "Undo", "Cmd + Z", NoOp )
                    , option ( "Redo", "Cmd + Y", NoOp )
                    , divider
                    , option ( "Cut", "Cmd + X", NoOp )
                    , option ( "Copy", "Cmd + C", NoOp )
                    , option ( "Paste", "Cmd + V", NoOp )
                    , divider
                    , option ( "Select all", "Cmd + A", NoOp )
                    , divider
                    , option ( "Preferences", "", NoOp )
                    ]
                ]

        _ ->
            taskbarButtonClose Edit


file : Maybe Option -> Html Message
file maybeFile =
    case maybeFile of
        Just File ->
            taskbarButtonOpen
                [ text "File"
                , seam
                , div
                    [ class "options file" ]
                    [ option ( "Save", "Cmd + S", NoOp )
                    , option ( "Auto Save", "On", NoOp )
                    , divider
                    , option ( "Download", "Cmd + D", Download )
                    , option ( "Import", "Cmd + I", NoOp )
                    , divider
                    , option ( "Imgur", "", NoOp )
                    , option ( "Twitter", "", NoOp )
                    , option ( "Facebook", "", NoOp )
                    ]
                ]

        _ ->
            taskbarButtonClose File



-- HELPERS --


taskbarButtonClose : Option -> Html Message
taskbarButtonClose option =
    a
        [ class "task-bar-button"
        , onClick (DropDown (Just option))
        , onMouseOver (HoverOnto option)
        ]
        [ text (toString option) ]


taskbarButtonOpen : List (Html Message) -> Html Message
taskbarButtonOpen =
    a
        [ class "task-bar-button current"
        , onClick (DropDown Nothing)
        ]


divider : Html Message
divider =
    div
        [ class "divider" ]
        [ div [ class "strike" ] [] ]


option : ( String, String, Message ) -> Html Message
option ( label, cmdText, message ) =
    div
        [ onClick message
        , class "option"
        ]
        [ p_ label
        , p_ cmdText
        ]


seam : Html Message
seam =
    div [ class "seam" ] []


p_ : String -> Html Message
p_ =
    text >> List.singleton >> p []
