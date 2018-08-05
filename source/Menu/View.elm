module Menu.View
    exposing
        ( css
        , view
        )

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Attribute, Html)
import Html.Attributes exposing (style)
import Html.CssHelpers
import Html.Custom
import Menu.About as About
import Menu.BugReport as BugReport
import Menu.Data exposing (Menu(..))
import Menu.Download as Download
import Menu.Drawing as Drawing
import Menu.Import as Import
import Menu.Loading as Loading
import Menu.Login as Login
import Menu.Logout as Logout
import Menu.Model exposing (Model)
import Menu.Msg exposing (Msg(..))
import Menu.New as New
import Menu.ReplaceColor as ReplaceColor
import Menu.Resize as Resize
import Menu.Save as Save
import Menu.Scale as Scale
import Menu.Text as Text
import Menu.Upload as Upload
import Util


-- STYLES --


type Class
    = Container
    | Unpositioned
    | ImportCard


css : Stylesheet
css =
    [ Css.class Container
        [ position absolute ]
    , Css.class Unpositioned
        [ left (pct 25)
        , top (pct 25)
        , display inlineBlock
        , position absolute
        ]
    , Css.class ImportCard
        [ width (px 420) ]
    ]
        |> namespace menuNamespace
        |> stylesheet


menuNamespace : String
menuNamespace =
    Html.Custom.makeNamespace "Menu"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace menuNamespace


view : Maybe Model -> Html Msg
view maybeModel =
    case maybeModel of
        Just model ->
            Html.Custom.card
                (cardAttrs model)
                [ Html.Custom.header
                    { text = model.title
                    , headerMouseDown = HeaderMouseDown
                    , xButtonMouseDown = XButtonMouseDown
                    , xButtonMouseUp = XButtonMouseUp
                    }
                , contentView model.content
                ]

        Nothing ->
            Html.text ""


cardAttrs : Model -> List (Attribute Msg)
cardAttrs ({ position } as model) =
    [ style
        [ Util.top position.y
        , Util.left position.x
        ]
    , [ Container ]
        |> Util.maybeCons (extraClass model)
        |> class
    ]


extraClass : Model -> Maybe Class
extraClass model =
    case model.content of
        Import _ ->
            Just ImportCard

        _ ->
            Nothing


contentView : Menu -> Html Msg
contentView menu =
    case menu of
        Download subModel ->
            subModel
                |> Download.view
                |> Html.map DownloadMsg

        Import subModel ->
            subModel
                |> Import.view
                |> Html.map ImportMsg

        Scale subModel ->
            subModel
                |> Scale.view
                |> Html.map ScaleMsg

        Text subModel ->
            subModel
                |> Text.view
                |> Html.map TextMsg

        BugReport subModel ->
            subModel
                |> BugReport.view
                |> Html.map BugReportMsg

        About state ->
            About.view state

        ReplaceColor subModel ->
            subModel
                |> ReplaceColor.view
                |> Html.map ReplaceColorMsg

        New subModel ->
            subModel
                |> New.view
                |> Html.map NewMsg

        Login subModel ->
            subModel
                |> Login.view
                |> Html.map LoginMsg

        Loading subModel ->
            Loading.view subModel

        Upload subModel ->
            subModel
                |> Upload.view
                |> Html.map UploadMsg

        Resize subModel ->
            subModel
                |> Resize.view
                |> Html.map ResizeMsg

        Drawing subModel ->
            subModel
                |> Drawing.view
                |> Html.map DrawingMsg

        Save subModel ->
            subModel
                |> Save.view
                |> Html.map SaveMsg

        Logout ->
            Logout.view
                |> Html.map LogoutMsg
