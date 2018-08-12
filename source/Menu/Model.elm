module Menu.Model
    exposing
        ( ClickState(..)
        , Model
        , initAbout
        , initBugReport
        , initDownload
        , initDrawing
        , initImport
        , initLoading
        , initLogin
        , initLogout
        , initNew
        , initReplaceColor
        , initResize
        , initSave
        , initScale
        , initText
        , initUpload
        )

import Color exposing (Color)
import Position.Data as Position
    exposing
        ( Position
        )
import Data.Size as Size exposing (Size)
import Menu.BugReport as BugReport
import Menu.Data as Menu exposing (Menu)
import Menu.Download as Download
import Menu.Drawing as Drawing
import Menu.Import as Import
import Menu.Loading as Loading
import Menu.Login as Login
import Menu.New as New
import Menu.ReplaceColor as ReplaceColor
import Menu.Resize as Resize
import Menu.Save as Save
import Menu.Scale as Scale
import Menu.Text as Text
import Menu.Upload as Upload


-- TYPES --


type alias Model =
    { position : Position
    , click : ClickState
    , title : String
    , content : Menu
    }


type ClickState
    = NoClick
    | XButtonIsDown
    | ClickAt Position


init : String -> Menu -> Size -> Size -> Model
init title content cardSize windowSize =
    { position =
        { x = (windowSize.width - cardSize.width) // 2
        , y = (windowSize.height - cardSize.height) // 2
        }
    , click = NoClick
    , title = title
    , content = content
    }


initLogin : Size -> Model
initLogin =
    { width = 369
    , height = 147
    }
        |> init "login" (Menu.Login Login.init)


initNew : String -> Size -> Model
initNew name =
    { width = 466
    , height = 211
    }
        |> init "new" (Menu.New (New.init name))


initText : Size -> Model
initText =
    { width = 506
    , height = 313
    }
        |> init "text" (Menu.Text Text.init)


initBugReport : Bool -> Size -> Model
initBugReport loggedIn =
    { width = 420
    , height = 209
    }
        |> init
            "report bug"
            (Menu.BugReport (BugReport.init loggedIn))


initScale : Size -> Size -> Model
initScale canvasSize =
    let
        scale =
            canvasSize
                |> Scale.init
                |> Menu.Scale
    in
    { width = 730
    , height = 152
    }
        |> init "scale" scale


initImport : Size -> Model
initImport =
    { width = 420
    , height = 115
    }
        |> init "import" (Menu.Import Import.init)


initDownload : Download.Flags -> Size -> Model
initDownload flags =
    { width = 365
    , height = 155
    }
        |> init "download"
            (Menu.Download (Download.init flags))


initAbout : Int -> Size -> Model
initAbout buildNumber =
    { width = 416
    , height = 292
    }
        |> init "about"
            (Menu.About { buildNumber = buildNumber })


initReplaceColor : Color -> Color -> List Color -> Size -> Model
initReplaceColor target replacement palette =
    let
        replaceColor =
            ReplaceColor.init target replacement palette
                |> Menu.ReplaceColor
    in
    init "replace color"
        replaceColor
        { width = 308
        , height = 196
        }


initUpload : Size -> Model
initUpload =
    { width = 524
    , height = 558
    }
        |> init "upload" (Menu.Upload Upload.init)


initResize : Size -> Size -> Model
initResize canvasSize =
    init "resize"
        (Menu.Resize (Resize.init canvasSize))
        { width = 180
        , height = 303
        }


initDrawing : String -> Size -> Model
initDrawing name =
    init "drawing"
        (Menu.Drawing (Drawing.init name))
        { width = 369
        , height = 115
        }


initLoading : Maybe String -> Size -> Model
initLoading maybeName =
    init "loading"
        (Menu.Loading (Loading.init maybeName))
        { width = 224
        , height = 99
        }


initLogout : Size -> Model
initLogout =
    { width = 420
    , height = 191
    }
        |> init "logout" Menu.Logout


initSave : String -> Size -> Model
initSave name =
    { width = 295
    , height = 99
    }
        |> init
            "saving"
            (Menu.Save (Save.init name))
