import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';



class Util{

  static SnackBar showSnackBar(String text, String label, int duration) {
      return SnackBar(
        content: Text(text),
        action: SnackBarAction(label: label, onPressed: () {  },),
        duration: Duration(seconds: duration)
      );
  }

  static SnackBar showSnackBarWithContext(BuildContext context, String text, String label, int duration) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
          content: Text(text),
          action: SnackBarAction(label: label, onPressed: () {  },),
          duration: Duration(seconds: duration)
      ),
    );
  }

  static Stream<int> Mytimer(int seconds) async*{
    for(var i = seconds;i>-1;i--){
      await Future.delayed(Duration(seconds: 1));
      yield i;
    }
  }

  static showProgressDialog(BuildContext context) {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
  }

  static DateFormat formatDate() {
    return DateFormat("dd-MM-yyyy");
  }

  static void navigate(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }

  static void potUntil(BuildContext context, String route) {
    Navigator.of(context).popUntil(ModalRoute.withName(route));
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static Future<String> uploadFile(String _imagePath, String UID) async {
    Reference storageReference = FirebaseStorage.instance.ref().child(UID);

    UploadTask uploadTask = storageReference.putFile(File(_imagePath));
    await uploadTask.then((e){
      print("Upload Complete ${e.toString()}");
    }
    );
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      print("File URL ${fileURL.toString()}");
       return fileURL.toString();
    });
  }

  static Future<bool> checkNetworkConnectivity() async {
    bool isConnected = false;
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(Duration(seconds: 10));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        isConnected = true;
        return isConnected;
      }
    } on SocketException catch (e) {
      isConnected = false;
      print(e.message+' not connected');
      return isConnected;
    } on TimeoutException catch(_){
      print('Network timeout');
      isConnected = false;
      return isConnected;
    }
  }

  static void showToastMessage(String message, Color color, Color txtColor){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
      textColor: txtColor
    );
  }
}