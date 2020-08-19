import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class FXScreenShotPage extends StatefulWidget {
  // final List<Uint8List> images;
  final Uint8List image;
  final File file;

  FXScreenShotPage({Key key, this.image, this.file}) : super(key: key);

  @override
  _FXScreenShotPageState createState() => _FXScreenShotPageState();
}

class _FXScreenShotPageState extends State<FXScreenShotPage> {
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
