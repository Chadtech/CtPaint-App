module Menu.Loaded exposing
    ( Msg(..)
    , css
    , track
    , update
    , view
    )

import Canvas exposing (Canvas)
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Tracking as Tracking
import Html exposing (Html, div, p)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)
import Menu.Reply
    exposing
        ( Reply
            ( IncorporateImageAsCanvas
            , IncorporateImageAsSelection
            )
        )



-- TYPES --


type Msg
    = AsSelectionClicked
    | AsCanvasClicked



-- UPDATE --


update : Msg -> Canvas -> Reply
update msg canvas =
    case msg of
        AsCanvasClicked ->
            IncorporateImageAsCanvas canvas

        AsSelectionClicked ->
            IncorporateImageAsSelection canvas



-- TRACK --


track : Msg -> Tracking.Event
track msg =
    case msg of
        AsCanvasClicked ->
            "as-canvas-clicked"
                |> Tracking.noProps

        AsSelectionClicked ->
            "as-selection-clicked"
                |> Tracking.noProps



-- STYLES --


type Class
    = Text
    | CanvasContainer
    | UploadedCanvas
    | ButtonsContainer
    | Button


css : Stylesheet
css =
    [ Css.class Text
        [ maxWidth (px 500)
        , marginBottom (px 8)
        ]
    , (Css.class CanvasContainer << List.append Html.Custom.indent)
        [ marginBottom (px 8)
        , overflow hidden
        , maxWidth (px 500)
        , displayFlex
        , justifyContent center
        ]
    , Css.class UploadedCanvas
        [ maxWidth (px 500)
        , property "image-rendering" "auto"
        , alignSelf center
        ]
    , Css.class ButtonsContainer
        [ textAlign center ]
    , Css.class Button
        [ display inlineBlock
        , marginRight (px 8)
        ]
    ]
        |> namespace loadedNamespace
        |> stylesheet


loadedNamespace : String
loadedNamespace =
    Html.Custom.makeNamespace "LoadedModule"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace loadedNamespace


view : Canvas -> Html Msg
view canvas =
    [ div
        [ class [ CanvasContainer ] ]
        [ Canvas.toHtml
            [ class [ UploadedCanvas ] ]
            canvas
        ]
    , p
        [ class [ Text ] ]
        [ Html.text loadedText ]
    , buttons
    ]
        |> Html.Custom.cardBody []


loadedText : String
loadedText =
    """
    Would you like to bring this in as a selection,
    or just replace the whole canvas with your image?
    Replacing the canvas will whip out the current state of the canvas.
    """


buttons : Html Msg
buttons =
    div
        [ class [ ButtonsContainer ] ]
        [ Html.Custom.menuButton
            [ class [ Button ]
            , onClick AsSelectionClicked
            ]
            [ Html.text "load as selecton" ]
        , Html.Custom.menuButton
            [ class [ Button ]
            , onClick AsCanvasClicked
            ]
            [ Html.text "load as canvas" ]
        ]
