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
./source
├── Canvas.elm           -- Basic canvas functions
├── Clipboard.elm        -- Copy, paste, cut
├── ColorPicker          -- Color picker widget
│   ├── Incorporate.elm
│   ├── Mouse.elm
│   ├── Types.elm
│   ├── Update.elm
│   ├── Util.elm
│   └── View.elm
├── Draw                 -- Basic drawing functions, uses Canvas.elm
│   ├── Line.elm
│   ├── Pixel.elm
│   ├── Rectangle.elm
│   ├── Select.elm
│   └── Util.elm
├── History.elm          -- Undo, Redo
├── Keyboard             -- Handling global keyboard events
│   ├── Subscriptions.elm
│   ├── Types.elm
│   └── Update.elm
├── Main.elm             -- Primary Elm File
├── Menu                 -- Various menus that can pop open
│   ├── Download
│   │   ├── Incorporate.elm
│   │   ├── Mouse.elm
│   │   ├── Ports.elm
│   │   ├── Types.elm
│   │   ├── Update.elm
│   │   └── View.elm
│   ├── Import
│   │   ├── Incorporate.elm
│   │   ├── Mouse.elm
│   │   ├── Types.elm
│   │   ├── Update.elm
│   │   └── View.elm
│   ├── MsgMap.elm       -- Helper to map messages to higher Msg type
│   ├── Ports.elm        
│   ├── Scale
│   │   ├── Incorporate.elm
│   │   ├── Mouse.elm
│   │   ├── Types.elm
│   │   ├── Update.elm
│   │   └── View.elm
│   ├── Text
│   │   ├── Incorporate.elm
│   │   ├── Types.elm
│   │   ├── Update.elm
│   │   └── View.elm
│   ├── Types.elm
│   └── Update.elm
├── Minimap              -- Mini view of whole canvas
│   ├── Incorporate.elm
│   ├── Mouse.elm
│   ├── Types.elm
│   ├── Update.elm
│   └── View.elm
├── Native               -- Native Elm code, JS canvas functions
│   └── Canvas.js
├── Palette              -- Color palette stuff
│   ├── Init.elm
│   ├── Types.elm
│   ├── Update.elm
│   └── View.elm
├── Ports.elm            -- JS and Elm interop
├── Styles
│   ├── Main.styl        -- Main css style file
│   ├── a.styl
│   ├── canvas.styl
│   ├── card.styl
│   ├── color-picker.styl
│   ├── download.styl
│   ├── form.styl
│   ├── import.styl
│   ├── minimap.styl
│   ├── p.styl
│   ├── palette.styl
│   ├── scale.styl
│   ├── tool-button.styl
│   └── toolbar.styl
├── Subscriptions.elm    -- Highest subscriptions module
├── Taskbar              -- Top menu bar
│   ├── Types.elm
│   ├── Update.elm
│   └── View.elm
├── Tool                 -- All tools
│   ├── Fill.elm
│   ├── Hand
│   │   └── Update.elm
│   ├── Hand.elm
│   ├── Line
│   │   └── Update.elm
│   ├── Line.elm
│   ├── Pencil
│   │   └── Update.elm
│   ├── Pencil.elm
│   ├── Rectangle
│   │   └── Update.elm
│   ├── Rectangle.elm
│   ├── RectangleFilled
│   │   └── Update.elm
│   ├── RectangleFilled.elm
│   ├── Sample.elm
│   ├── Select
│   │   └── Update.elm
│   ├── Select.elm
│   ├── Update.elm
│   ├── Util.elm
│   └── Zoom.elm
├── Tool.elm
├── Toolbar              -- Left menu bar
│   └── View.elm
├── Types.elm            -- Model, init, Msg, basic types.
├── Update.elm           -- Top Update function
├── Util.elm
├── View.elm             -- Top View function
└── app.coffee           -- Primary JS file
```

