import 'package:phone_auth/services/network_status_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class NetworkAwareWidget extends StatelessWidget {
  final Widget onlineChild;
  final Widget offlineChild;

  const NetworkAwareWidget({Key key, this.onlineChild, this.offlineChild})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    NetworkStatus networkStatus = Provider.of<NetworkStatus>(context);
    if (networkStatus == NetworkStatus.Online) {
      // Util.showToastMessage("You're now Online!", Colors.green, Colors.white);
      return onlineChild;
    } else {
      // Util.showToastMessage("You're going to Offline", Colors.grey, Colors.white);
      return offlineChild;
    }
  }
}