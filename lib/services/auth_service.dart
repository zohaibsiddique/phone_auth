import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rxdart/rxdart.dart';

class AuthService{

  AuthService();

  static FirebaseAuth authInstance;

  static void init(FirebaseApp app){
    authInstance = FirebaseAuth.instanceFor(app: app);
    print("Firebase Instannce Not Null ??"+ (authInstance != null).toString());
  }

  clearOnAuthErrorCallbacks(){
    _onAuthErrorCallbacks.clear();
  }

  bool isSMSSent = false;
  static String _verificationId;
  //callbacks
  static Function() _callback;
  static Function() _autoAuthenticateTimeOutCallback;
  static Function() _onAuthenticatedCallback;
  static Function(dynamic e) _onOTPAuthenticationErrorCallback;
  static Function() _onSMSCodeCerifiedCallback;
  static Function() _onSignOutCalledCallback;
  static Function(dynamic e) _onAuthenticationErrorCallback;
  static Function() _onSMSSent;

  static List<Function(FirebaseAuthException)> _onAuthErrorCallbacks = List<Function(FirebaseAuthException)>();

  final codeSent = BehaviorSubject<bool>();
  final autoRetrievalTimeOut = BehaviorSubject<bool>();
  final verificationCompleted = BehaviorSubject<bool>();
  final verificationFailed = BehaviorSubject<bool>();
  final signInComplete = BehaviorSubject<bool>();
  final signInError = BehaviorSubject<bool>();



  void SignOut() {
    authInstance.signOut().then((value) {
      _onSignOutCalledCallback?.call();
    });
  }

  User getUser() {
    return authInstance.currentUser;
  }

  Stream<User> listenUserChanges() {
    return authInstance.userChanges();
  }

  Stream<User> listenAuthStateChanges() {
    return authInstance.authStateChanges();
  }

  //setters for callbacks
  // void onSMSSent(Function() callback) {
  //   _callback = callback;
  // }

  void onSignOut(Function() callback) {
    _onSignOutCalledCallback = callback;
  }

  void onAutoAuthenticateTimeOut(Function() callback) {
    _autoAuthenticateTimeOutCallback = callback;
  }

  void onAuthenticated(Function() callback) {
    _onAuthenticatedCallback = callback;
  }

  void onOTPAuthError(Function(dynamic e) callback) {
    _onOTPAuthenticationErrorCallback = callback;
  }

  void onAuthError(Function(dynamic e) onAuthenticationError){
    _onAuthErrorCallbacks.add(onAuthenticationError);
  }

  void onSMSSent(Function onSMSSentCallback){
    _onSMSSent = onSMSSentCallback;
  }

  static void onSMSCodeVerified(Function() callback) {
    _onSMSCodeCerifiedCallback = callback;
  }

  void verify(String phone) {
    authInstance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {
        verificationCompleted.add(true);
        print('Verification Complete ');
        print('Signing In ....... ');
        _onSMSCodeCerifiedCallback?.call();
        authInstance.signInWithCredential(credential).then((value) {
          signInComplete.add(true);
          print(' Authenticated ......... ' + value.user.phoneNumber);
          _onAuthenticatedCallback?.call();
        }).catchError((e) {
          _onAuthErrorCallbacks.forEach((element) {element(e);});
          clearOnAuthErrorCallbacks();
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Caught Exception Verification Failed. ');
        _onAuthErrorCallbacks.forEach((element) {element(e);});
        clearOnAuthErrorCallbacks();
      },
      codeSent: (String verificationId, int resendToken) async {
        _onSMSSent?.call();
        print('Code Sent ... ');
        print('vefification ID : $verificationId ');
        print('resendToken : $resendToken ');
        _verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('Auto Retrieval Timeout ');
        print('verificatino Id : $_verificationId ');
        _verificationId = verificationId;
        _autoAuthenticateTimeOutCallback?.call();
      },
      timeout: const Duration(seconds: 30)
    ).catchError((e) {
      _onAuthErrorCallbacks.forEach((element) {element(e);});
      clearOnAuthErrorCallbacks();
    });
  }

  void verifyCode(String code) {
    if (_verificationId != null) {
      var cred = PhoneAuthProvider.credential(verificationId: _verificationId, smsCode: code);
      authInstance.signInWithCredential(cred).then((value) {
        print(' Authenticated .........' + value.user.uid);
        _onAuthenticatedCallback?.call();
      }).catchError((e) {
        print('Error Authenticating ......' + e.toString());
        _onOTPAuthenticationErrorCallback.call(e);
      });
    }
  }
}