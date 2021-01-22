import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth/services/auth_service.dart';

import 'main_button.dart';

class MainButton2 extends StatelessWidget {
  MainButton2(this.authService, this.isEnteredPhoneValid, this.onTap);
  bool isEnteredPhoneValid;
  AuthService authService;
  Function onTap;
  @override
  Widget build(BuildContext context) {
    return MainButton(
        text: "Next",
        OnPressed: isEnteredPhoneValid
            ? () {
                print("Trying to verify");
                try {
                  authService.onAuthError((e) {
                    var snackBar = SnackBar(
                      content: Text((e as FirebaseAuthException).message),
                      action: SnackBarAction(
                        label: 'OK',
                        onPressed: () {},
                      ),
                      duration: Duration(seconds: 5),
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                  });
                  onTap();
                } on Error catch (e) {
                  print("Caught Error from verify call.");
                } on Exception catch (ex) {
                  print("Caught Exception from verify call");
                }
              }
            : null,
        width: MediaQuery.of(context).size.width);
  }
}
