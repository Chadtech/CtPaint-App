module Taskbar exposing (view)

import Dict exposing (Dict)
import Html exposing (Attribute, Html, a, div, p, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick, onMouseOver)
import Tool
import Types
    exposing
        ( Command(..)
        , Model
        , Msg(..)
        , QuickKey
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
                    [ option "About" "" (Command OpenAbout)
                    , option "Tutorial" "" NoOp
                    , option "Donate" "" NoOp
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
                    [ option
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
            option "Hide Mini Map" "`" (Command HideMinimap)

        Nothing ->
            option "Show Mini Map" "`" (Command ShowMinimap)



-- TRANSFORM --


transform : Model -> Html Msg
transform model =
    case model.taskbarDropped of
        Just Transform ->
            transformOpen model

        _ ->
            taskbarButtonClose Transform


transformOpen : Model -> Html Msg
transformOpen model =
    [ text "Transform"
    , seam
    , div
        [ class "options transform" ]
        [ option "Flip Horiztonal" "Shift + H" NoOp
        , option "Flip Vertical" "Shift + V" NoOp
        , divider
        , option "Rotate 90" "Shift + R" NoOp
        , option "Rotate 180" "Shift + E" NoOp
        , option "Rotate 270" "Shift + D" NoOp
        , divider
        , option
            "Scale"
            (getCmdStr model.quickKeys Scale)
            (Command Scale)
        , option "Replace Color" "Cmd + R" NoOp
        , option "Invert" "Cmd + I" NoOp
        ]
    ]
        |> taskbarButtonOpen



-- TOOLS --


tools : Model -> Html Msg
tools model =
    case model.taskbarDropped of
        Just Tools ->
            toolsDropped model

        _ ->
            taskbarButtonClose Tools


toolsDropped : Model -> Html Msg
toolsDropped model =
    [ text "Tools"
    , seam
    , div
        [ class "options tools" ]
        [ option
            "Select"
            (getCmdStr model.quickKeys SetToolToSelect)
            (Command SetToolToSelect)
        , option
            "Zoom In"
            (getCmdStr model.quickKeys ZoomIn)
            (SetTool Tool.ZoomIn)
        , option
            "Zoom Out"
            (getCmdStr model.quickKeys ZoomOut)
            (SetTool Tool.ZoomOut)
        , option
            "Hand"
            (getCmdStr model.quickKeys SetToolToHand)
            (Command SetToolToHand)
        , option
            "Sample"
            (getCmdStr model.quickKeys SetToolToSample)
            (Command SetToolToSample)
        , option
            "Fill"
            (getCmdStr model.quickKeys SetToolToFill)
            (Command SetToolToFill)
        , option
            "Pencil"
            (getCmdStr model.quickKeys SetToolToPencil)
            (Command SetToolToPencil)
        , option
            "Line"
            (getCmdStr model.quickKeys SetToolToLine)
            (Command SetToolToLine)
        , option
            "Rectangle"
            (getCmdStr model.quickKeys SetToolToRectangle)
            (Command SetToolToRectangle)
        , option
            "Rectangle Filled"
            (getCmdStr model.quickKeys SetToolToRectangleFilled)
            (Command SetToolToRectangleFilled)
        ]
    ]
        |> taskbarButtonOpen



-- EDIT --


edit : Model -> Html Msg
edit model =
    case model.taskbarDropped of
        Just Edit ->
            editDropped model

        _ ->
            taskbarButtonClose Edit


editDropped : Model -> Html Msg
editDropped model =
    [ text "Edit"
    , seam
    , div
        [ class "options edit" ]
        [ option
            "Undo"
            (getCmdStr model.quickKeys Undo)
            (Command Undo)
        , option
            "Redo"
            (getCmdStr model.quickKeys Redo)
            (Command Redo)
        , divider
        , option
            "Cut"
            (getCmdStr model.quickKeys Cut)
            (Command Cut)
        , option
            "Copy"
            (getCmdStr model.quickKeys Copy)
            (Command Copy)
        , option
            "Paste"
            (getCmdStr model.quickKeys Paste)
            (Command Paste)
        , divider
        , option
            "Select all"
            (getCmdStr model.quickKeys SelectAll)
            (Command SelectAll)
        , divider
        , option "Preferences" "" NoOp
        ]
    ]
        |> taskbarButtonOpen



-- FILE --


file : Model -> Html Msg
file model =
    case model.taskbarDropped of
        Just File ->
            fileDropped model

        _ ->
            taskbarButtonClose File


fileDropped : Model -> Html Msg
fileDropped model =
    [ text "File"
    , seam
    , div
        [ class "options file" ]
        [ option
            "Download"
            (getCmdStr model.quickKeys InitDownload)
            (Command InitDownload)
        , option
            "Import"
            (getCmdStr model.quickKeys Import)
            (Command Import)
        , divider
        , option "Imgur" "" NoOp
        , option "Twitter" "" NoOp
        , option "Facebook" "" NoOp
        ]
    ]
        |> taskbarButtonOpen



-- HELPERS --


getCmdStr : Dict String String -> Command -> String
getCmdStr cmdLookUp cmd =
    case Dict.get (toString cmd) cmdLookUp of
        Just keys ->
            keys

        Nothing ->
            ""


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


option : String -> String -> Msg -> Html Msg
option label cmdKeys message =
    div
        [ onClick message
        , class "option"
        ]
        [ p_ label
        , p_ cmdKeys
        ]


seam : Html Msg
seam =
    div [ class "seam" ] []


p_ : String -> Html Msg
p_ =
    text >> List.singleton >> p []
