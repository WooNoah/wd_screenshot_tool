import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

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

  const _Widget({
    Key key,
    this.completer,
    this.widgets,
    this.ratio,
  }) : super(key: key);

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

class OffScreenTest extends StatefulWidget {
  @override
  _OffScreenTestState createState() => _OffScreenTestState();
}

class _OffScreenTestState extends State<OffScreenTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _save,
          child: Text('save'),
        ),
      ),
      body: ListView(
        children: widgets,
      ),
    );
  }

  final images = [
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1596099785777&di=ac8b29e82d37cfd4f0cca2abea5894f1&imgtype=0&src=http%3A%2F%2Fa3.att.hudong.com%2F14%2F75%2F01300000164186121366756803686.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1596099785777&di=f1df02c55b5ff6847a0ce6de0b77acf4&imgtype=0&src=http%3A%2F%2Fa0.att.hudong.com%2F56%2F12%2F01300000164151121576126282411.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1596099785777&di=2190d7a82134b2539ff17be5305a1d30&imgtype=0&src=http%3A%2F%2Fa2.att.hudong.com%2F36%2F48%2F19300001357258133412489354717.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1596099785776&di=86d6c75545e5b7f5ded19b98c3283e4c&imgtype=0&src=http%3A%2F%2Fp2.so.qhimgs1.com%2Ft01dfcbc38578dac4c2.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1596099785776&di=e013c3692e24167b6a428cec564862a2&imgtype=0&src=http%3A%2F%2Ffile02.16sucai.com%2Fd%2Ffile%2F2014%2F0704%2Fe53c868ee9e8e7b28c424b56afe2066d.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1596099785776&di=1434cac554b3ff68454579e6d9e5c659&imgtype=0&src=http%3A%2F%2Fpic3.16pic.com%2F00%2F01%2F11%2F16pic_111395_b.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1596099785776&di=089784927555e2964e0ca50c58c57f73&imgtype=0&src=http%3A%2F%2Fa.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2Fcc11728b4710b912d81c7b33c3fdfc0393452219.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1596099785775&di=4b8fbbab3a13ab1c0c4de236b45017da&imgtype=0&src=http%3A%2F%2Ffile02.16sucai.com%2Fd%2Ffile%2F2014%2F0829%2F372edfeb74c3119b666237bd4af92be5.jpg',
    'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2115524945,144926733&fm=26&gp=0.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1596099785774&di=fdde31dad9df7c2f04822a06823a98e5&imgtype=0&src=http%3A%2F%2Fa4.att.hudong.com%2F56%2F01%2F14300000569933129733017565210.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1596099785775&di=7f3e2cba21f641807adbef3695e1722e&imgtype=0&src=http%3A%2F%2Fgss0.baidu.com%2F9vo3dSag_xI4khGko9WTAnF6hhy%2Fzhidao%2Fpic%2Fitem%2F3b292df5e0fe99257d8c844b34a85edf8db1712d.jpg'
  ];

  List<Widget> get widgets {
    return images.map((e) {
      return Container(
        color: Colors.red,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(bottom: 10),
        height: 100,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 60,
              height: 100,
              child: Image.network(e),
            ),
            Expanded(
              child: Text(
                'adfasdf',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      );
    }).toList();
  }

  _save() async {
    List<ui.Image> images;
    try {
      //两种方式都可以
      images = await OffScreenImageRender.render(context, [
        Column(
          children: widgets,
        )
      ]);
//      images = await OffScreenImageRender.render(context, widgets);
    } catch (e) {
      print(e.toString());
    } finally {}
    if (images == null || images.isEmpty) return;
    if (images.length == 1) {
      var byteData =
          await images.first.toByteData(format: ui.ImageByteFormat.png);
      var buffer = byteData.buffer.asUint8List();
      await ImageGallerySaver.saveImage(buffer);
    } else {
      var pr = ui.PictureRecorder();
      var canvas = Canvas(pr);
      var paint = Paint();
      double y = 0;
      for (int i = 0; i < images.length; i++) {
        ui.Image image = images[i];
        canvas.drawImage(image, Offset(0, y), paint);
        y = y + image.height;
      }
      var pic = pr.endRecording();
      ui.Image img = await pic.toImage(
          MediaQuery.of(context).size.width.toInt(), y.toInt());
      var byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      var buffer = byteData.buffer.asUint8List();
      await ImageGallerySaver.saveImage(buffer);
    }
  }
}
