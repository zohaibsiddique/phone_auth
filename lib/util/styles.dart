import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

class Styles{
  static TextStyle selectedTextStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: primaryColor,
  );
  static TextStyle unselectedTextStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: inactiveText,
  );

  static TextStyle screenTitle =
  TextStyle(fontSize: 24, fontFamily: "bold");

  static TextStyle sectionTitle =
  TextStyle(fontSize: 16, fontFamily: "medium");

  static TextStyle buttonLabel =
  TextStyle(fontSize: 16, fontFamily: "semibold");

  static TextStyle body1 =
  TextStyle(fontSize: 14, fontFamily: "regular");

  static TextStyle body2 =
  TextStyle(fontSize: 12, fontFamily: "regular");

  static TextStyle navLabelInactive =
  TextStyle(fontSize: 12, fontFamily: "regular");

  static TextStyle navLabelActive =
  TextStyle(fontSize: 12, fontFamily: "bold");
}