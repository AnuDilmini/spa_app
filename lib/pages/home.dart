
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:violet_app/enums/connectivity_status.dart';
import 'package:violet_app/pages/network_sensitive.dart';
import 'package:violet_app/pages/service_find.dart';
import 'package:violet_app/style/local.keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:violet_app/style/palette.dart';
import 'package:provider/provider.dart';
import 'bottom_nav.dart';
import 'location.dart';

class HomePage extends StatefulWidget {

  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  double height, width;
  String lanCode = "en";
  double zoom = 1;

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

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    lanCode = context.locale.languageCode;
    if (lanCode == "ar") {
      zoom = 1.5;
    } else {
      zoom = 1;
    }

    SystemChrome.setEnabledSystemUIOverlays([]);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent, // transparent status bar
    //     statusBarIconBrightness: Brightness.dark));

    return Scaffold(
      backgroundColor: Palette.pinkBox,
      body: Stack(
        children: [
        Container(
          height: height,
          width: width,
        decoration: BoxDecoration(
        shape: BoxShape.rectangle,
         image: new DecorationImage(
          image: new AssetImage("assets/background.png"),
          fit: BoxFit.fill,
          )
        )
        ),

          Positioned(
          top: (height/449) * 10,
          width: width,
          child:Center(
            child: Container(
            width: (width/208) * 60,
            height: (width/208) * 60,
            child:
            Image.asset('assets/artboard_white.png',
            ),
          ),
          ),
        ),
          Positioned(
            top: (height/449) * 80,
            width: width,
            child:Center(
              child: Column(
                children:[
                Text(
                  'VIOLET',
                  style: TextStyle(
                    letterSpacing: 1,
                      fontSize: (height/896) *40,
                      color:  Palette.whiteText,
                      fontFamily: "Audrey-Medium"),
                ),
              Text( 'بنفسج',
                style: TextStyle(
                    height: 0.4,
                    letterSpacing: 1,
                    fontSize: (height/896) *40,
                    color: Palette.whiteText,
                  fontFamily: 'ArbFONTS-026',
                )),
              ]
              ),
            ),
          ),
          Positioned(
            top: lanCode == "en"? (height/449) * 150 : (height/449) * 140,
            width: width,
              child:  Center(
                child: Text(
                    LocaleKeys.choose_your_selection,
                  style: TextStyle(
                      fontSize: (height/896) * 27 * zoom,
                      color: Palette.whiteText,
                    fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                  )).tr(),
              ),
          ),
          Positioned(
            top: (height/449) * 193,
            width: width,
            child: GestureDetector(
              child: Center(
                child:  Container(
              width: (width/208) *75,
              height:  (width/208) * 75,
                 decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                color: Palette.pinkBox,
              ),
                  child: Stack(
                    children: [
                      Positioned(
                        top:  (width/208) * 8,
                        width:  (width/208) *75,
                          child: Container(
                              // margin: EdgeInsets.only(top: (width/208) * 2 ),
                              height: (width/208) * 50,
                              width: (width/208) * 50,
                              child:
                              Image.asset('assets/reservation.png',
                                fit: BoxFit.fitWidth,)
                          ),
                      ),
                      Positioned(
                        top:  lanCode == "en"?   (width/208) * 55 :  (width/208) * 48,
                        width:  (width/208) *71,
                        child: Center(
                          child: Text(
                            LocaleKeys.reservation,
                              textAlign : TextAlign.center,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: (height/896) * 23 * zoom,
                                // letterSpacing: 0.01,
                                color: Palette.whiteText,
                              fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                            )).tr(),
                        ),
                      ),
                    ],
                  )
            )
            ),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BottomNav(index: 0,)),
                );
              },
            ),
          ),
          Positioned(
            top: (height/449) *305,
            width: width,
            child: GestureDetector(
              child: Center(
                  child:  Container(
                      width: (width/208) *75,
                      height:  (width/208) * 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Palette.pinkBox,
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top:  (width/208) * 0,
                            width:  (width/208) *75,
                            child: Container(
                              // margin: EdgeInsets.only(top: (width/208) * 2 ),
                                height: (width/208) * 70,
                                width: (width/208) * 70,
                                child:
                                Image.asset('assets/home_service.png',
                                 )
                            ),
                          ),
                          Positioned(
                            top:  lanCode == "en"?   (width/208) * 55 :  (width/208) * 48,
                            width:  (width/208) *71,
                            child: Center(
                              child: Text(
                                  LocaleKeys.home_service,
                                  maxLines: 1,
                                  textAlign : TextAlign.center,
                                  style: TextStyle(
                                      fontSize: (height/896) * 22 * zoom,
                                      // letterSpacing: 0.01,
                                      color: Palette.whiteText,
                                    fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                  )).tr(),
                            ),
                          ),
                        ],
                      ),
                  )
              ),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BottomNav(index: 0,subIndex: 5,)),
                );

              },
            ),
          ),
       ]
      )
    );
  }
}