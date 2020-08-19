import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:flutter_expansion_demo/longScreenCapture/wd_screenshot_page.dart';

/*
  思路: 考虑像iOS那样， 把要截图的视图 改为非常长，然后使用系统的方式去渲染， 测试
*/
class WdLongOverlayScreenshotPage extends StatefulWidget {
  WdLongOverlayScreenshotPage({Key key}) : super(key: key);

  @override
  _WdLongOverlayScreenshotPageState createState() =>
      _WdLongOverlayScreenshotPageState();
}

class _WdLongOverlayScreenshotPageState
    extends State<WdLongOverlayScreenshotPage> {
  GlobalKey _listKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).padding.top + 44,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
                    'Overlay Screenshot Test',
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
            Expanded(
                child: SingleChildScrollView(
              child: RepaintBoundary(
                key: _listKey,
                child: Container(
                  // height: this.titles.length * 76.0,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.blue,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: this.titles.length,
                    itemBuilder: (BuildContext context, int index) {
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
                                        rightdercrible(index,
                                            title: titles[index]),
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
              ),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.accessibility_new),
        onPressed: _capture,
      ),
    );
  }

  void _capture() async {
    RenderRepaintBoundary boundary = _listKey.currentContext.findRenderObject();
    ui.Image img = await boundary.toImage(pixelRatio: 3);

    ByteData byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    Uint8List bf = byteData.buffer.asUint8List();

    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      // return FXScreenShotPage(image: mergedImage.getBytes());
      return FXScreenShotPage(image: bf);
      // return FXScreenShotPage(file: nav);
    }));
  }

  Widget _leftbrand(int index) {
    return Container(
      // padding: EdgeInsets.only(top: 8,left: 8,right: 8),
      width: 88,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.yellow,
        // color: Color(0xffFFFFFF),
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
    '嘉盛集团21',
    '嘉盛集团22',
    '嘉盛集团23',
    '嘉盛集团24',
    '嘉盛集团25',
    '嘉盛集团26',
    '嘉盛集团27',
    '嘉盛集团28',
    '嘉盛集团29',
    '嘉盛集团30',
    '嘉盛集团31',
    '嘉盛集团32',
    '嘉盛集团33',
    '嘉盛集团34',
    '嘉盛集团35',
    '嘉盛集团36',
    '嘉盛集团37',
    '嘉盛集团38',
    '嘉盛集团39',
    '嘉盛集团40',
  ];
}
