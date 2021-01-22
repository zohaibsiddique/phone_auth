import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth/util/colors.dart';
import 'package:phone_auth/util/styles.dart';


class MainButton extends StatelessWidget {

  final String text;
  final double width;
  final GestureTapCallback OnPressed;

  const MainButton({Key key, @required this.text, this.OnPressed, @required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: ButtonTheme(
        padding: EdgeInsets.all(15),
        minWidth: width,
        child: RaisedButton(
          color: accentColor,
          disabledColor: inactiveText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
          ),
          child: Column(
            children: [
              Text("${this.text}", style: Styles.buttonLabel.copyWith(color: Colors.white),),
            ],
          ),
          onPressed: OnPressed,
        ),
      ),
    );
  }
}
