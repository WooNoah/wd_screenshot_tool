import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class WdScreenShotPage extends StatefulWidget {
  // final List<Uint8List> images;
  final Uint8List image;
  final File file;

  WdScreenShotPage({Key key, this.image, this.file}) : super(key: key);

  @override
  _WdScreenShotPageState createState() => _WdScreenShotPageState();
}

class _WdScreenShotPageState extends State<WdScreenShotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('截长图'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: widget.image != null
                  ? Image.memory(widget.image, fit: BoxFit.fitWidth)
                  : widget.file != null
                      ? Image.file(widget.file, fit: BoxFit.fitWidth)
                      : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
