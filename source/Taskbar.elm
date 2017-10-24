module Taskbar exposing (view)

import Dict exposing (Dict)
import Html exposing (Attribute, Html, a, div, p, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick, onMouseOver)
import Tool
import Types
    exposing
        ( Command(..)
        , MinimapState(..)
        , Model
        , Msg(..)
        , NewWindow(..)
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
            [ option "About" "" (Command InitAbout)
            , option "Tutorial" "" (OpenNewWindow Tutorial)
            , option "Donate" "" (OpenNewWindow Donate)
            ]
                |> taskbarButtonOpen "Help"

        _ ->
            taskbarButtonClose Help



-- VIEW --


view_ : Model -> Html Msg
view_ model =
    case model.taskbarDropped of
        Just View ->
            [ option
                "Gallery view"
                "tab"
                (Command SwitchGalleryView)
            , option
                (minimapLabel model)
                (getCmdStr model.quickKeys ToggleMinimap)
                (Command ToggleMinimap)
            , option
                "Color Picker"
                (getCmdStr model.quickKeys ToggleColorPicker)
                (Command ToggleColorPicker)
            ]
                |> taskbarButtonOpen "View"

        _ ->
            taskbarButtonClose View


minimapLabel : Model -> String
minimapLabel model =
    case model.minimap of
        Minimap _ ->
            "Hide Mini Map"

        _ ->
            "Show Mini Map"



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
    [ option
        "Flip Horiztonal"
        (getCmdStr model.quickKeys FlipHorizontal)
        (Command FlipHorizontal)
    , option
        "Flip Vertical"
        (getCmdStr model.quickKeys FlipVertical)
        (Command FlipVertical)
    , divider
    , option
        "Rotate 90"
        (getCmdStr model.quickKeys Rotate90)
        (Command Rotate90)
    , option
        "Rotate 180"
        (getCmdStr model.quickKeys Rotate180)
        (Command Rotate180)
    , option
        "Rotate 270"
        (getCmdStr model.quickKeys Rotate270)
        (Command Rotate270)
    , divider
    , option
        "Scale"
        (getCmdStr model.quickKeys InitScale)
        (Command InitScale)
    , option
        "Replace Color"
        (getCmdStr model.quickKeys InitReplaceColor)
        (Command InitReplaceColor)
    , option
        "Invert"
        (getCmdStr model.quickKeys InvertColors)
        (Command InvertColors)
    , divider
    , option
        "Text"
        (getCmdStr model.quickKeys InitText)
        (Command InitText)
    ]
        |> taskbarButtonOpen "Transform"



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
        |> taskbarButtonOpen "Tools"



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
    , option
        "Preferences"
        ""
        (OpenNewWindow Preferences)
    ]
        |> taskbarButtonOpen "Edit"



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
    [ option
        "Save"
        (getCmdStr model.quickKeys Save)
        (Command Save)
    , option
        "Download"
        (getCmdStr model.quickKeys InitDownload)
        (Command InitDownload)
    , option
        "Import"
        (getCmdStr model.quickKeys InitImport)
        (Command InitImport)
    , divider
    , option "Imgur" "" InitImgur
    ]
        |> taskbarButtonOpen "File"



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


taskbarButtonOpen : String -> List (Html Msg) -> Html Msg
taskbarButtonOpen labelStr children =
    a
        [ class "task-bar-button current"
        , onClick (DropDown Nothing)
        ]
        [ text labelStr
        , seam
        , div
            [ class
                ("options " ++ String.toLower labelStr)
            ]
            children
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
