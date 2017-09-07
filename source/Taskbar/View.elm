module Taskbar.View exposing (view)

import Dict exposing (Dict)
import Html exposing (Attribute, Html, a, div, p, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick, onMouseOver)
import Keyboard.Types exposing (Command(..))
import Main.Model exposing (Model)
import Taskbar.Types exposing (Message(..), Option(..))


view : Model -> Html Message
view ({ taskbarDropped } as model) =
    div
        [ class "top-tool-bar" ]
        [ file taskbarDropped
        , edit model
        , transform taskbarDropped
        , view_ model
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



-- VIEW --


view_ : Model -> Html Message
view_ model =
    case model.taskbarDropped of
        Just View ->
            taskbarButtonOpen
                [ text "View"
                , seam
                , div
                    [ class "options view" ]
                    [ option ( "Gallery view", "tab", NoOp )
                    , minimap model
                    ]
                ]

        _ ->
            taskbarButtonClose View


minimap : Model -> Html Message
minimap model =
    case model.minimap of
        Just _ ->
            option
                ( "Hide Mini Map"
                , "`"
                , SwitchMinimap False
                )

        Nothing ->
            option
                ( "Show Mini Map"
                , "`"
                , SwitchMinimap True
                )



-- TRANSFORM --


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


edit : Model -> Html Message
edit model =
    case model.taskbarDropped of
        Just Edit ->
            taskbarButtonOpen
                [ text "Edit"
                , seam
                , div
                    [ class "options edit" ]
                    [ option
                        ( "Undo"
                        , getCmdStr model.keyboardUpLookUp Undo
                        , Command Undo
                        )
                    , option
                        ( "Redo"
                        , getCmdStr model.keyboardUpLookUp Redo
                        , Command Redo
                        )
                    , divider
                    , option
                        ( "Cut"
                        , getCmdStr model.keyboardUpLookUp Cut
                        , Command Cut
                        )
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
                    , option ( "Download", "Cmd + D", InitDownload )
                    , option ( "Import", "Cmd + I", InitImport )
                    , divider
                    , option ( "Imgur", "", NoOp )
                    , option ( "Twitter", "", NoOp )
                    , option ( "Facebook", "", NoOp )
                    ]
                ]

        _ ->
            taskbarButtonClose File



-- HELPERS --


getCmdStr : Dict String (List String) -> Command -> String
getCmdStr cmdLookUp cmd =
    case Dict.get (toString cmd) cmdLookUp of
        Just keys ->
            toKeyCmdStr keys

        Nothing ->
            ""


toKeyCmdStr : List String -> String
toKeyCmdStr =
    String.join " + "


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