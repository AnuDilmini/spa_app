// import 'package:flutter/material.dart';
// import 'package:flutter_app/enums/connectivity_status.dart';
// import 'package:provider/provider.dart';
//
// class NetworkSensitive extends StatelessWidget {
//   final String network;
//
//
//   NetworkSensitive({
//     this.network,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // Get our connection status from the provider
//     var connectionStatus = Provider.of<ConnectivityStatus>(context);
//
//     if (connectionStatus == ConnectivityStatus.WiFi) {
//       print("wifi");
//       return true;
//     }
//
//     if (connectionStatus == ConnectivityStatus.Cellular) {
//       print("wifi Cellular");
//       return false;
//     }
//
//     if (connectionStatus == ConnectivityStatus.Offline) {
//       print("wifi Offline");
//       return true;
//     }
//
//
//   }
// }