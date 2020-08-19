import 'package:flutter/material.dart';
import 'dart:ui' as ui;

enum ImageFitType {
  realSize,
  fitWidth,
  fitHeight,
}

enum ImageAlignmentType {
  start,
  center,
  end,
}

enum ImageLayoutDirection {
  vertical,
  horizontal,
}

class WdImageTool {
  static Future<ui.Image> combineImage({
    @required BuildContext context,
    @required List<ui.Image> images,
    double specificWidth,
    double specificHeight,
    ImageLayoutDirection direction = ImageLayoutDirection.vertical,
    ImageFitType fitType = ImageFitType.fitWidth,
    ImageAlignmentType imageAlignmentType = ImageAlignmentType.start,
    double ratio,
  }) async {
    ratio = MediaQuery.of(context).devicePixelRatio;
    specificWidth =
        specificWidth ?? (MediaQuery.of(context).size.width * ratio);
    specificHeight =
        specificHeight ?? (MediaQuery.of(context).size.height * ratio);

    var pr = ui.PictureRecorder();
    var canvas = Canvas(pr);
    var paint = Paint();
    double y = 0;
    double x = 0;
    for (int i = 0; i < images.length; i++) {
      ui.Image image = images[i];
      if (direction == ImageLayoutDirection.vertical) {
        canvas.drawImage(image, Offset(0, y), paint);
        y = y + (image.height);
      } else {
        canvas.drawImage(image, Offset(x, 0), paint);
        x = x + (image.width);
      }
    }
    var pic = pr.endRecording();
    if (fitType == ImageFitType.fitWidth) {
      ui.Image img = await pic.toImage(specificWidth.toInt(), y.toInt());
      return img;
    } else if (fitType == ImageFitType.fitHeight) {
      ui.Image img = await pic.toImage(x.toInt(), specificHeight.toInt());
      return img;
    } else {
      //todo: 待完善
      // imageAlignmentType 只有 图片realSize的时候才生效
      return null;
    }
  }
}
