module Taskbar exposing (view)

import Dict exposing (Dict)
import Html exposing (Attribute, Html, a, div, p, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick, onMouseOver)
import Types
    exposing
        ( Command(..)
        , Model
        , Msg(..)
        , TaskbarDropDown(..)
        )


view : Model -> Html Msg
view ({ taskbarDropped } as model) =
    div
        [ class "top-tool-bar" ]
        [ file model
        , edit model
        , transform model
        , tools model
        , view_ model
        , help taskbarDropped
        , invisibleWall taskbarDropped
        ]


invisibleWall : Maybe TaskbarDropDown -> Html Msg
invisibleWall maybeTaskbarDropDown =
    case maybeTaskbarDropDown of
        Just _ ->
            div
                [ class "invisible-wall"
                , onClick (DropDown Nothing)
                ]
                []

        Nothing ->
            text ""


help : Maybe TaskbarDropDown -> Html Msg
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


view_ : Model -> Html Msg
view_ model =
    case model.taskbarDropped of
        Just View ->
            taskbarButtonOpen
                [ text "View"
                , seam
                , div
                    [ class "options view" ]
                    [ option_
                        "Gallery view"
                        "tab"
                        (Command SwitchGalleryView)
                    , minimap model
                    ]
                ]

        _ ->
            taskbarButtonClose View


minimap : Model -> Html Msg
minimap model =
    case model.minimap of
        Just _ ->
            option_ "Hide Mini Map" "`" (SwitchMinimap False)

        Nothing ->
            option_ "Show Mini Map" "`" (SwitchMinimap True)



-- TRANSFORM --


transform : Model -> Html Msg
transform model =
    case model.taskbarDropped of
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
                    , option_
                        "Scale"
                        (getCmdStr model.keyboardUpLookUp Scale)
                        (Command Scale)
                    , option ( "Replace Color", "Cmd + R", NoOp )
                    , option ( "Invert", "Cmd + I", NoOp )
                    ]
                ]

        _ ->
            taskbarButtonClose Transform



-- TOOLS --


tools : Model -> Html Msg
tools model =
    case model.taskbarDropped of
        Just Tools ->
            taskbarButtonOpen
                [ text "Tools"
                , seam
                , div
                    [ class "options tools" ]
                    [ option ( "Flip Horiztonal", "Shift + H", NoOp )
                    , option ( "Flip Vertical", "Shift + V", NoOp )
                    , divider
                    , option ( "Rotate 90", "Shift + R", NoOp )
                    , option ( "Rotate 180", "Shift + E", NoOp )
                    , option ( "Rotate 270", "Shift + D", NoOp )
                    , divider
                    , option_
                        "Scale"
                        (getCmdStr model.keyboardUpLookUp Scale)
                        (Command Scale)
                    , option ( "Replace Color", "Cmd + R", NoOp )
                    , option ( "Invert", "Cmd + I", NoOp )
                    ]
                ]

        _ ->
            taskbarButtonClose Tools



-- EDIT --


edit : Model -> Html Msg
edit model =
    case model.taskbarDropped of
        Just Edit ->
            taskbarButtonOpen
                [ text "Edit"
                , seam
                , div
                    [ class "options edit" ]
                    [ option_
                        "Undo"
                        (getCmdStr model.keyboardUpLookUp Undo)
                        (Command Undo)
                    , option_
                        "Redo"
                        (getCmdStr model.keyboardUpLookUp Redo)
                        (Command Redo)
                    , divider
                    , option_
                        "Cut"
                        (getCmdStr model.keyboardUpLookUp Cut)
                        (Command Cut)
                    , option_
                        "Copy"
                        (getCmdStr model.keyboardUpLookUp Copy)
                        (Command Copy)
                    , option_
                        "Paste"
                        (getCmdStr model.keyboardUpLookUp Paste)
                        (Command Paste)
                    , divider
                    , option_
                        "Select all"
                        (getCmdStr model.keyboardUpLookUp SelectAll)
                        (Command SelectAll)
                    , divider
                    , option ( "Preferences", "", NoOp )
                    ]
                ]

        _ ->
            taskbarButtonClose Edit


file : Model -> Html Msg
file model =
    case model.taskbarDropped of
        Just File ->
            taskbarButtonOpen
                [ text "File"
                , seam
                , div
                    [ class "options file" ]
                    [ option ( "Save", "Cmd + S", NoOp )
                    , option ( "Auto Save", "On", NoOp )
                    , divider
                    , option_
                        "Download"
                        (getCmdStr model.keyboardUpLookUp Download)
                        (Command Download)
                    , option_
                        "Import"
                        (getCmdStr model.keyboardUpLookUp Import)
                        (Command Import)
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


taskbarButtonClose : TaskbarDropDown -> Html Msg
taskbarButtonClose option =
    a
        [ class "task-bar-button"
        , onClick (DropDown (Just option))
        , onMouseOver (HoverOnto option)
        ]
        [ text (toString option) ]


taskbarButtonOpen : List (Html Msg) -> Html Msg
taskbarButtonOpen =
    a
        [ class "task-bar-button current"
        , onClick (DropDown Nothing)
        ]


divider : Html Msg
divider =
    div
        [ class "divider" ]
        [ div [ class "strike" ] [] ]


option_ : String -> String -> Msg -> Html Msg
option_ label cmdKeys message =
    div
        [ onClick message
        , class "option"
        ]
        [ p_ label
        , p_ cmdKeys
        ]


option : ( String, String, Msg ) -> Html Msg
option ( label, cmdText, message ) =
    div
        [ onClick message
        , class "option"
        ]
        [ p_ label
        , p_ cmdText
        ]


seam : Html Msg
seam =
    div [ class "seam" ] []


p_ : String -> Html Msg
p_ =
    text >> List.singleton >> p []
