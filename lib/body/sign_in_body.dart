import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth/screens/otp_screen.dart';
import 'package:phone_auth/screens/registeration_info_sc.dart';
import 'package:phone_auth/services/auth_service.dart';
import 'package:phone_auth/services/network_status_service.dart';
import 'package:phone_auth/ui_components/country_code_layout.dart';
import 'package:phone_auth/ui_components/network_aware_widget.dart';
import '../main.dart';
import 'package:provider/provider.dart';
import 'package:phone_auth/ui_components/main_button.dart';
import 'package:phone_auth/util/constants.dart';
import 'package:phone_auth/util/styles.dart';
import 'package:phone_auth/util/util.dart';

class SignInBD extends StatefulWidget {
  @override
  _SignInBDState createState() => _SignInBDState();
}

class _SignInBDState extends State<SignInBD> {
  AuthService authService;
  String phone = "";
  bool isEnteredPhoneValid = true;
  bool smsSent = false;
  SnackBar snackBar;

  @override
  void initState() {
    authService = context.read<AuthService>();
    authService.onAutoAuthenticated(() {
      Util.potUntil(context, MyApp.route);
      Navigator.pushNamed(context, RegistrationInfoSC.route,
          arguments: {"phone": phone});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamProvider<NetworkStatus>(
          create: (context) =>
              NetworkStatusService().networkStatusController.stream,
          child: NetworkAwareWidget(
            onlineChild: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  Icons.wifi,
                  color: Colors.green,
                ),
                Body(context, authService, phone, isEnteredPhoneValid)
              ],
            ),
            offlineChild: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  Icons.wifi_off,
                  color: Colors.red,
                ),
                Body(context, authService, phone, isEnteredPhoneValid)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget Body(BuildContext context, AuthService authService, String phone,
    bool isEnteredPhoneValid) {
  verifyPhone(String phone) {
    Util.showProgressDialog(context);
    authService.verify(phone);
    authService.onSMSSent(() {
      Util.potUntil(context, MyApp.route);
      Navigator.pushNamed(context, OtpScreen.route,
          arguments: {"phone": phone});
    });
    authService.onAuthError((e) {
      print(e.toString() + " error on auth");
      Util.pop(context); //do invisible progress dialog
      Util.showSnackBarWithContext(
          context,
          (e as FirebaseAuthException).message ?? Constants.server_error,
          "OK",
          10);
    });
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(
          'assets/images/logo.png',
          height: 100,
          width: 100,
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          Constants.appTitle,
          style: Styles.screenTitle,
        ),
      ]),
      SizedBox(
        height: 150,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Constants.signin,
            style: Styles.screenTitle,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            Constants.enter_number,
            style: Styles.sectionTitle,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            Constants.need_contact_with_you,
            style: Styles.body2,
          ),
          SizedBox(
            height: 10,
          ),
          CountryCodeLayout(
              labelText: "Phone Number",
              initialSelection: "PK",
              phoneNumber: (String countryCode, String phoneNumber) {
                phone = countryCode.trim() + phoneNumber.trim();
                // if (isPhoneNumberValid(phoneNumber))
                //   setState(() => this.isEnteredPhoneValid = true);
                // else if (this.isEnteredPhoneValid)
                //   setState(() => this.isEnteredPhoneValid = false);
              }),
          SizedBox(
            height: 20,
          ),
          MainButton(
              text: Constants.next.toUpperCase(),
              OnPressed: isEnteredPhoneValid
                  ? () {
                      print("Trying to verify");
                      verifyPhone(phone);
                    }
                  : null,
              width: MediaQuery.of(context).size.width),
        ],
      ),
    ],
  );
}
