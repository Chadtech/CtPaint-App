# CtPaint : App

This is CtPaint, an image editor that runs in your web browser.

## Quick start

```
npm install
elm package install
gulp
````

then go to `localhost:2970`


This repo is organized as..

```
app.coffee              main file, handles AWS stuff and launches Elm app
Ports.elm               ports file for js - elm inter operations
Main.elm                main Elm file
Canvas.elm              Canvas package for Elm
Main/
    Init.elm            Initialized Elm model from JSON flags
    Message.elm         Top level message definition
    Model.elm           Top level model definition
    Subscriptions.elm   Listeners in Elm on various document events
    Update.elm          Top level update function
    View.elm            Top level view function
Native/
    Canvas.js           Native js for Canvas.elm
Style/
    a.styl              Button styles
    canvas.styl
    card.styl
    color-picker.styl
    form.styl
    Main.styl           Color definitions, font definitions
    p.styl
    palette.styl
    tool-button.styl
    toolbar.styl
Types/
    Mouse.elm
    Session.elm         User session type definition
ColorPicker/
    Handle.elm          Handle result from colorpicker update function
    Mouse.elm           Colorpicker mouse handling
    Types.elm           
    Update.elm          Colorpicker update function
    Util.elm
    View.elm
Draw/                   Basic canvas drawing stuff
    Line.elm
    Pixel.elm
    Rectangle.elm
    Select.elm
    Util.elm
History/
    Types.elm
    Update.elm          Undo and redo stuff
Keyboard/
    Types.elm
    Update.elm          Global keyboard event handling
Palette/
    Init.elm
    Types.elm
    View.elm            View for all color stuff in the bottom horizontal bar
Tool/
    Hand/
        Mouse.elm
        Types.elm
        Update.elm
    Pencil/
        Mouse.elm
        Types.elm
        Update.elm
    Rectangle/
        Mouse.elm
        Types.elm
        Update.elm
    RectangleFilled/
        Mouse.elm
        Types.elm
        Update.elm
    Sample/
        Mouse.elm
        Types.elm
        Update.elm
    Select/
        Mouse.elm
        Types.elm
        Update.elm
    ZoomIn/
        Mouse.elm
        Types.elm
        Update.elm
    ZoomOut/
        Mouse.elm
        Types.elm
        Update.elm
    Types.elm
    Util.elm
    Zoom.elm
Toolbar/
    Horizontal/
        Types.elm
        Update.elm      Mostly resizing the horizontal bar
        View.elm
    Top/
        View.elm
    Vertical/
        View.elm
```

