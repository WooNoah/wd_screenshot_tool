import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';

class FXScreenshotTool extends StatefulWidget {
  final Widget child;
  final FXScreenshotController controller;

  FXScreenshotTool({Key key, this.child, this.controller}) : super(key: key);

  @override
  _FXScreenshotToolState createState() => _FXScreenshotToolState();
}

class _FXScreenshotToolState extends State<FXScreenshotTool> {
  FXScreenshotController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = FXScreenshotController();
    } else
      _controller = widget.controller;
  }

  @override
  void didUpdateWidget(FXScreenshotTool oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      widget.controller._key = oldWidget.controller._key;
      if (oldWidget.controller != null && widget.controller == null)
        _controller._key = oldWidget.controller._key;
      if (widget.controller != null) {
        if (oldWidget.controller == null) {
          _controller = null;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _controller._key,
      child: widget.child,
    );
  }
}

enum ReturnType {
  kImage,
  kByte,
  kFile,
}

class FXScreenshotController {
  GlobalKey _key;
  FXScreenshotController() {
    _key = GlobalKey();
  }

  //* 短截图 返回指定对象
  //! 只能截取给定宽高的 widget, 无法截取 ListView
  //? 如果想要截取 ListView，可以用SingleChildScrollView包裹 shrinpWrap为true的 ListView，然后调用方法截取
  Future<dynamic> capture({
    String path = "",
    @required double screenScale,
    @required ReturnType returnType,
    Duration delay: const Duration(milliseconds: 20),
  }) {
    return Future.delayed(delay, () async {
      try {
        ui.Image image =
            await captureAsUiImage(pixelRatio: screenScale, delay: delay);
        if (returnType == ReturnType.kImage) return image;
        ByteData byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData.buffer.asUint8List();
        if (returnType == ReturnType.kByte) return pngBytes;
        if (path == "") {
          final directory = (await getApplicationDocumentsDirectory()).path;
          String fileName = DateTime.now().toIso8601String();
          path = '$directory/$fileName.png';
        }
        File imgFile = new File(path);
        await imgFile.writeAsBytes(pngBytes).then((onValue) {});
        return imgFile;
      } catch (e) {
        throw (e);
      }
    });
  }

  //* 短截图 返回Image对象
  Future<ui.Image> captureAsUiImage({
    @required double pixelRatio,
    Duration delay: const Duration(milliseconds: 20),
  }) {
    //Delay is required. See Issue https://github.com/flutter/flutter/issues/22308
    return new Future.delayed(delay, () async {
      try {
        RenderRepaintBoundary boundary = _key.currentContext.findRenderObject();
        return await boundary.toImage(pixelRatio: pixelRatio);
      } catch (Exception) {
        throw (Exception);
      }
    });
  }

  //* 截图 长列表 (需要提供数据源，还有样式Widget 来绘制出来)
  static Future<List<ui.Image>> drawListView({
    @required BuildContext context,
    @required List<dynamic> dataSource,
    @required WdOffScreenCellConfig config,
    double ratio,
  }) {
    return OffScreenImageRender.render(
      context,
      dataSource.map((e) {
        return config(e);
      }).toList(),
      ratio: ratio,
    );
  }
}

typedef WdOffScreenCellConfig = Widget Function(dynamic model);

//todo: 如果改为使用builder来创建 listView 是否会更好？
typedef OffScreenRenderBuilder = List<Widget> Function(
    List<dynamic> dataSource, Widget cellConfig, int index);

class OffScreenImageRender {
  //widgets 宽高必须是可确定的,限制宽高,或者由内容决定
  static Future<List<ui.Image>> render(
    BuildContext context,
    List<Widget> widgets, {
    double ratio,
  }) {
    Completer<List<ui.Image>> completer = Completer<List<ui.Image>>();
    OverlayEntry entry = OverlayEntry(
      builder: (_) => _Widget(
        completer: completer,
        widgets: widgets,
        ratio: ratio,
      ),
    );
    Overlay.of(context).insert(entry);

    return completer.future.then((v) {
      entry.remove();
      entry = null;
      return v;
    }, onError: (e) {
      throw e;
    });
  }
}

class _Widget extends StatefulWidget {
  final Completer<List<ui.Image>> completer;
  final List<Widget> widgets;
  final double ratio;

  const _Widget({Key key, this.completer, this.widgets, this.ratio})
      : super(key: key);

  @override
  __WidgetState createState() => __WidgetState();
}

class __WidgetState extends State<_Widget> {
  List<GlobalKey> _keys = [];

  @override
  void initState() {
    _keys = List.generate(widget.widgets.length, (_) => GlobalKey());
    WidgetsBinding.instance.addPostFrameCallback(_postFrame);
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  _postFrame(_) async {
    var ratio = widget.ratio ?? MediaQuery.of(context).devicePixelRatio;
    try {
      var futureImages = _keys.map((e) async {
        RenderRepaintBoundary boundary = e.currentContext.findRenderObject();
        var image = await boundary.toImage(pixelRatio: ratio);
        return image;
      }).toList();
      List<ui.Image> images = await Future.wait(futureImages);
      widget.completer.complete(images);
    } catch (e) {
      widget.completer.completeError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(MediaQuery.of(context).size.width, 0),
//      offset: Offset(10, 0),
      child: Material(
        child: Stack(
          children: List.generate(
            widget.widgets.length,
            (index) => Positioned(
              left: 0,
              top: 0,
              child: RepaintBoundary(
                key: _keys[index],
                child: widget.widgets[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
