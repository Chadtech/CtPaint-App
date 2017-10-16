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
├── About.elm
├── Canvas.elm
├── Clipboard.elm
├── ColorPicker.elm
├── Command.elm
├── Download.elm
├── Draw.elm
├── Hfnss.elm
├── History.elm
├── Imgur.elm
├── Import.elm
├── Main.elm
├── Menu.elm
├── Minimap.elm
├── Native
│   └── Canvas.js
├── Palette.elm
├── Ports.elm
├── ReplaceColor.elm
├── Scale.elm
├── Styles
│   ├── Main.styl
│   ├── a.styl
│   ├── canvas.styl
│   ├── card.styl
│   ├── color-picker.styl
│   ├── form.styl
│   ├── menu.styl
│   ├── minimap.styl
│   ├── p.styl
│   ├── palette.styl
│   ├── tool-button.styl
│   └── toolbar.styl
├── Subscriptions.elm
├── Taskbar.elm
├── Text.elm
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
│   ├── Zoom
│   │   └── Util.elm
│   └── Zoom.elm
├── Tool.elm
├── Toolbar.elm
├── Types.elm
├── Update.elm
├── Util.elm
├── View.elm
└── app.coffee
```

