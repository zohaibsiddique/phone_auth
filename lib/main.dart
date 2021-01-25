import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth/screens/Auth/otp_screen.dart';
import 'package:phone_auth/screens/Auth/sign_in_sc.dart';
import 'package:phone_auth/screens/auth/registeration_info_sc.dart';
import 'package:phone_auth/screens/home/home_sc.dart';
import 'package:phone_auth/services/auth_service.dart';
import 'package:phone_auth/services/database_service.dart';
import 'package:phone_auth/util/constants.dart';
import 'package:phone_auth/util/styles.dart';
import 'package:phone_auth/util/themes.dart';
import 'package:phone_auth/util/util.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var app = await Firebase.initializeApp();
  AuthService.init(app);
  DatabaseService.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static String route = "/myapp";
  var progress_key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(
            create: (context) => AuthService(),
          ),
          Provider(
            create: (context) => DatabaseService(AuthService()),
          ),
        ],
        child: MaterialApp(
          title: Constants.appTitle,
          theme: Themes.mainTheme,
          themeMode: ThemeMode.light,
          routes: {
            MyApp.route: (context) => MyApp(),
            SignInSC.route: (context) => SignInSC(),
            OtpScreen.route: (context) => OtpScreen(),
            RegistrationInfoSC.route: (context) => RegistrationInfoSC(),
            HomeSC.route: (context) => HomeSC(),
          },
          home: MyHomePage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int col = 2;
  double opacityLevel = 0.0;

  @override
  void initState() {
    Timer.run(() {
      _changeOpacity();
    });
    AuthService authService = context.read<AuthService>();
    if (authService.getUser() != null) {
      Timer(Duration(seconds: 3), () {
        Util.potUntil(context, MyApp.route);
        Util.navigate(context, HomeSC.route);
      });
      print("User UID: " + authService.getUser()?.uid);
    } else {
      Timer(Duration(seconds: 3), () {
        Util.potUntil(context, MyApp.route);
        Util.navigate(context, SignInSC.route);
      });
    }
    super.initState();
  }

  void _changeOpacity() {
    setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
                opacity: opacityLevel,
                duration: Duration(seconds: 1),
                child: Image.asset(
                  'assets/images/logo.png',
                )),
            Text(
              Constants.appTitle,
              style: Styles.screenTitle,
            ),
          ],
        ),
      ),
    );
  }
}
