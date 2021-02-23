import 'package:flutter/material.dart';
import 'package:flutter_app/pages/bottom_nav.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:flutter_app/pages/service_find.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          backgroundColor: Color(0xFF1D1D27),
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BottomNav());
  }
}