/*global _elm_lang$core$Native_List */
/*global _elm_lang$core$Color$toRgb */
/*global _elm_lang$core$Native_Scheduler */
/*global _elm_lang$virtual_dom$Native_VirtualDom */


var _program_house$ctpaint_app$Native_Canvas = function () {  // eslint-disable-line no-unused-vars


  function LOG(msg) { // eslint-disable-line no-unused-vars
    // console.log(msg);
  }


  function makeModel(canvas) {

    // The elm debugger crashes when it tries to
    // traverse an html object. So instead
    // of passing along a canvas element, we
    // pass along a function that returns it
    function getCanvas() {
      return canvas;
    }

    return {
      ctor: "Canvas",
      canvas: getCanvas,
      width: canvas.width,
      height: canvas.height
    };
  }

  // This is how we ensure immutability.
  // Canvas elements are never modified
  // and passed along. They are copied,
  // and the clone is passed along.
  function cloneModel(model) {

    var canvas = document.createElement("canvas");
    canvas.width = model.width;
    canvas.height = model.height;

    var ctx = canvas.getContext("2d");
    ctx.drawImage(model.canvas(), 0, 0);

    return makeModel(canvas);

  }


  function initialize(size) {

    var canvas = document.createElement("canvas");
    canvas.width = size.width;
    canvas.height = size.height;

    return makeModel(canvas);

  }


  function draw(drawOp, model) {
    model = cloneModel(model);

    var ctx = model.canvas().getContext("2d");

    handleDrawOp(ctx, drawOp);


    return model;
  }

  function replace(targetColor, replacementColor, model) {
    model = cloneModel(model);

    var target = _elm_lang$core$Color$toRgb(targetColor);
    var replacement = _elm_lang$core$Color$toRgb(replacementColor);

    var ctx = model.canvas().getContext("2d");

    var imageData = ctx.getImageData(0,0,model.width, model.height);
    var data = imageData.data;

    var redSame, blueSame, greenSame;
    var index = 0;
    while (index < data.length) {
      redSame = data[ index ] === target.red;
      greenSame = data[ index + 1 ] == target.green;
      blueSame = data[ index + 2 ] == target.blue;

      if (redSame && greenSame && blueSame) {
        data[ index ] = replacement.red;
        data[ index + 1 ] = replacement.green;
        data[ index + 2 ] = replacement.blue;
      }

      index += 4;
    }

    ctx.putImageData(imageData, 0, 0);

    return model;
  }

  function scale(w, h, model) {
    model = cloneModel(model);

    var ctx = model.canvas().getContext("2d");
    var imageData = ctx.getImageData(
      0,
      0,
      model.width, 
      model.height
    );

    var i = 0;
    var data = [];
    while (i < imageData.data.length) {
      data.push(imageData.data[i]);
      i++;
    }

    var rows = groupBy(groupBy(data, 4), model.width);

    i = 0;
    while (i < rows.length) {
      rows[i] = scaleBy(w / model.width, rows[i]);
      i++;
    }

    var scaledData = scaleBy(h / model.height, rows);
    data = flatten(flatten(scaledData));

    var newModel = initialize({ width: w, height: h});
    ctx = newModel.canvas().getContext("2d");

    var newImageData = ctx.createImageData(w, h);

    i = 0;
    while (i < data.length) {
      newImageData.data[ i ] = data[ i ];
      i++;
    }

    ctx.putImageData(newImageData, 0, 0);

    return newModel;
  }

  function scaleBy(factor, items) {
    var newItems = [];

    var i = 0;
    while (i < items.length) {
      var j = 0;
      var repeats = Math.floor((i + 1) * factor) - Math.floor(i * factor);
      while (j < repeats) {
        newItems.push(items[i]);
        j++;
      }
      i++;
    }

    return newItems;
  }

  function groupBy(input, spacing) {
    var output = [];

    for (var i = 0; i < input.length; i += spacing) {
      output[output.length] = input.slice(i, i + spacing);
    }

    return output;
  }

  function flatten(array, mutable) {
      var toString = Object.prototype.toString;
      var arrayTypeStr = '[object Array]';
      
      var result = [];
      var nodes = (mutable && array) || array.slice();
      var node;

      if (!array.length) {
          return result;
      }

      node = nodes.pop();
      
      do {
          if (toString.call(node) === arrayTypeStr) {
              nodes.push.apply(nodes, node);
          } else {
              result.push(node);
          }
      } while (nodes.length && (node = nodes.pop()) !== undefined);

      result.reverse(); // we reverse result to restore the original order
      return result;
  }

  function handleDrawOp (ctx, drawOp) {
    var point, point1, size, color;

    ctx.imageSmoothingEnabled = false;

    switch (drawOp.ctor) {
    case "Batch" :
      var drawOps = drawOp._0;

      while (drawOps.ctor !== "[]") {
        handleDrawOp(ctx, drawOps._0);

        drawOps = drawOps._1;
      }

      break;

    case "Font" :

      ctx.font = drawOp._0;
      break;

    case "Arc" :

      point = drawOp._0;

      ctx.arc(point.x, point.y, drawOp._1, drawOp._2, drawOp._3);
      break;

    case "ArcTo" :

      point = drawOp._0;
      point1 = drawOp._1;

      ctx.arcTo(point.x, point.y, point1._0, point1._1, drawOp._2);
      break;

    case "StrokeText" :

      point = drawOp._1;

      ctx.strokeText(drawOp._0, point.x, point.y);
      break;

    case "FillText" :

      point = drawOp._1;

      ctx.fillText(drawOp._0, point.x, point.y);
      break;

    case "GlobalCompositionOp" :

      ctx.globalCompositeOperation = drawOp._0;
      break;

    case "LineCap" :

      ctx.lineCap = drawOp._0;
      break;

    case "LineJoin" :

      ctx.lineJoin = drawOp._0;
      break;

    case "GlobalAlpha" :

      ctx.globalAlpha = drawOp._0;
      break;

    case "LineDashOffset" :

      ctx.lineDashOffset = drawOp._0;
      break;

    case "LineWidth" :

      ctx.lineWidth = drawOp._0;
      break;

    case "MiterLimit" :

      ctx.miterLimit = drawOp._0;
      break;

    case "LineTo" :

      point = drawOp._0;

      ctx.lineTo(point.x, point.y);
      break;

    case "MoveTo" :

      point = drawOp._0;

      ctx.moveTo(point.x, point.y);
      break;

    case "ShadowBlur" :

      ctx.shadowBlur = drawOp._0;
      break;

    case "ShadowColor" :

      color = _elm_lang$core$Color$toRgb(drawOp._0);

      ctx.shadowColor = getCssString(color);
      break;

    case "ShadowOffsetX" :

      ctx.shadowOffsetX = drawOp._0;
      break;

    case "ShadowOffsetY" :

      ctx.shadowOffsetY = drawOp._0;
      break;

    case "Stroke" :

      ctx.stroke();
      break;

    case "BeginPath" :

      ctx.beginPath();
      break;

    case "BezierCurveTo" :

      point = drawOp._0;
      point1 = drawOp._1;
      var point2 = drawOp._2;

      ctx.bezierCurveTo(point.x, point.y, point1._0, point1._1, point2._0, point2._1);
      break;

    case "QuadraticCurveTo" :

      point = drawOp._0;
      point1 = drawOp._1;

      ctx.quadraticCurveTo(point.x, point.y, point1._0, point1._1);
      break;

    case "Rect" :

      point = drawOp._0;
      size = drawOp._1;

      ctx.rect(point.x, point.y, size.width, size.height);
      break;

    case "Rotate" :
      ctx.rotate(drawOp._0);
      break;

    case "Scale" :

      ctx.scale(drawOp._0, drawOp._1);
      break;

    case "SetLineDash" :

      ctx.setLineDash(_elm_lang$core$Native_List.toArray(drawOp._0));
      break;

    case "SetTransform" :

      ctx.setTransform(
        drawOp._0,
        drawOp._1,
        drawOp._2,
        drawOp._3,
        drawOp._4,
        drawOp._5
      );
      break;

    case "Transform" :

      ctx.transform(
        drawOp._0,
        drawOp._1,
        drawOp._2,
        drawOp._3,
        drawOp._4,
        drawOp._5
      );
      break;

    case "Translate" :

      point = drawOp._0;
      ctx.translate(point.x, point.y);
      break;

    case "StrokeRect" :

      point = drawOp._0;
      size = drawOp._1;

      ctx.strokeRect(point.x, point.y, size.width, size.height);
      break;

    case "StrokeStyle" :

      color = _elm_lang$core$Color$toRgb(drawOp._0);

      ctx.strokeStyle = getCssString(color);
      break;

    case "TextAlign" :

      ctx.textAlign = drawOp._0;
      break;

    case "TextBaseline" :

      ctx.textBaseline = drawOp._0;
      break;

    case "FillStyle" :

      color = _elm_lang$core$Color$toRgb(drawOp._0);

      ctx.fillStyle = getCssString(color);
      break;

    case "Fill" :

      ctx.fill();
      break;

    case "FillRect" :

      point = drawOp._0;
      size = drawOp._1;

      ctx.fillRect(point.x, point.y, size.width, size.height);
      break;

    case "PutImageData" :

      point = drawOp._2;
      size = drawOp._1;
      var data = _elm_lang$core$Native_List.toArray(drawOp._0);

      var imageData = ctx.createImageData(size.width, size.height);

      for (var index = 0; index < data.length; index++) {
        imageData.data[ index ] = data[ index ];
      }

      ctx.putImageData(imageData, point.x, point.y);
      break;

    case "ClearRect" :

      point = drawOp._0;
      size = drawOp._1;

      ctx.clearRect(point.x, point.y, size.width, size.height);
      break;

    case "Clip" :

      ctx.clip();
      break;

    case "ClosePath" :

      ctx.clearPath();
      break;

    case "PixelFill" :
      fill(drawOp._0, drawOp._1, ctx);
      break;

    case "DrawImage":

      var srcCanvas = cloneModel(drawOp._0).canvas();
      var drawImageOp = drawOp._1;
      var srcPoint, srcSize, destPoint, destSize;

      switch (drawOp._1.ctor) {
      case "At":

        destPoint = drawImageOp._0;

        ctx.drawImage(
          srcCanvas,
          destPoint.x,
          destPoint.y
        );
        break;

      case "Scaled":

        destPoint = drawImageOp._0;
        destSize = drawImageOp._1;
        ctx.drawImage(
          srcCanvas,
          destPoint.x, destPoint.y,
          destSize.width, destSize.height
        );
        break;

      case "CropScaled":

        srcPoint = drawImageOp._0;
        srcSize = drawImageOp._1;
        destPoint = drawImageOp._2;
        destSize = drawImageOp._3;

        ctx.drawImage(
          srcCanvas,
          srcPoint.x, srcPoint.y,
          srcSize.width, srcSize.height,
          destPoint.x, destPoint.y,
          destSize.width, destSize.height
        );
        break;
      }

      break;
    }
  }


  function fill (color, point, ctx) {
    color = _elm_lang$core$Color$toRgb(color);

    var canvas = ctx.canvas;
    var imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
    var width = imageData.width;
    var height = imageData.height;

    var i = 0;
    var data = [];
    while (i < imageData.data.length) {
      data.push(imageData.data[i]);
      i++;
    }

    var index = (point.x * 4) + (point.y * width * 4);
    var targetColor = data.slice(index, index + 4);

    function setToColor (index) {
      data[ index ] = color.red;
      data[ index + 1 ] = color.green;
      data[ index + 2 ] = color.blue;
    }

    var pixelsToCheck = [ index ];
    setToColor(index);

    function isTarget (index) {
      var redSame = targetColor[ 0 ] === data[ index ];
      var greenSame =  targetColor[ 1 ] === data[ index + 1 ];
      var blueSame = targetColor[ 2 ] === data[ index + 2 ];
      return redSame && greenSame && blueSame;
    }

    function checkAndSet (index) {
      var left = index - 4;
      var right = index + 4;
      var up = index - (width * 4);
      var down = index + (width * 4);

      if ( left % (width * 4) !== ((width - 1) * 4) ) {
        if ( isTarget(left) ) {
          pixelsToCheck.push(left);
          setToColor(left);
        }
      }

      if ( right % (width * 4) !== 0 ) {
        if ( isTarget(right) ) {
          pixelsToCheck.push(right);
          setToColor(right);
        }
      }

      if ( 0 < up ) {
        if ( isTarget(up) ) {
          pixelsToCheck.push(up);
          setToColor(up);
        }
      }

      if (down < data.length) {
        if ( isTarget(down) ) {
          pixelsToCheck.push(down);
          setToColor(down);
        }
      }
    }

    while (pixelsToCheck.length > 0) {
      checkAndSet(pixelsToCheck[0]);
      pixelsToCheck.shift();
    }

    var newImageData = ctx.createImageData(canvas.width, canvas.height);

    index = 0;
    while (index < data.length) {
      newImageData.data[ index ] = data[ index ];
      index++;
    }

    ctx.putImageData(newImageData,0,0);
  }


  function toDataURL (mimetype, quality, model) {
    return model.canvas().toDataURL(mimetype, quality);
  }


  function getCssString (color) {
    return "rgba(" + [ color.red, color.green, color.blue, color.alpha ].join(",") + ")";
  }


  function loadImage(source) {
    LOG("LOAD IMAGE");

    var Scheduler = _elm_lang$core$Native_Scheduler;
    return Scheduler.nativeBinding(function (callback) {
      var img = new Image();

      img.onload = function () {
        var canvas = document.createElement("canvas");

        canvas.width = img.width;
        canvas.height = img.height;

        var ctx = canvas.getContext("2d");

        ctx.drawImage(img, 0, 0);

        callback(Scheduler.succeed(makeModel(canvas)));
      };

      img.onerror = function () {
        callback(Scheduler.fail({ ctor: "Error" }));
      };

      if (source.slice(0,5) !== "data:") {
        img.crossOrigin = "Anonymous";
      }
      img.src = source;
    });
  }


  function getImageData(point, size, model) {
    LOG("GET IMAGE DATA");

    var canvas = model.canvas();
    var ctx = canvas.getContext("2d");
    var imageData = ctx.getImageData(
      point.x,
      point.y,
      size.width,
      size.height
    );

    return _elm_lang$core$Native_List.fromArray(imageData.data);
  }


  function setSize(size, model) {
    var canvas = cloneModel(model).canvas();
    canvas.width = size.width;
    canvas.height = size.height;

    return makeModel(canvas);
  }


  function getSize(model) {
    return {
      width: model.width,
      height: model.height
    };
  }



  function toHtml(factList, model) {
    LOG("TO HTML");

    return _elm_lang$virtual_dom$Native_VirtualDom.custom(factList, model, implementation);

  }


  var implementation = {
    render: renderCanvas,
    diff: diff
  };


  function renderCanvas(model) {
    LOG("RENDER CANVAS");
    return cloneModel(model).canvas();
  }


  function diff(old, new_) {
    LOG("DIFF");


    var diffCanvases = old.model.canvas() !== new_.model.canvas();

    return {
      applyPatch: function(domNode, data) {
        LOG("APPLY PATCH");

        if (diffCanvases) {

          var model = data.model;

          domNode.width = model.width;
          domNode.height = model.height;

          var ctx = domNode.getContext("2d");
          ctx.clearRect(0, 0, domNode.width, domNode.height);
          ctx.drawImage(data.model.canvas(), 0, 0);
        }

        return domNode;

      },
      data: new_
    };

  }


  return {
    initialize: initialize,
    setSize: F2(setSize), // eslint-disable-line no-undef
    getSize: getSize,
    loadImage: loadImage,
    toHtml: F2(toHtml), // eslint-disable-line no-undef
    getImageData: F3(getImageData), // eslint-disable-line no-undef
    clone: cloneModel,
    draw: F2(draw),
    scale: F3(scale),
    replace: F3(replace),
    toDataURL: F3(toDataURL) // eslint-disable-line no-undef
  };
}();
