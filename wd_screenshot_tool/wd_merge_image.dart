import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:image/image.dart' as third;

class WdMergeTwoImagePage extends StatefulWidget {
  WdMergeTwoImagePage({Key key}) : super(key: key);

  @override
  _WdMergeTwoImagePageState createState() => _WdMergeTwoImagePageState();
}

class _WdMergeTwoImagePageState extends State<WdMergeTwoImagePage> {
  // third.Image _mergeImage() {
  //   final image1 = third.decodeImage(File('imageA.jpg').readAsBytesSync());
  //   final image2 = third.decodeImage(File('imageB.jpg').readAsBytesSync());

  //   final mergedImage = third.Image(
  //       image1.width + image2.width, max(image1.height, image2.height));
  //   third.copyInto(mergedImage, image1, blend: false);
  //   third.copyInto(mergedImage, image2, dstX: image1.width, blend: false);

  //   return mergedImage;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
