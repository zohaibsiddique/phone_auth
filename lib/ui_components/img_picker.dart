import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth/util/colors.dart';

class ImgPicker extends StatelessWidget {
  final GestureTapCallback onTap;
  final double width, height;
  final String path;
  const ImgPicker({Key key, @required this.onTap, @required this.width, @required this.height, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: accentColor),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(500),
            child: path != "" ? Image.file(File(path), width: width, height: height,fit: BoxFit.fill,): Icon(Icons.camera_alt, size: 30,)
        ),
      ),
    );
  }
}
