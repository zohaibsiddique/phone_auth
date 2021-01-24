import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'file:///G:/Projects/Flutter/phone_auth/lib/screens/OTP/registeration_info_sc.dart';
import 'package:phone_auth/services/auth_service.dart';
import 'package:phone_auth/ui_components/main_button.dart';
import 'package:phone_auth/util/colors.dart';
import 'package:phone_auth/util/constants.dart';
import 'package:phone_auth/util/styles.dart';
import 'package:phone_auth/util/util.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class OtpScreen extends StatefulWidget {
  static String route = '/otpScreen';
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController verificationCode = TextEditingController();
  var codeExpires = false;
  var timer = 30;
  var timerResetValue = 30;
  StreamSubscription timerSubscription;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String phone;
  AuthService authService;
  Stream<int> timerObj;

  @override
  void initState() {
    authService = context.read<AuthService>();

    timerObj = Util.Mytimer(timer);
    timerSubscription = timerObj?.listen((event) {
      setState(() {
        timer = event;
      });
    });

    //TODO: needs to implement auto retrieval OTP and directly navigate to Registration info screen
    authService.onAutoAuthenticateTimeOut(() {
      _scaffoldKey.currentState.showSnackBar(
          Util.showSnackBar("OTP timeout! write OTP yourself.", "OK", 5));
    });
    super.initState();
  }

  _resendOTP() {
    Util.showProgressDialog(context);
    authService.verify(phone);
    authService.onSMSSent(() {
      timer = timerResetValue; //reset timer
      timerObj = Util.Mytimer(timer);
      timerSubscription = timerObj?.listen((event) {
        setState(() {
          timer = event;
          print(timer);
        });
      });
      Navigator.of(context).pop(); //do invisible progress dialog
    });
    authService.onAuthError((e) {
      print(e.toString()+" error on auth");
      Util.pop(context); //do invisible progress dialog
      Util.showSnackBarWithContext(context, (e as FirebaseAuthException).message ?? Constants.server_error, "OK", 10);
    });
  }


  void _verifyOTP(){
    Util.showProgressDialog(context);
    authService.verifyCode(verificationCode.text);
    print("Sending code for verification to server ..... ${verificationCode.text}");
    authService.onAuthenticated(() {
      timerSubscription.cancel();
      Util.potUntil(context, MyApp.route);
      Navigator.pushNamed(context, RegistrationInfoSC.route,
          arguments: {"phone": phone});
    });
    authService.onOTPAuthError((e) {
      _scaffoldKey.currentState.showSnackBar(
          Util.showSnackBar((e as FirebaseAuthException).message, "OK", 5));
    });
  }

  @override
  void dispose() {
    timerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> receivedData =
        ModalRoute.of(context).settings.arguments;
    phone = receivedData["phone"];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Confirm your number",
                  style: Styles.screenTitle,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "We just sent to your phone a 6-digit code via SMS to confirm your number.",
                  style: Styles.sectionTitle,
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter";
                      }
                      return null;
                    },
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    controller: verificationCode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).nextFocus();
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text:
                                "Didn't receive a code? resend the code after ",
                            style: Styles.body1.copyWith(color: blackColor)),
                        TextSpan(
                            text: "00:$timer ",
                            style:
                                Styles.body1.copyWith(color: primaryColorDark)),
                        TextSpan(
                            text: "seconds",
                            style: Styles.body1.copyWith(color: blackColor))
                      ])),
                    ),
                    InkWell(
                      child: Text(
                        "Resend",
                        style: Styles.body1.copyWith(
                            color: timer == 0 ? primaryColor : inactiveText,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: timer == 0 ? _resendOTP : null,
                    ),
                  ],
                ),
              ],
            ),
            MainButton(
              text: "Confirm",
              OnPressed: () {
                _verifyOTP();
              },
              width: MediaQuery.of(context).size.width,
            ),
          ],
        ),
      ),
    );
  }
}
