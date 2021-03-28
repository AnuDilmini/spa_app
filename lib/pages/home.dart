
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

    var connectionStatus = Provider.of<ConnectivityStatus>(context);


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
          top: (height/449) * 20,
          width: width,
          child:Center(
            child: Container(
            width: (width/208) * 45,
            height: (width/208) * 45,
            child:
            Image.asset('assets/artboard3.png',
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
                      fontSize: 40,
                      color:  Palette.whiteText,
                      fontFamily: "Audrey-Medium"),
                ),
              Text( 'بنفسج',
                style: TextStyle(
                    height: 0.4,
                    letterSpacing: 1,
                    fontSize: 40,
                    color: Palette.whiteText,
                    fontFamily: "Ah-moharram-bold"
                )),
              ]
              ),
            ),
          ),
          Positioned(
            top: (height/449) * 150,
            width: width,
              child:  Center(
                child: Text(
                    LocaleKeys.choose_your_selection,
                  style: TextStyle(
                      fontSize: 25,
                      color: Palette.whiteText,
                      fontFamily: "Audrey-Medium"
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
                        top:  (width/208) * 55,
                        width:  (width/208) *71,
                        child: Center(
                          child: Text(
                            LocaleKeys.reservation,
                              textAlign : TextAlign.center,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 22,
                                // letterSpacing: 0.01,
                                color: Palette.whiteText,
                                fontFamily: "Audrey-Medium"
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
                            top:  (width/208) * 55,
                            width:  (width/208) *71,
                            child: Center(
                              child: Text(
                                  LocaleKeys.home_service,
                                  maxLines: 1,
                                  textAlign : TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      // letterSpacing: 0.01,
                                      color: Palette.whiteText,
                                      fontFamily: "Audrey-Medium"
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
                  MaterialPageRoute(builder: (context) => LocationPage()),
                );

              },
            ),
          ),
       ]
      )
    );
  }
}