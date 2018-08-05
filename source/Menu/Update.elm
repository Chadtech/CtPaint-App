module Menu.Update exposing (update)

import Data.Position as Position
import Data.Taco exposing (Taco)
import Menu.BugReport as BugReport
import Menu.Data as Menu exposing (Menu(..))
import Menu.Download as Download
import Menu.Drawing as Drawing
import Menu.Import as Import
import Menu.Login as Login
import Menu.Logout as Logout
import Menu.Model exposing (ClickState(..), Model)
import Menu.Msg exposing (Msg(..))
import Menu.New as New
import Menu.ReplaceColor as ReplaceColor
import Menu.Reply exposing (Reply(CloseMenu))
import Menu.Resize as Resize
import Menu.Save as Save
import Menu.Scale as Scale
import Menu.Text as Text
import Menu.Upload as Upload
import MouseEvents exposing (MouseEvent)
import Return2 as R2
import Return3 as R3 exposing (Return)


-- UPDATE --


update : Taco -> Msg -> Model -> Return Model Msg Reply
update taco msg model =
    case msg of
        XButtonMouseDown ->
            { model
                | click = XButtonIsDown
            }
                |> R3.withNothing

        XButtonMouseUp ->
            model
                |> R2.withNoCmd
                |> R3.withReply CloseMenu

        HeaderMouseDown mouseEvent ->
            case model.click of
                XButtonIsDown ->
                    model
                        |> R3.withNothing

                _ ->
                    handleHeaderMouseDown
                        taco
                        mouseEvent
                        model

        HeaderMouseMove p ->
            case model.click of
                ClickAt click ->
                    { model
                        | position =
                            { x = p.x - click.x - 4
                            , y = p.y - click.y - 4
                            }
                    }
                        |> R3.withNothing

                _ ->
                    model
                        |> R3.withNothing

        HeaderMouseUp p ->
            { model | click = NoClick }
                |> R2.withNoCmd
                |> R3.withNoReply

        DownloadMsg subMsg ->
            case model.content of
                Download subModel ->
                    subModel
                        |> Download.update taco subMsg
                        |> mapReturn model Menu.Download DownloadMsg

                _ ->
                    model |> R3.withNothing

        ImportMsg subMsg ->
            case model.content of
                Import subModel ->
                    subModel
                        |> Import.update taco subMsg
                        |> mapReturn model Menu.Import ImportMsg

                _ ->
                    model |> R3.withNothing

        ScaleMsg subMsg ->
            case model.content of
                Scale subModel ->
                    subModel
                        |> Scale.update taco subMsg
                        |> mapReturn model Menu.Scale ScaleMsg

                _ ->
                    model |> R3.withNothing

        TextMsg subMsg ->
            case model.content of
                Text subModel ->
                    subModel
                        |> Text.update taco subMsg
                        |> mapReturn model Menu.Text TextMsg

                _ ->
                    model |> R3.withNothing

        BugReportMsg subMsg ->
            case model.content of
                BugReport subModel ->
                    subModel
                        |> BugReport.update taco subMsg
                        |> mapReturn model Menu.BugReport BugReportMsg

                _ ->
                    model |> R3.withNothing

        ReplaceColorMsg subMsg ->
            case model.content of
                ReplaceColor subModel ->
                    subModel
                        |> ReplaceColor.update taco subMsg
                        |> mapReturn model Menu.ReplaceColor ReplaceColorMsg

                _ ->
                    model |> R3.withNothing

        LoginMsg subMsg ->
            case model.content of
                Login subModel ->
                    subModel
                        |> Login.update taco subMsg
                        |> mapReturn model Menu.Login LoginMsg

                _ ->
                    model |> R3.withNothing

        UploadMsg subMsg ->
            case model.content of
                Upload subModel ->
                    subModel
                        |> Upload.update subMsg
                        |> mapReturn model Menu.Upload UploadMsg

                _ ->
                    model |> R3.withNothing

        ResizeMsg subMsg ->
            case model.content of
                Resize subModel ->
                    subModel
                        |> Resize.update taco subMsg
                        |> mapReturn model Menu.Resize ResizeMsg

                _ ->
                    model |> R3.withNothing

        NewMsg subMsg ->
            case model.content of
                New subModel ->
                    subModel
                        |> New.update taco subMsg
                        |> mapReturn model Menu.New NewMsg

                _ ->
                    model |> R3.withNothing

        DrawingMsg subMsg ->
            case model.content of
                Drawing subModel ->
                    subModel
                        |> Drawing.update taco subMsg
                        |> mapReturn model Menu.Drawing DrawingMsg

                _ ->
                    model |> R3.withNothing

        SaveMsg subMsg ->
            case model.content of
                Save subModel ->
                    subModel
                        |> Save.update taco subMsg
                        |> mapReturn model Menu.Save SaveMsg

                _ ->
                    model
                        |> R3.withNothing

        LogoutMsg subMsg ->
            case model.content of
                Logout ->
                    Logout.update subMsg
                        |> R3.withTuple ( model, Cmd.none )

                _ ->
                    model
                        |> R3.withNothing


handleHeaderMouseDown : Taco -> MouseEvent -> Model -> Return Model Msg Reply
handleHeaderMouseDown taco mouseEvent model =
    { model
        | click =
            mouseEvent
                |> Position.relativeToTarget
                |> ClickAt
    }
        |> R2.withNoCmd
        |> R3.withNoReply


mapReturn : Model -> (a -> Menu) -> (b -> Msg) -> Return a b Reply -> Return Model Msg Reply
mapReturn model toMenu toMsg return =
    return
        |> R3.mapModel (setContent toMenu model)
        |> R3.mapCmd toMsg


setContent : (a -> Menu) -> Model -> a -> Model
setContent toMenu model subModel =
    { model | content = toMenu subModel }
