module Save
    exposing
        ( Model
        , Msg(..)
        , css
        , init
        , update
        , view
        )

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Config exposing (Config)
import Data.Drawing exposing (Drawing)
import Data.Window exposing (Window(Home))
import Helpers.Window
import Html exposing (Html, a, div, p)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)
import Reply
    exposing
        ( Reply
            ( CloseMenu
            , IncorporateDrawing
            , NoReply
            , TrySaving
            )
        )
import Util


type Model
    = Saving String
    | Failed Error
    | Success


type Error
    = ExceededMemoryLimit
    | Other String


type Msg
    = DrawingUpdateCompleted (Result String String)
    | DrawingCreateCompleted (Result String Drawing)
    | OneSecondExpired (Maybe Drawing)
    | OpenHomeClicked
    | TryAgainClicked



-- INIT --


init : String -> Model
init =
    Saving



-- UPDATE --


update : Config -> Msg -> Model -> ( Model, Cmd Msg, Reply )
update config msg model =
    case msg of
        DrawingUpdateCompleted (Ok "200") ->
            ( Success
            , Util.delay 1000 (OneSecondExpired Nothing)
            , NoReply
            )

        DrawingUpdateCompleted (Ok code) ->
            code
                |> Other
                |> Failed
                |> Reply.nothing

        DrawingUpdateCompleted (Err err) ->
            err
                |> Other
                |> Failed
                |> Reply.nothing

        DrawingCreateCompleted (Ok drawing) ->
            ( Success
            , drawing
                |> Just
                |> OneSecondExpired
                |> Util.delay 1000
            , NoReply
            )

        DrawingCreateCompleted (Err "Error: Request failed with status code 403") ->
            ExceededMemoryLimit
                |> Failed
                |> Reply.nothing

        DrawingCreateCompleted (Err err) ->
            err
                |> Other
                |> Failed
                |> Reply.nothing

        OneSecondExpired Nothing ->
            ( model
            , Cmd.none
            , CloseMenu
            )

        OneSecondExpired (Just drawing) ->
            ( model
            , Cmd.none
            , IncorporateDrawing drawing
            )

        OpenHomeClicked ->
            ( model
            , Helpers.Window.openWindow
                config.mountPath
                Home
            , NoReply
            )

        TryAgainClicked ->
            ( model
            , Cmd.none
            , TrySaving
            )



-- STYLES --


type Class
    = Text
    | ButtonsContainer
    | Button
    | Error


css : Stylesheet
css =
    [ Css.class Text
        [ marginBottom (px 8)
        , maxWidth (px 500)
        ]
    , Css.class ButtonsContainer
        [ displayFlex
        , justifyContent center
        ]
    , Css.class Button
        [ marginLeft (px 8) ]
    , Css.class Error
        [ backgroundColor Ct.lowWarning ]
    ]
        |> namespace saveNamespace
        |> stylesheet


saveNamespace : String
saveNamespace =
    Html.Custom.makeNamespace "SaveModule"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace saveNamespace


view : Model -> Html Msg
view model =
    case model of
        Saving str ->
            [ p
                [ class [ Text ] ]
                [ Html.text (savingText str) ]
            , Html.Custom.spinner []
            ]
                |> Html.Custom.cardBody []

        Failed (Other _) ->
            [ p
                [ class [ Text ] ]
                [ Html.text "Oh no, there was a problem saving" ]
            ]
                |> Html.Custom.cardBody [ class [ Error ] ]

        Failed ExceededMemoryLimit ->
            [ p
                [ class [ Text ] ]
                [ Html.text exceededText ]
            , div
                [ class [ ButtonsContainer ] ]
                [ a
                    [ class [ Button ]
                    , onClick TryAgainClicked
                    ]
                    [ Html.text "try again" ]
                , a
                    [ class [ Button ]
                    , onClick OpenHomeClicked
                    ]
                    [ Html.text "open drawings page" ]
                ]
            ]
                |> Html.Custom.cardBody [ class [ Error ] ]

        Success ->
            [ p
                [ class [ Text ] ]
                [ Html.text "Save succeeded!" ]
            ]
                |> Html.Custom.cardBody []


exceededText : String
exceededText =
    """
    Your account tier only permits one drawing
    of cloud storage. You already have a drawing stored,
    so you need to delete it in order to save this drawing.
    To delete it, go to your drawings page and delete the
    drawing you have in memory. If you click the button below,
    the drawings page will open in a new window.
    """


savingText : String -> String
savingText str =
    "saving \"" ++ str ++ "\""
