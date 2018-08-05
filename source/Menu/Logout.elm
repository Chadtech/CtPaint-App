module Menu.Logout
    exposing
        ( Msg
        , css
        , update
        , view
        )

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html, p)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)
import Menu.Reply exposing (Reply(Logout))


-- TYPES --


type Msg
    = LogoutClicked



-- UPDATE --


update : Msg -> Reply
update LogoutClicked =
    Logout



-- SYTLES --


type Class
    = Text


css : Stylesheet
css =
    [ Css.class Text
        [ maxWidth (px 400)
        , marginBottom (px 8)
        ]
    ]
        |> namespace logoutNamespace
        |> stylesheet


logoutNamespace : String
logoutNamespace =
    Html.Custom.makeNamespace "Logout"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace logoutNamespace


view : Html Msg
view =
    [ p
        [ class [ Text ] ]
        [ Html.text warningText ]
    , Html.Custom.menuButton
        [ onClick LogoutClicked ]
        [ Html.text "logout anyway" ]
    ]
        |> Html.Custom.cardBody []


warningText : String
warningText =
    """
    You are in the middle of a drawing. If you log out this
    drawing will close and you will lose an unsaved changes.
    Would you like to logout anyway?
    """
