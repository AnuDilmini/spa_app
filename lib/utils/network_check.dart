import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';

class NetworkCheck {

  List list;

  static Future<bool> checkNetwork() async{
    bool networkResults;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        networkResults = true;
      }
    } catch (e) {

      networkResults = false;
    }
    return networkResults;
  }

  static void showAlert(BuildContext context, String text) {
    var alert = new AlertDialog(
      content: Container(
        child: Row(
          children: <Widget>[Text(text)],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: TextStyle(color: Colors.blue),
            ))
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }
}

