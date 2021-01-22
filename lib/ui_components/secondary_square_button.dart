import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth/util/colors.dart';
import 'package:phone_auth/util/styles.dart';

class SecondarySquareButton extends StatelessWidget {

  final String text;
  final GestureTapCallback OnPressed;
  final double width;
  final double height;

  const SecondarySquareButton({Key key, this.text, this.OnPressed, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: primaryColor),
      ),
      child: InkWell(
        onTap: OnPressed,
        child: Center(
          child: Text(
            "${this.text}",
            style: Styles.buttonLabel,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
