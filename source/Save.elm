module Save
    exposing
        ( Model
        , Msg(..)
        , css
        , init
        , update
        , view
        )

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html, div, p)
import Html.CssHelpers
import Html.Custom
import Reply exposing (Reply(CloseMenu, NoReply))
import Tuple.Infix exposing ((&))
import Util


type Model
    = Saving String
    | Failed String
    | Success


type Msg
    = DrawingSaveCompleted (Result String String)
    | OneSecondExpired



-- INIT --


init : String -> Model
init =
    Saving



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg, Reply )
update msg model =
    case msg of
        DrawingSaveCompleted (Ok "200") ->
            ( Success
            , Util.delay 1000 OneSecondExpired
            , NoReply
            )

        DrawingSaveCompleted (Ok code) ->
            Failed code
                |> Reply.nothing

        DrawingSaveCompleted (Err err) ->
            Failed err
                |> Reply.nothing

        OneSecondExpired ->
            ( model
            , Cmd.none
            , CloseMenu
            )



-- STYLES --


type Class
    = Text


css : Stylesheet
css =
    [ Css.class Text
        [ marginBottom (px 8) ]
    ]
        |> namespace saveNamespace
        |> stylesheet


saveNamespace : String
saveNamespace =
    Html.Custom.makeNamespace "SaveModule"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace saveNamespace


view : Model -> List (Html msg)
view model =
    case model of
        Saving str ->
            [ p
                [ class [ Text ] ]
                [ Html.text (savingText str) ]
            , Html.Custom.spinner []
            ]

        Failed error ->
            [ p
                [ class [ Text ] ]
                [ Html.text "Oh no, there was a problem saving" ]
            ]

        Success ->
            [ p 
                [ class [ Text ] ]
                [ Html.text "Save succeeded!" ]
            ]


savingText : String -> String
savingText str =
    "saving \"" ++ str ++ "\""
