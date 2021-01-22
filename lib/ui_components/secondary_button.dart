import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth/util/colors.dart';
import 'package:phone_auth/util/styles.dart';

class SecondaryButton extends StatelessWidget {

  final String text;
  final double width;
  final GestureTapCallback OnPressed;
  final Color color;
  final Color background;

  const SecondaryButton({Key key, @required this.text, this.color, this.OnPressed, this.width,this.background}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: ButtonTheme(
        padding: EdgeInsets.all(15),
        child: RaisedButton(
          color: background,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: primaryColor)
          ),
          child: Text(
            "${this.text}",
            style: Styles.buttonLabel.copyWith(color: color),
          ),
          onPressed: OnPressed,
        ),
      ),
    );
  }
}
