module AllowanceExceeded
    exposing
        ( Msg
        , update
        , view
        )

import Html exposing (Html)
import Reply exposing (Reply(GoToRegisterPage))


-- TYPES --


type Msg
    = RegisterClicked



-- UPDATE --


update : Msg -> Reply
update msg =
    case msg of
        RegisterClicked ->
            GoToRegisterPage



-- VIEW --


view : List (Html Msg)
view =
    Html.text ""
        |> List.singleton
