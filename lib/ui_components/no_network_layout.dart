import 'package:flutter/material.dart';
import 'package:phone_auth/util/styles.dart';

class NoNetwork extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.signal_cellular_connected_no_internet_4_bar),
          Text("No internet", style: Styles.screenTitle,),
          Text('\n\nTry\n'+'\t\t\t\t1. Checking the network cables, modem, and router.\n'+'\t\t\t\t2. Reconnecting to Wi-Fi')
        ],
      ),
    );
  }
}
