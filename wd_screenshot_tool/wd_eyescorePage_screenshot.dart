import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_expansion_demo/longScreenCapture/wd_screenshot_tool.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class WdEyescorePageScreenshotPage extends StatefulWidget {
  WdEyescorePageScreenshotPage({Key key}) : super(key: key);

  @override
  _WdEyescorePageScreenshotPageState createState() =>
      _WdEyescorePageScreenshotPageState();
}

class _WdEyescorePageScreenshotPageState
    extends State<WdEyescorePageScreenshotPage> {
  FXScreenshotController _screenshotController = FXScreenshotController();
  void _capture() async {
    Uint8List imgData = await _screenshotController.capture(
        screenScale: MediaQuery.of(context).devicePixelRatio,
        returnType: ReturnType.kByte);

    var result = await ImageGallerySaver.saveImage(imgData);
    print(result);
  }

  //* 天眼评分真实布局情况
  Widget _realEyeScoreSituation() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 300,
          color: Colors.white,
        ),
        ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            Container(
              color: Colors.red,
              height: 100,
              width: double.infinity,
            ),
            Container(
              color: Colors.green,
              height: 100,
              width: double.infinity,
            ),
            Container(
              color: Colors.blue,
              height: 100,
              width: double.infinity,
            ),
            Container(
              color: Colors.orange,
              height: 100,
              width: double.infinity,
            ),
            Container(
              color: Colors.purple,
              height: 100,
              width: double.infinity,
            ),
            Container(
              color: Colors.white,
              height: 100,
              width: double.infinity,
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            height: 44,
            color: Colors.orange,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text('data'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () {
                    _capture();
                  },
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
            color: Colors.black,
            child: SingleChildScrollView(
              child: FXScreenshotTool(
                controller: _screenshotController,
                child: _realEyeScoreSituation(),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
