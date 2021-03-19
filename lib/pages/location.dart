import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/update_profile.dart';
import 'package:flutter_app/style/local.keys.dart';
import 'package:flutter_app/style/palette.dart';
import 'package:easy_localization/easy_localization.dart';

import 'home.dart';

class LocationPage extends StatefulWidget {

  LocationPage({Key key}) : super(key: key);

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<LocationPage> {

  double height, width;
  AlertDialog alert;
  final messageController = TextEditingController();
  bool isSearch = false;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery
        .of(context)
        .size
        .width;
    height = MediaQuery
        .of(context)
        .size
        .height;


    SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
      body: Stack(
          children: [
            Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: new DecorationImage(
                        image: new AssetImage("assets/curve_back.png"),
                        fit:  BoxFit. fill
                    )
                )
            ),
            Positioned(
              top: (height/896) * 695,
              left: (width/414) * 305,
              child: Container(
                child: Image.asset("assets/curve.png",
                    fit:  BoxFit. fill),
              ),
            ),
            Positioned(
              top: (height/896) * 2,
              width: width,
              child:Center(
                child: Container(
                  height: (height/896) * 61,
                  child: Image.asset("assets/pink_art.png",
                  ),
                ),
              ),
            ),

            Positioned(
              top: (height/896) * 65,
              left: (width/414) * 16,
              child: GestureDetector(
                child: Center(
                child: Container(
                  height: (height/896) * 15,
                  width: (width/414) * 10,
                  child: Image.asset("assets/back.png"),
                ),
              ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
            ),
            Positioned(
              top: (height/896) * 565,
              left: (width/414) * 17,
              right: (width/414) * 17,
              child: GestureDetector(
                child: Center(
                  child: Container(
                    height: (height/896) * 128,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Palette.moreLightPink,
                    ),
                    child:
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(left: (width/208) * 5, right: (width/208) * 5 ),
                        height: (height/896) * 75,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Palette.boxWhite,
                        ),

                      ),
                    ),
                  ),
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
            ),
            Positioned(
              top: (height/896) * 730,
              left: (width/414) * 114,
              right: (width/414) * 114,
              child: GestureDetector(
                child: Center(
                  child: Container(
                    height: (height/896) * 50,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Palette.pinkBox,
                    ),
                    child:
                   Center(
                        child: Text(LocaleKeys.confirm,
                          style: TextStyle(
                            fontSize: 20,
                            color: Palette.whiteText,
                          ),).tr(),
                      ),
                    ),
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
            ),
          ]
      ),
    );
  }
}