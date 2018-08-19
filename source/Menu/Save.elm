module Menu.Save
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
import Data.Drawing exposing (Drawing)
import Data.Window as Window exposing (Window(Home))
import Html exposing (Html, a, div, p)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)
import Menu.Reply
    exposing
        ( Reply
            ( CloseMenu
            , IncorporateDrawing
            , TrySaving
            )
        )
import Return2 as R2
import Return3 as R3 exposing (Return)
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


type alias Payload a =
    { a | mountPath : String }


update : Payload a -> Msg -> Model -> Return Model Msg Reply
update { mountPath } msg model =
    case msg of
        DrawingUpdateCompleted (Ok "200") ->
            Util.delay 1000 (OneSecondExpired Nothing)
                |> R2.withModel Success
                |> R3.withNoReply

        DrawingUpdateCompleted (Ok code) ->
            code
                |> Other
                |> Failed
                |> R3.withNothing

        DrawingUpdateCompleted (Err err) ->
            err
                |> Other
                |> Failed
                |> R3.withNothing

        DrawingCreateCompleted (Ok drawing) ->
            drawing
                |> Just
                |> OneSecondExpired
                |> Util.delay 1000
                |> R2.withModel Success
                |> R3.withNoReply

        DrawingCreateCompleted (Err err) ->
            err
                |> toError
                |> Failed
                |> R3.withNothing

        OneSecondExpired Nothing ->
            CloseMenu
                |> R3.withTuple ( model, Cmd.none )

        OneSecondExpired (Just drawing) ->
            IncorporateDrawing drawing
                |> R3.withTuple ( model, Cmd.none )

        OpenHomeClicked ->
            Window.open mountPath Home
                |> R2.withModel model
                |> R3.withNoReply

        TryAgainClicked ->
            model
                |> R2.withNoCmd
                |> R3.withReply TrySaving


toError : String -> Error
toError err =
    case err of
        "Error: Request failed with status code 403" ->
            ExceededMemoryLimit

        _ ->
            Other err



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
