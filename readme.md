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
├── Canvas.elm
├── Clipboard.elm
├── ColorPicker.elm
├── Draw.elm
├── History.elm
├── Keyboard
│   ├── Subscriptions.elm
│   └── Update.elm
├── Main.elm
├── Menu
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
│   ├── MsgMap.elm
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
│   └── Update.elm
├── Menu.elm
├── Minimap
│   ├── Incorporate.elm
│   ├── Mouse.elm
│   ├── Types.elm
│   ├── Update.elm
│   └── View.elm
├── Native
│   └── Canvas.js
├── Palette
│   ├── Init.elm
│   ├── Types.elm
│   ├── Update.elm
│   └── View.elm
├── Ports.elm
├── Styles
│   ├── Main.styl
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
├── Subscriptions.elm
├── Taskbar.elm
├── Tool
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
├── Toolbar
│   └── View.elm
├── Types.elm
├── Update.elm
├── Util.elm
├── View.elm
└── app.coffee
```

