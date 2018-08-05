module Menu.Data
    exposing
        ( Menu(..)
        , toString
        )

import Data.Drawing exposing (Drawing)
import Data.User exposing (User)
import Menu.About
import Menu.BugReport
import Menu.Download
import Menu.Drawing
import Menu.Import
import Menu.Loading
import Menu.Login
import Menu.Logout
import Menu.New
import Menu.ReplaceColor
import Menu.Resize
import Menu.Save
import Menu.Scale
import Menu.Text
import Menu.Upload


-- TYPES --


type Menu
    = Download Menu.Download.Model
    | Import Menu.Import.Model
    | Scale Menu.Scale.Model
    | Text String
    | BugReport Menu.BugReport.Model
    | About Menu.About.State
    | ReplaceColor Menu.ReplaceColor.Model
    | New Menu.New.Model
    | Login Menu.Login.Model
    | Loading Menu.Loading.Model
    | Upload Menu.Upload.Model
    | Resize Menu.Resize.Model
    | Drawing Menu.Drawing.Model
    | Save Menu.Save.Model
    | Logout



-- HELPERS --


toString : Menu -> String
toString menu =
    case menu of
        Download _ ->
            "download"

        Import _ ->
            "import"

        Scale _ ->
            "scale"

        Text _ ->
            "text"

        BugReport _ ->
            "bug-report"

        About _ ->
            "about"

        ReplaceColor _ ->
            "replace-color"

        New _ ->
            "new"

        Login _ ->
            "login"

        Loading _ ->
            "loading"

        Upload _ ->
            "upload"

        Resize _ ->
            "resize"

        Drawing _ ->
            "drawing"

        Save _ ->
            "save"

        Logout ->
            "logout"
