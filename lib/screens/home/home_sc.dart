import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///G:/Projects/Flutter/phone_auth/lib/screens/OTP/sign_in_sc.dart';
import 'package:phone_auth/ui_components/main_button.dart';
import 'package:phone_auth/util/constants.dart';
import 'package:phone_auth/util/util.dart';
import '../../main.dart';
import '../../services/auth_service.dart';
import 'package:provider/provider.dart';

class HomeSC extends StatefulWidget {
  static String route = "/home";
  @override
  _HomeSCState createState() => _HomeSCState();
}

class _HomeSCState extends State<HomeSC> {
  AuthService authService;

  @override
  void initState() {
    super.initState();
  }

  Future<void> logout() async {
    Util.showProgressDialog(context);
    try{
      context.read<AuthService>().SignOut();
      context.read<AuthService>().onSignOut(() {
        Util.potUntil(context, MyApp.route);
        Util.navigate(context, SignInSC.route);
      });
    } on Exception catch(e){
      Util.pop(context);
      Util.showSnackBarWithContext(context, e.toString(), Constants.ok, 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Home screen"),
            SizedBox(
              height: 10,
            ),
            MainButton(
              text: "Logout",
              OnPressed: logout,
              width: 100,
            )
          ],
        ),
      ),
    );
  }
}
