import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_expansion_demo/longScreenCapture/wd_image_tool.dart';
import 'package:flutter_expansion_demo/longScreenCapture/wd_screenshot_tool.dart';

import 'wd_screenshot_page.dart';

class WdListViewScreenshotShowPage extends StatefulWidget {
  WdListViewScreenshotShowPage({Key key}) : super(key: key);

  @override
  _WdListViewScreenshotShowPageState createState() =>
      _WdListViewScreenshotShowPageState();
}

class _WdListViewScreenshotShowPageState
    extends State<WdListViewScreenshotShowPage> {
  // ScreenshotController _screenshotController;
  FXScreenshotController _navScreenshotController = FXScreenshotController();

  // GlobalKey _navKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // _screenshotController = ScreenshotController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            FXScreenshotTool(
              controller: _navScreenshotController,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).padding.top + 44,
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                color: Colors.orange,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Text(
                      'data',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: titles.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.white,
                    // height: 70,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Material(
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 16, right: 16, top: 10),
                                child: Row(
                                  children: <Widget>[
                                    _leftbrand(index),
                                    rightdercrible(index, title: titles[index]),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.access_time),
        onPressed: () async {
          var images = await FXScreenshotController.drawListView(
              context: context, dataSource: titles, config: configCell);
          // var images = await renderLongScreenshot();
          if (images == null || images.isEmpty) return;

          // Uint8List buffer;
          ui.Image listImg;
          if (images.length == 1) {
            // var byteData =
            //     await images.first.toByteData(format: ui.ImageByteFormat.png);
            // buffer = byteData.buffer.asUint8List();
            listImg = images.first;
          } else {
            MediaQueryData queryData = MediaQuery.of(context);
            double scale = queryData.devicePixelRatio;
            double w = (queryData.size.width * scale);

            var pr = ui.PictureRecorder();
            var canvas = Canvas(pr);
            var paint = Paint();
            double y = 0;
            for (int i = 0; i < images.length; i++) {
              ui.Image image = images[i];
              canvas.drawImage(image, Offset(0, y), paint);
              y = y + (image.height);
            }
            var pic = pr.endRecording();
            ui.Image img = await pic.toImage(w.toInt(), y.toInt());
            listImg = img;
            // ByteData byteData =
            //     await img.toByteData(format: ui.ImageByteFormat.png);
            // buffer = byteData.buffer.asUint8List();
          }

          // RenderRepaintBoundary boundary =
          //     this._navKey.currentContext.findRenderObject();
          // ui.Image navImg = await boundary.toImage(pixelRatio: 3);

          // Uint8List navBytes = await _navScreenshotController.capture(
          //     screenScale: MediaQuery.of(context).devicePixelRatio,
          //     returnType: ReturnType.kByte);

          ui.Image navImg = await _navScreenshotController.capture(
              screenScale: MediaQuery.of(context).devicePixelRatio,
              returnType: ReturnType.kImage);

          // File nav = await _screenshotController.capture();
          // Uint8List navData = Uint8List.fromList(nav.readAsBytesSync());
          // Uint8List listData = Uint8List.fromList(buffer);

          // List<int> combineData = navData + listData;
          // Uint8List temp = Uint8List.fromList(combineData);

          // ====================================================

          // fxImg.Image navImage = fxImg.decodeImage(navData);
          // fxImg.Image listImage = fxImg.decodeImage(listData);

          // final mergedImage =
          //     // fxImg.Image(navImage.width, navImage.height + listImage.height);
          //     // fxImg.Image(navImage.width, navImage.height);
          //     fxImg.Image(listImage.width, listImage.height);

          // fxImg.copyInto(mergedImage, listImage, blend: false);
          // mergedImage = fxImg.copyInto(mergedImage, listImage,
          //     dstY: navImage.height, blend: false);

          // Uint8List temp = Uint8List.fromList(mergedImage.getBytes());

          // var result =
          //     // await ImageGallerySaver.saveImage(mergedImage.getBytes());
          //     await ImageGallerySaver.saveImage(listData);
          // print(result);

          // ====================================================

          // ui.PictureRecorder recorder = ui.PictureRecorder();
          // final paint = Paint();
          // Canvas canvas = Canvas(recorder);

          // // ui.Image navImg = ui.Image();

          // int navImgHeight = navImg.height;
          // canvas.drawImage(navImg, Offset(0, 0), paint);
          // canvas.drawImage(listImg, Offset(0, navImgHeight.toDouble()), paint);
          // var pic = recorder.endRecording();
          // ui.Image img =
          //     await pic.toImage(listImg.width, listImg.height + navImgHeight);

          ui.Image img = await WdImageTool.combineImage(
              context: context, images: [navImg, listImg]);

          ByteData byteData =
              await img.toByteData(format: ui.ImageByteFormat.png);
          Uint8List bf = byteData.buffer.asUint8List();

          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            // return FXScreenShotPage(image: mergedImage.getBytes());
            return FXScreenShotPage(image: bf);
            // return FXScreenShotPage(file: nav);
          }));
        },
      ),
    );
  }

  //* 配置cell的数据
  Widget configCell(model) {
    return Container(
      color: Colors.white,
      // height: 70,
      width: 414,
      child: Container(
        child: Column(
          children: <Widget>[
            Material(
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  children: <Widget>[
                    _leftbrand(1),
                    rightdercrible(1, title: model),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> titles = [
    '嘉盛集团1',
    '嘉盛集团2',
    '嘉盛集团3',
    '嘉盛集团4',
    '嘉盛集团5',
    '嘉盛集团6',
    '嘉盛集团7',
    '嘉盛集团8',
    '嘉盛集团9',
    '嘉盛集团10',
    '嘉盛集团11',
    '嘉盛集团12',
    '嘉盛集团13',
    '嘉盛集团14',
    '嘉盛集团15',
    '嘉盛集团16',
    '嘉盛集团17',
    '嘉盛集团18',
    '嘉盛集团19',
    '嘉盛集团20',
    // '嘉盛集团21',
    // '嘉盛集团22',
    // '嘉盛集团23',
    // '嘉盛集团24',
    // '嘉盛集团25',
    // '嘉盛集团26',
    // '嘉盛集团27',
    // '嘉盛集团28',
    // '嘉盛集团29',
    // '嘉盛集团30',
    // '嘉盛集团31',
    // '嘉盛集团32',
    // '嘉盛集团33',
    // '嘉盛集团34',
    // '嘉盛集团35',
    // '嘉盛集团36',
    // '嘉盛集团37',
    // '嘉盛集团38',
    // '嘉盛集团39',
    // '嘉盛集团40',
  ];

  Widget _leftbrand(int index) {
    return Container(
      // padding: EdgeInsets.only(top: 8,left: 8,right: 8),
      width: 88,
      height: 56,
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        //设置四周边框
        border: new Border.all(width: 1, color: Color.fromRGBO(0, 0, 0, 0.05)),
        // image: DecorationImage(
        //     image: CachedNetworkImageProvider(this.trankNumList[index].logo),
        //     fit: BoxFit.contain),
      ),
      child: Stack(
        alignment: Alignment.topLeft,
        fit: StackFit.loose,
        children: <Widget>[
          Container(
            height: 16,
            //width: 30,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  bottomRight: Radius.circular(4.0)),
            ),
            child: Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  '监管中',
                  style: TextStyle(fontSize: (10), color: Color(0xffFFFFFF)),
                )),
          ),
        ],
      ),
    );
  }

  //排行
  Widget rightdercrible(int index, {String title}) {
    return Expanded(
        child: Container(
      height: 66,
      padding: EdgeInsets.only(left: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  // width: 160,
                  child: Text(
                    title ?? '嘉盛集团',
                    style: TextStyle(
                        color: Color(0xFF3D3D3D),
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Text(
                "天眼评分",
                style: TextStyle(color: Color(0xFF330F15), fontSize: 11),
              ),
              Container(
                  //alignment: Alignment.center,
                  width: 36,
                  height: 16,
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    border: new Border.all(
                        width: 0.5, color: Color.fromRGBO(51, 15, 21, 0.2)),
                    color: Color(0xffF5C462),
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  ),
                  child: Center(
                    child: Text(
                      "8.88",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'DIN',
                          fontSize: 12,
                          color: Color(0xff330F15),
                          fontWeight: FontWeight.w600),
                    ),
                  )),
            ],
          ),
          Container(
            child: Text(
              "10-15年 | 澳大利亚监管 | 全牌照 | 主标MT4/5软件",
              style: TextStyle(fontSize: (10), color: Color(0xffA3A3A3)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ));
  }
}
